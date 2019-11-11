library i69n;

import 'package:yaml/yaml.dart';
import 'package:dart_style/dart_style.dart';

part 'model.dart';

Pattern twoCharsLower = RegExp("^[a-z]{2}\$");
Pattern twoCharsUpper = RegExp("^[A-Z]{2}\$");

String generateDartContentFromYaml(ClassMeta meta, String yamlContent) {
  YamlMap messages = loadYaml(yamlContent);

  List<TodoItem> todoList = [];

  prepareTodoList(todoList, messages, meta);

  StringBuffer output = StringBuffer();

  output.writeln(
      "// ignore_for_file: unused_element, unused_field, camel_case_types");
  output.writeln("// GENERATED FILE, do not edit!");
  output.writeln("import 'package:i69n/i69n.dart' as i69n;");
  if (meta.defaultFileName != null) {
    output.writeln("import '${meta.defaultFileName}';");
  }
  output.writeln("");
  output.writeln("String get _languageCode => '${meta.languageCode}';");
  output.writeln("String get _localeName => '${meta.localeName}';");
  output.writeln("");
  output.writeln(
      "String _plural(int count, {String zero, String one, String two, String few, String many, String other}) =>");
  output.writeln(
      "\ti69n.plural(count, _languageCode, zero:zero, one:one, two:two, few:few, many:many, other:other);");
  output.writeln(
      "String _ordinal(int count, {String zero, String one, String two, String few, String many, String other}) =>");
  output.writeln(
      "\ti69n.ordinal(count, _languageCode, zero:zero, one:one, two:two, few:few, many:many, other:other);");
  output.writeln(
      "String _cardinal(int count, {String zero, String one, String two, String few, String many, String other}) =>");
  output.writeln(
      "\ti69n.cardinal(count, _languageCode, zero:zero, one:one, two:two, few:few, many:many, other:other);");
  output.writeln("");

  for (var todo in todoList) {
    renderTodoItem(todo, output);
    output.writeln("");
  }
  var formatter = DartFormatter();
  return formatter.format(output.toString());
}

ClassMeta generateMessageObjectName(String fileName) {
  String name = fileName.replaceAll(".i69n.yaml", "");

  List<String> nameParts = name.split("_");
  if (nameParts.isEmpty) {
    throw Exception(_renderFileNameError(name));
  }

  ClassMeta result = ClassMeta();

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
      throw Exception(_renderFileNameError(name));
    }
    if (nameParts.length >= 2) {
      String languageCode = nameParts[1];
      if (twoCharsLower.allMatches(languageCode).length != 1) {
        throw Exception(
            "Wrong language code '$languageCode' in file name '$fileName'. Language code must match $twoCharsLower");
      }
      result.languageCode = languageCode;
      result.localeName = languageCode;
    }
    if (nameParts.length == 3) {
      String countryCode = nameParts[2];
      if (twoCharsUpper.allMatches(countryCode).length != 1) {
        throw Exception(
            "Wrong country code '$countryCode' in file name '$fileName'. Country code must match $twoCharsUpper");
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
    output.writeln(
        "class ${meta.objectName} implements i69n.I69nMessageBundle {");
  } else {
    output.writeln(
        "class ${meta.objectName} extends ${meta.defaultObjectName} {");
  }

  if (meta.parent == null) {
    output.writeln("\tconst ${meta.objectName}();");
  } else {
    output.writeln("\tfinal ${meta.parent.objectName} _parent;");
    if (meta.isDefault) {
      output.writeln("\tconst ${meta.objectName}(this._parent);");
    } else {
      output
          .writeln("\tconst ${meta.objectName}(this._parent):super(_parent);");
    }
  }
  content.forEach((k, v) {
    if (v is YamlMap) {
      String prefix = _firstCharUpper(k);
      ClassMeta child = meta.nest(prefix);
      output.writeln(
          "\t${child.objectName} get ${k} => ${child.objectName}(this);");
    } else {
      if (k.contains("(")) {
        // function
        output.writeln('\tString ${k} => "${v}";');
      } else {
        if (k.contains(".")) {
          throw Exception("Your message key cannot contain a dot, see '$k'");
        }
        output.writeln('\tString get ${k} => "${v}";');
      }
    }
  });
  output.writeln("\tObject operator[](String key) {");
  output.writeln("\t\tint index = key.indexOf('.');");
  output.writeln("\t\tif (index > 0) {");
  output.writeln(
      "\t\t\treturn (this[key.substring(0,index)] as i69n.I69nMessageBundle)[key.substring(index+1)];");
  output.writeln("\t\t}");
  output.writeln("\t\tswitch(key) {");
  content.forEach((k, v) {
    String key = k;
    if (key.contains('(')) {
      key = key.substring(0, key.indexOf('('));
    }
    output.writeln("\t\t\tcase '$key': return $key;");
  });
  if (meta.isDefault) {
    output.writeln(
        "\t\t\tdefault: throw Exception(\"Message \'\$key\' doesn\'t exist in \$this\");");
  } else {
    output.writeln("\t\t\tdefault: return super[key];");
  }
  output.writeln("\t\t}");
  output.writeln("\t}");

  output.writeln("}");
}

void prepareTodoList(
    List<TodoItem> todoList, YamlMap messages, ClassMeta name) {
  TodoItem todo = TodoItem(name, messages);
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
