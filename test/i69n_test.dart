import 'package:i69n/i69n.dart';
import 'package:i69n/src/i69n_impl.dart';
import 'package:test/test.dart';
import 'package:yaml/yaml.dart';

void main() {
  group('Messages meta data', () {
    testMeta('messages', isDefault: true, defaultObjectName: 'Messages', objectName: 'Messages', languageCode: 'en', localeName: 'en');
    testMeta('messages_cs', isDefault: false, defaultObjectName: 'Messages', objectName: 'Messages_cs', languageCode: 'cs', localeName: 'cs');

    testMeta('domainMessages', isDefault: true, defaultObjectName: 'DomainMessages', objectName: 'DomainMessages', languageCode: 'en', localeName: 'en');
    testMeta('domainMessages_cs', isDefault: false, defaultObjectName: 'DomainMessages', objectName: 'DomainMessages_cs', languageCode: 'cs', localeName: 'cs');
    testMeta('domainMessages_cs_CZ', isDefault: false, defaultObjectName: 'DomainMessages', objectName: 'DomainMessages_cs_CZ', languageCode: 'cs', localeName: 'cs_CZ');
  });

  group('Plurals', () {
    test('en', () {
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

      prepareTodoList(null, null, todoList, loadYaml(yaml), root);
      todoList.sort((a, b) {
        return a.meta.objectName.compareTo(b.meta.objectName);
      });
      expect(todoList.length, equals(4));
      expect(todoList[0].meta.objectName, equals('FooTest'));
      expect(todoList[1].meta.objectName, equals('OrTest'));
      expect(todoList[2].meta.objectName, equals('StatusOrTest'));
      expect(todoList[2].meta.parent, equals(todoList[1].meta));
      expect(todoList[2].meta.parent.parent, equals(todoList[3].meta));
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
      expect(escapeDartString(r"'"), equals(r"\'")); // does escape '
      expect(escapeDartString(r"\"), equals(r"\\")); // does escape '
      expect(escapeDartString("\t"), equals(r"\t")); // does escape tab
      expect(escapeDartString("\n"), equals(r"\n")); // does escape \n
      expect(escapeDartString("""Multiline
message"""), equals(r"Multiline\nmessage")); // handles multiline strings
      expect(escapeDartString(r'${}'), equals(r'${}')); // doesn't escape inside ${...}
      expect(escapeDartString(r'\${}'), equals(r'\\${}')); // does escape outside ${...}
      expect(escapeDartString(r'${\}'), equals(r'${\}')); // doesn't escape inside ${...}
      expect(escapeDartString(r'${\}\${\}'), equals(r'${\}\\${\}')); // doesn't escape inside ${...}
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

      prepareTodoList(null, null, todoList, loadYaml(yaml), root);

      var output = StringBuffer();

      for (var todo in todoList) {
        renderTodoItem(todo, output);
        output.writeln('');
      }

      String result = output.toString();
      expect(result.contains("[] operator is disabled in en.or.something, see _i69n: nomap flag."), isTrue);
      expect(result.contains(r"String get subfoo => 'sub\'bar';"), isTrue); // automatically escaped
      expect(result.contains(r"String get a => 'A\'A';"), isTrue); // escaped by author
    });
  });
}

void testMeta(String name, {bool isDefault, String defaultObjectName, String objectName, String languageCode, String localeName}) {
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
