// ignore_for_file: prefer_single_quotes
import 'package:build/build.dart';
import 'package:i69n/i69n.dart';
import 'package:i69n/src/i69n_impl.dart';
import 'package:test/test.dart';
import 'package:yaml/yaml.dart';

import 'testMessages.i69n.dart';

void main() {
  group('Messages meta data', () {
    testMeta(
      'messages',
      isDefault: true,
      defaultObjectName: 'Messages',
      objectName: 'Messages',
      languageCode: 'en',
      localeName: 'en',
    );
    testMeta(
      'messages_cs',
      isDefault: false,
      defaultObjectName: 'Messages',
      objectName: 'Messages_cs',
      languageCode: 'cs',
      localeName: 'cs',
    );
    testMeta(
      'domainMessages',
      isDefault: true,
      defaultObjectName: 'DomainMessages',
      objectName: 'DomainMessages',
      languageCode: 'en',
      localeName: 'en',
    );
    testMeta(
      'domainMessages_cs',
      isDefault: false,
      defaultObjectName: 'DomainMessages',
      objectName: 'DomainMessages_cs',
      languageCode: 'cs',
      localeName: 'cs',
    );
    testMeta(
      'domainMessages_cs_CZ',
      isDefault: false,
      defaultObjectName: 'DomainMessages',
      objectName: 'DomainMessages_cs_CZ',
      languageCode: 'cs',
      localeName: 'cs_CZ',
    );
    testMeta(
      'domainMessages_fil_PH',
      isDefault: false,
      defaultObjectName: 'DomainMessages',
      objectName: 'DomainMessages_fil_PH',
      languageCode: 'fil',
      localeName: 'fil_PH',
    );
    testMeta(
      'domainMessages_fil',
      isDefault: false,
      defaultObjectName: 'DomainMessages',
      objectName: 'DomainMessages_fil',
      languageCode: 'fil',
      localeName: 'fil',
    );
  });

  group('Plurals', () {
    test('en', () {
      expect(plural(0, 'en', zero: 'ZERO!', one: 'ONE!', few: 'FEW!', other: 'OTHER!'), equals('ZERO!'));
      expect(plural(0, 'en', one: 'ONE!', few: 'FEW!', other: 'OTHER!'), equals('OTHER!'));
      expect(plural(1, 'en', one: 'ONE!', few: 'FEW!', other: 'OTHER!'), equals('ONE!'));
      expect(plural(2, 'en', one: 'ONE!', few: 'FEW!', other: 'OTHER!'), equals('OTHER!'));
      expect(plural(3, 'en', one: 'ONE!', few: 'FEW!', other: 'OTHER!'), equals('OTHER!'));
      expect(plural(10, 'en', one: 'ONE!', few: 'FEW!', other: 'OTHER!'), equals('OTHER!'));
    });

    test('cs', () {
      expect(plural(1, 'cs', one: 'ONE!', few: 'FEW!', other: 'OTHER!'), equals('ONE!'));
      expect(plural(2, 'cs', one: 'ONE!', few: 'FEW!', other: 'OTHER!'), equals('FEW!'));
      expect(plural(3, 'cs', one: 'ONE!', few: 'FEW!', other: 'OTHER!'), equals('FEW!'));
      expect(plural(10, 'cs', one: 'ONE!', few: 'FEW!', other: 'OTHER!'), equals('OTHER!'));
    });
  });

  group('Message building', () {
    test('Todo list', () {
      var root = ClassMeta();
      root.objectName = 'Test';
      root.defaultObjectName = 'Test';
      var todoList = <TodoItem>[];
      var yaml = 'foo:\n'
          '  subfoo: subbar\n'
          '  subfoo2: subbar2\n'
          'other: maybe\n'
          'or:\n'
          '  status:\n'
          '    name: not\n';

      prepareTodoList(null, null, todoList, loadYaml(yaml), root, null);
      todoList.sort((a, b) {
        return a.meta.objectName!.compareTo(b.meta.objectName!);
      });
      expect(todoList.length, equals(4));
      expect(todoList[0].meta.objectName, equals('FooTest'));
      expect(todoList[1].meta.objectName, equals('OrTest'));
      expect(todoList[2].meta.objectName, equals('StatusOrTest'));
      expect(todoList[2].meta.parent, equals(todoList[1].meta));
      expect(todoList[2].meta.parent!.parent, equals(todoList[3].meta));
      expect(todoList[3].meta.objectName, equals('Test'));
      expect(todoList[3].meta.parent, isNull);
    });
  });

  group('Dart rendering', () {
    test('String escape', () {
      expect(escapeDartString('qwertyuiop'), equals('qwertyuiop'));
      expect(escapeDartString('1232456789'), equals('1232456789'));
      expect(escapeDartString('+ěščřžýáí'), equals('+ěščřžýáí'));
      expect(escapeDartString('ネヨフ囲人ト横執所職'), equals('ネヨフ囲人ト横執所職')); // Japanese
      expect(escapeDartString('កើតមកមានសេរីភាព'), equals('កើតមកមានសេរីភាព')); // Khmer
      expect(escapeDartString(r'$'), equals(r'$')); // does't escape dollar sign
      expect(escapeDartString(r'"'), equals(r'"')); // does't escape "
      expect(escapeDartString(r"'"), equals(r"'")); // doesn't escape '
      expect(escapeDartString(r"\"), equals(r"\")); // doesn't escape \
      expect(escapeDartString("\t"), equals(r"\t")); // does escape tab
      expect(escapeDartString("\n"), equals(r"\n")); // does escape \n
      expect(escapeDartString("""Multiline
message"""), equals(r"Multiline\nmessage")); // handles multiline strings
      expect(
          escapeDartString(
              r"XX${_plural(count, zero: 'didn\'t find any tasks', one: 'found 1 task', other: 'found $count tasks')}YY"),
          equals(
              r"XX${_plural(count, zero: 'didn\'t find any tasks', one: 'found 1 task', other: 'found $count tasks')}YY")); // doesn't escape inside ${...}
    });

    test('Generated source code', () {
      var root = ClassMeta();
      root.objectName = 'Test';
      root.defaultObjectName = 'Test';
      root.isDefault = true;
      root.languageCode = "en";
      var todoList = <TodoItem>[];
      var yaml = 'foo:\n'
          '  subfoo: sub\'bar\n' // must me escaped
          '  subfoo2: subbar2\n'
          'other: maybe\n'
          'on: off\n'
          'or:\n' // shouldn't have [] operator
          '  something:\n'
          '    _i69n: nomap,noescape\n'
          '    a: A\\\'A\n' // inside 'noescape' flag, author must escape
          '    b: B\n'
          '    c: C\n'
          '  status:\n'
          '    name: not\n'
          '    name2: not2\n'
          '    name3: not3\n';

      prepareTodoList(null, null, todoList, loadYaml(yaml), root, null);

      var output = StringBuffer();

      for (var todo in todoList) {
        renderTodoItem(todo, output);
        output.writeln('');
      }

      var result = output.toString();
      expect(result.contains("[] operator is disabled in en.or.something, see _i69n: nomap flag."), isTrue);
      expect(result.contains("String get subfoo => \"sub'bar\";"), isTrue);
      expect(result.contains("String get a => \"A\\'A\";"), isTrue); // copied escape sequence
    });

    test('e2e test', () {
      var m = TestMessages();
      expect(m.apples.problematic(0), equals("didn't find any tasks"));
      expect(m.apples.problematic(1), equals("found 1 task"));
      expect(m.apples.problematic(2), equals("found 2 tasks"));
      expect(m.apples.problematic(3), equals("found 3 tasks"));
      expect(m.apples.quotes, equals('Hello "world"!'));
      expect(m.apples.quotes2, equals('Hello "world"!'));
    });
  });

  group('Global nomap functionality', () {
    test('Global nomap disabled by default', () {
      var root = ClassMeta();
      root.objectName = 'Test';
      root.defaultObjectName = 'Test';
      root.isDefault = true;
      root.languageCode = "en";
      var todoList = <TodoItem>[];
      var yaml = 'hello: "Hello"';

      prepareTodoList(null, null, todoList, loadYaml(yaml), root, null);

      var output = StringBuffer();
      for (var todo in todoList) {
        renderTodoItem(todo, output);
      }

      var result = output.toString();
      // Should contain switch-case block (operator[] enabled)
      expect(result.contains("switch(key)"), isTrue);
      expect(result.contains("case 'hello': return hello;"), isTrue);
    });

    test('Global nomap enabled', () {
      var root = ClassMeta();
      root.objectName = 'Test';
      root.defaultObjectName = 'Test';
      root.isDefault = true;
      root.languageCode = "en";
      var todoList = <TodoItem>[];
      var yaml = 'hello: "Hello"';

      // Mock BuilderOptions with nomap: true
      var mockOptions = _MockBuilderOptions({'nomap': true});
      prepareTodoList(null, null, todoList, loadYaml(yaml), root, mockOptions);

      var output = StringBuffer();
      for (var todo in todoList) {
        renderTodoItem(todo, output);
      }

      var result = output.toString();
      // Should not contain switch-case block (operator[] disabled)
      expect(result.contains("switch(key)"), isFalse);
      expect(result.contains("throw Exception('[] operator is disabled"), isTrue);
    });

    test('Local map overrides global nomap', () {
      var root = ClassMeta();
      root.objectName = 'Test';
      root.defaultObjectName = 'Test';
      root.isDefault = true;
      root.languageCode = "en";
      var todoList = <TodoItem>[];
      var yaml = '_i69n: map\nhello: "Hello"';

      // Mock BuilderOptions with nomap: true
      var mockOptions = _MockBuilderOptions({'nomap': true});
      prepareTodoList(null, null, todoList, loadYaml(yaml), root, mockOptions);

      var output = StringBuffer();
      for (var todo in todoList) {
        renderTodoItem(todo, output);
      }

      var result = output.toString();
      // Local 'map' should override global 'nomap'
      expect(result.contains("switch(key)"), isTrue);
      expect(result.contains("case 'hello': return hello;"), isTrue);
    });

    test('Local nomap overrides global setting', () {
      var root = ClassMeta();
      root.objectName = 'Test';
      root.defaultObjectName = 'Test';
      root.isDefault = true;
      root.languageCode = "en";
      var todoList = <TodoItem>[];
      var yaml = '_i69n: nomap\nhello: "Hello"';

      // Mock BuilderOptions with nomap: false (disabled)
      var mockOptions = _MockBuilderOptions({'nomap': false});
      prepareTodoList(null, null, todoList, loadYaml(yaml), root, mockOptions);

      var output = StringBuffer();
      for (var todo in todoList) {
        renderTodoItem(todo, output);
      }

      var result = output.toString();
      // Local 'nomap' should disable operator[] even when global is false
      expect(result.contains("switch(key)"), isFalse);
      expect(result.contains("throw Exception('[] operator is disabled"), isTrue);
    });

    test('nomap allows traverse (dot navigation)', () {
      var root = ClassMeta();
      root.objectName = 'Test';
      root.defaultObjectName = 'Test';
      root.isDefault = true;
      root.languageCode = "en";
      var todoList = <TodoItem>[];
      var yaml = '_i69n: nomap\nhello: "Hello"';

      var mockOptions = _MockBuilderOptions({'nomap': true});
      prepareTodoList(null, null, todoList, loadYaml(yaml), root, mockOptions);

      var output = StringBuffer();
      for (var todo in todoList) {
        renderTodoItem(todo, output);
      }

      var result = output.toString();
      // Should allow dot navigation but disable switch-case
      expect(result.contains("var index = key.indexOf('.');"), isTrue);
      expect(result.contains("switch(key)"), isFalse);
      expect(result.contains("see _i69n: nomap flag"), isTrue);
    });

    test('notraverse disables dot navigation', () {
      var root = ClassMeta();
      root.objectName = 'Test';
      root.defaultObjectName = 'Test';
      root.isDefault = true;
      root.languageCode = "en";
      var todoList = <TodoItem>[];
      var yaml = '_i69n: notraverse\nhello: "Hello"';

      var mockOptions = _MockBuilderOptions({'notraverse': true});
      prepareTodoList(null, null, todoList, loadYaml(yaml), root, mockOptions);

      var output = StringBuffer();
      for (var todo in todoList) {
        renderTodoItem(todo, output);
      }

      var result = output.toString();
      // Should disable only dot navigation, switch-case should work
      expect(result.contains("switch(key)"), isTrue);
      expect(result.contains("case 'hello': return hello;"), isTrue);
    });

    test('nomap + notraverse disables everything', () {
      var root = ClassMeta();
      root.objectName = 'Test';
      root.defaultObjectName = 'Test';
      root.isDefault = true;
      root.languageCode = "en";
      var todoList = <TodoItem>[];
      var yaml = '_i69n: nomap,notraverse\nhello: "Hello"';

      prepareTodoList(null, null, todoList, loadYaml(yaml), root, null);

      var output = StringBuffer();
      for (var todo in todoList) {
        renderTodoItem(todo, output);
      }

      var result = output.toString();
      // Should disable everything
      expect(result.contains("var index = key.indexOf('.');"), isFalse);
      expect(result.contains("switch(key)"), isFalse);
      expect(result.contains("see _i69n: nomap, notraverse flag"), isTrue);
    });
  });
}

void testMeta(String name,
    {bool? isDefault, String? defaultObjectName, String? objectName, String? languageCode, String? localeName}) {
  var meta = generateMessageObjectName(name);
  test('$name: isDefault', () {
    expect(meta.isDefault, equals(isDefault));
  });
  test('$name: defaultObjectName', () {
    expect(meta.defaultObjectName, equals(defaultObjectName));
  });
  test('$name: objectName', () {
    expect(meta.objectName, equals(objectName));
  });
  test('$name: localeName', () {
    expect(meta.localeName, equals(localeName));
  });
  test('$name: languageCode', () {
    expect(meta.languageCode, equals(languageCode));
  });
}

class _MockBuilderOptions implements BuilderOptions {
  final Map<String, dynamic> _config;

  _MockBuilderOptions(this._config);

  @override
  Map<String, dynamic> get config => _config;

  @override
  dynamic noSuchMethod(Invocation invocation) => null;
}
