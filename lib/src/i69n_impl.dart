library i69n;

import 'package:dart_style/dart_style.dart';
import 'package:yaml/yaml.dart';

part 'model.dart';

Pattern twoCharsLower = RegExp('^[a-z]{2,3}\$');
Pattern twoCharsUpper = RegExp('^[A-Z]{2,3}\$');

String generateDartContentFromYaml(ClassMeta meta, String yamlContent) {
  var messages = (loadYaml(yamlContent) as YamlMap);

  var todoList = <TodoItem>[];

  prepareTodoList(null, null, todoList, messages, meta);

  var output = StringBuffer();

  output.writeln('// ignore_for_file: unused_element, unused_field, camel_case_types, annotate_overrides, prefer_single_quotes');
  output.writeln('// GENERATED FILE, do not edit!');
  output.writeln('import \'package:i69n/i69n.dart\' as i69n;');
  if (meta.defaultFileName != null) {
    output.writeln('import \'${meta.defaultFileName}\';');
  }

  String? i = todoList.first.flagValue("import");
  if (i != null) {
    List<String> imports = i.split(",");
    for (String import in imports) {
      import = import.trim();
      if (import.isNotEmpty) {
        output.writeln('import \'${import}\';');
      }
    }
  }

  String nullableChar = todoList.first.hasFlag('prenullsafe') ? '' : '?';

  var lang = todoList.first.flagValue("language") ?? meta.languageCode;

  output.writeln('');
  output.writeln('String get _languageCode => \'${lang}\';');
  output.writeln('String get _localeName => \'${meta.localeName}\';');
  output.writeln('');
  output.writeln(
      'String _plural(int count, {String$nullableChar zero, String$nullableChar one, String$nullableChar two, String$nullableChar few, String$nullableChar many, String$nullableChar other}) =>');
  output.writeln('\ti69n.plural(count, _languageCode, zero:zero, one:one, two:two, few:few, many:many, other:other);');
  output.writeln(
      'String _ordinal(int count, {String$nullableChar zero, String$nullableChar one, String$nullableChar two, String$nullableChar few, String$nullableChar many, String$nullableChar other}) =>');
  output.writeln('\ti69n.ordinal(count, _languageCode, zero:zero, one:one, two:two, few:few, many:many, other:other);');
  output.writeln(
      'String _cardinal(int count, {String$nullableChar zero, String$nullableChar one, String$nullableChar two, String$nullableChar few, String$nullableChar many, String$nullableChar other}) =>');
  output.writeln('\ti69n.cardinal(count, _languageCode, zero:zero, one:one, two:two, few:few, many:many, other:other);');
  output.writeln('');

  for (var todo in todoList) {
    renderTodoItem(todo, output);
    output.writeln('');
  }
  try {
    var formatter = DartFormatter(
      languageVersion: DartFormatter.latestShortStyleLanguageVersion,
    );
    return formatter.format(output.toString());
  } catch (e) {
    print(
        'Cannot format ${meta.languageCode}, ${meta.defaultObjectName} messages. You might need to escape some special characters with a backslash. Please investigate generated class.');
    return output.toString();
  }
}

ClassMeta generateMessageObjectName(String fileName) {
  var name = fileName.replaceAll('.i69n.yaml', '');

  var nameParts = name.split('_');
  if (nameParts.isEmpty) {
    throw Exception(_renderFileNameError(name));
  }

  var result = ClassMeta();

  result.defaultObjectName = _firstCharUpper(nameParts[0]);

  if (nameParts.length == 1) {
    result.objectName = result.defaultObjectName;
    result.isDefault = true;
    result.languageCode = 'en';
    result.localeName = 'en';
    return result;
  } else {
    result.defaultFileName = '${nameParts[0]}.i69n.dart';
    result.isDefault = false;

    if (nameParts.length > 3) {
      throw Exception(_renderFileNameError(name));
    }
    if (nameParts.length >= 2) {
      var languageCode = nameParts[1];
      if (twoCharsLower.allMatches(languageCode).length != 1) {
        throw Exception('Wrong language code $languageCode in file name $fileName. Language code must match $twoCharsLower');
      }
      result.languageCode = languageCode;
      result.localeName = languageCode;
    }
    if (nameParts.length == 3) {
      var countryCode = nameParts[2];
      if (twoCharsUpper.allMatches(countryCode).length != 1) {
        throw Exception('Wrong country code $countryCode in file name $fileName. Country code must match $twoCharsUpper');
      }
      result.localeName = '${result.languageCode}_$countryCode';
    }
    result.objectName = '${result.defaultObjectName}_${result.localeName}';
    return result;
  }
}

void renderTodoItem(TodoItem todo, StringBuffer output) {
  var meta = todo.meta;

  String? implements = todo.flagValue("implements");

  if (meta.isDefault!) {
    String i = "";
    if (implements != null) {
      i = ", $implements";
    }
    output.writeln('class ${meta.objectName} implements i69n.I69nMessageBundle$i {');
  } else {
    String i = "";
    if (implements != null) {
      i = " implements $implements";
    }
    output.writeln('class ${meta.objectName} extends ${meta.defaultObjectName} $i {');
  }

  if (meta.parent == null) {
    output.writeln('\tconst ${meta.objectName}();');
  } else {
    output.writeln('\tfinal ${meta.parent!.objectName} _parent;');
    if (meta.isDefault!) {
      output.writeln('\tconst ${meta.objectName}(this._parent);');
    } else {
      output.writeln('\tconst ${meta.objectName}(this._parent):super(_parent);');
    }
  }

  renderTodoItemProperties(todo, output);

  renderTodoItemMapOperator(todo, output);

  output.writeln('}');
}

const _reserved = ['_i69n', '_i69n_language', '_i69n_import'];

void renderTodoItemMapOperator(TodoItem todo, StringBuffer output) {
  output.writeln('\tObject operator[](String key) {');
  output.writeln('\t\tvar index = key.indexOf(\'.\');');
  output.writeln('\t\tif (index > 0) {');
  output.writeln('\t\t\treturn (this[key.substring(0,index)] as i69n.I69nMessageBundle)[key.substring(index+1)];');
  output.writeln('\t\t}');
  if (!todo.hasFlag('nomap')) {
    output.writeln('\t\tswitch(key) {');
    todo.content.forEach((k, v) {
      if (!_reserved.contains(k)) {
        String key = k;
        if (key.contains('(')) {
          key = key.substring(0, key.indexOf('('));
        }
        output.writeln('\t\t\tcase \'$key\': return $key;');
      }
    });
    if (todo.meta.isDefault!) {
      if (todo.hasInheritedFlag('nothrow')) {
        output.writeln('\t\t\tdefault: throw Exception(\'Message \$key doesn\\\'t exist in \$this\');');
      } else {
        output.writeln('\t\t\tdefault: return key;');
      }
    } else {
      output.writeln('\t\t\tdefault: return super[key];');
    }
    output.writeln('\t\t}');
  } else {
    output.writeln('\t\tthrow Exception(\'[] operator is disabled in ${todo.path}, see _i69n: nomap flag.\');');
  }
  output.writeln('\t}');
}

void renderTodoItemProperties(TodoItem todo, StringBuffer output) {
  var _escapeFunction = escapeDartString;
  if (todo.hasFlag('noescape')) {
    _escapeFunction = (String? s) => s;
  }
  todo.content.forEach((k, v) {
    if (!_reserved.contains(k)) {
      if (v is YamlMap) {
        var prefix = _firstCharUpper(k);
        var child = todo.meta.nest(prefix);
        output.writeln('\t${child.objectName} get $k => ${child.objectName}(this);');
      } else {
        if (k.contains('(')) {
          // function
          output.writeln('\tString $k => "${_escapeFunction(v)}";');
        } else {
          if (k.contains('.')) {
            throw Exception('Your message key cannot contain a dot, see $k');
          }
          output.writeln('\tString get $k => "${_escapeFunction(v)}";');
        }
      }
    }
  });
}

void prepareTodoList(String? prefix, TodoItem? parent, List<TodoItem> todoList, YamlMap messages, ClassMeta name) {
  var todo = TodoItem(prefix, parent, name, messages);
  todoList.add(todo);

  messages.forEach((k, v) {
    if (v is YamlMap) {
      var prefix = _firstCharUpper(k);
      prepareTodoList(k, todo, todoList, v, name.nest(prefix));
    }
  });
}

String _firstCharUpper(String s) {
  return s.replaceRange(0, 1, s[0].toUpperCase());
}

String _renderFileNameError(String name) {
  return 'Wrong file name: "$name"';
}

String? escapeDartString(String? string) {
  if (string == null) {
    return null;
  }
  if (string.isEmpty) {
    return string;
  }
  var sb = StringBuffer();
  var i = 0;

  for (var c in string.runes) {
    switch (c) {
      case 9:
        sb.write('\\t');
        break;
      case 10:
        sb.write('\\n');
        break;
      case 13:
        sb.write('\\r');
        break;
      default:
        sb.write(string[i]);
    }
    i++;
  }
  return sb.toString();
}
