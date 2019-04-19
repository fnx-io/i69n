library i69n;

import 'package:yaml/yaml.dart';

part 'model.dart';

Pattern twoCharsLower = new RegExp("^[a-z]{2}\$");
Pattern twoCharsUpper = new RegExp("^[A-Z]{2}\$");

String generateDartContentFromYaml(ClassMeta meta, String yamlContent) {
  YamlMap messages = loadYaml(yamlContent);

  List<TodoItem> todoList = [];

  prepareTodoList(todoList, messages, meta);

  StringBuffer output = new StringBuffer();

  output.writeln("// GENERATED FILE (${new DateTime.now()}), do not edit!");
  output.writeln("import 'package:i69n/i69n.dart' as i69n;");
  if (meta.defaultFileName != null) {
    output.writeln("import '${meta.defaultFileName}';");
  }
  output.writeln("");
  output.writeln("String get _languageCode => '${meta.languageCode}';");
  output.writeln("String get _localeName => '${meta.localeName}';");
  output.writeln("");
  output.writeln("String _plural(int count, {String zero, String one, String two, String few, String many, String other})");
  output.writeln("\t=>i69n.plural(count, _languageCode, zero:zero, one:one, two:two, few:few, many:many, other:other);");
  output.writeln("String _ordinal(int count, {String zero, String one, String two, String few, String many, String other})");
  output.writeln("\t=>i69n.ordinal(count, _languageCode, zero:zero, one:one, two:two, few:few, many:many, other:other);");
  output.writeln("String _cardinal(int count, {String zero, String one, String two, String few, String many, String other})");
  output.writeln("\t=>i69n.cardinal(count, _languageCode, zero:zero, one:one, two:two, few:few, many:many, other:other);");
  output.writeln("");

  for (var todo in todoList) {
    renderTodoItem(todo, output);
    output.writeln("");
  }

  return output.toString();
}

ClassMeta generateMessageObjectName(String fileName) {
  String name = fileName.replaceAll(".i69n.yaml", "");

  List<String> nameParts = name.split("_");
  if (nameParts.length < 1) {
    throw new Exception(_renderFileNameError(name));
  }

  ClassMeta result = new ClassMeta();

  result.defaultObjectName = _firstCharUpper(nameParts[0]);

  if (nameParts.length == 1) {
    result.objectName = result.defaultObjectName;
    result.isDefault = true;
    result.languageCode = "en";
    result.localeName = "en";
    return result;
  } else {
    result.defaultFileName = "${nameParts[0]}.i69n.dart";
    result.isDefault = false;

    if (nameParts.length > 3) {
      throw new Exception(_renderFileNameError(name));
    }
    if (nameParts.length >= 2) {
      String languageCode = nameParts[1];
      if (twoCharsLower.allMatches(languageCode).length != 1) {
        throw new Exception("Wrong language code '$languageCode' in file name '$fileName'. Language code must match $twoCharsLower");
      }
      result.languageCode = languageCode;
      result.localeName = languageCode;
    }
    if (nameParts.length == 3) {
      String countryCode = nameParts[2];
      if (twoCharsUpper.allMatches(countryCode).length != 1) {
        throw new Exception("Wrong country code '$countryCode' in file name '$fileName'. Country code must match $twoCharsUpper");
      }
      result.localeName = "${result.languageCode}_${countryCode}";
    }
    result.objectName = "${result.defaultObjectName}_${result.localeName}";
    return result;
  }
}

void renderTodoItem(TodoItem todo, StringBuffer output) {
  var meta = todo.meta;
  YamlMap content = todo.content;
  if (meta.isDefault) {
    output.writeln("class ${meta.objectName} {");
  } else {
    output.writeln("class ${meta.objectName} extends ${meta.defaultObjectName} {");
  }

  if (meta.parent == null) {
    output.writeln("\tconst ${meta.objectName}();");
  } else {
    output.writeln("\tfinal ${meta.parent.objectName} _parent;");
    if (meta.isDefault) {
      output.writeln("\tconst ${meta.objectName}(this._parent);");
    } else {
      output.writeln("\tconst ${meta.objectName}(this._parent):super(_parent);");
    }
  }
  content.forEach((k, v) {
    if (v is YamlMap) {
      String prefix = _firstCharUpper(k);
      ClassMeta child = meta.nest(prefix);
      output.writeln("\t${child.objectName} get ${k} => ${child.objectName}(this);");
    } else {
      if (k.contains("(")) {
        // function
        output.writeln('\tString ${k} => "${v}";');
      } else {
        output.writeln('\tString get ${k} => "${v}";');
      }
    }
  });
  output.writeln("}");
}

void prepareTodoList(List<TodoItem> todoList, YamlMap messages, ClassMeta name) {
  TodoItem todo = new TodoItem(name, messages);
  todoList.add(todo);

  messages.forEach((k, v) {
    if (v is YamlMap) {
      String prefix = _firstCharUpper(k);
      prepareTodoList(todoList, v, name.nest(prefix));
    }
  });
}

String _firstCharUpper(String s) {
  return s.replaceRange(0, 1, s[0].toUpperCase());
}

String _renderFileNameError(String name) {
  return "Wrong file name: '$name'";
}
