// ignore_for_file: unused_element, unused_field, camel_case_types, annotate_overrides, prefer_single_quotes
// GENERATED FILE, do not edit!
import 'package:i69n/i69n.dart' as i69n;

String get _languageCode => 'en';
String get _localeName => 'en';

String _plural(int count, {String? zero, String? one, String? two, String? few, String? many, String? other}) =>
    i69n.plural(count, _languageCode, zero: zero, one: one, two: two, few: few, many: many, other: other);
String _ordinal(int count, {String? zero, String? one, String? two, String? few, String? many, String? other}) =>
    i69n.ordinal(count, _languageCode, zero: zero, one: one, two: two, few: few, many: many, other: other);
String _cardinal(int count, {String? zero, String? one, String? two, String? few, String? many, String? other}) =>
    i69n.cardinal(count, _languageCode, zero: zero, one: one, two: two, few: few, many: many, other: other);

class ExampleMessages implements i69n.I69nMessageBundle {
  const ExampleMessages();
  GenericExampleMessages get generic => GenericExampleMessages(this);
  InvoiceExampleMessages get invoice => InvoiceExampleMessages(this);
  ApplesExampleMessages get apples => ApplesExampleMessages(this);
  Object operator [](String key) {
    var index = key.indexOf('.');
    if (index > 0) {
      return (this[key.substring(0, index)] as i69n.I69nMessageBundle)[key.substring(index + 1)];
    }
    switch (key) {
      case 'generic':
        return generic;
      case 'invoice':
        return invoice;
      case 'apples':
        return apples;
      default:
        return key;
    }
  }
}

class GenericExampleMessages implements i69n.I69nMessageBundle {
  final ExampleMessages _parent;
  const GenericExampleMessages(this._parent);
  String get ok => "OK";
  String get done => "DONE";
  String get letsGo => "Let's go!";
  Object operator [](String key) {
    var index = key.indexOf('.');
    if (index > 0) {
      return (this[key.substring(0, index)] as i69n.I69nMessageBundle)[key.substring(index + 1)];
    }
    switch (key) {
      case 'ok':
        return ok;
      case 'done':
        return done;
      case 'letsGo':
        return letsGo;
      default:
        return key;
    }
  }
}

class InvoiceExampleMessages implements i69n.I69nMessageBundle {
  final ExampleMessages _parent;
  const InvoiceExampleMessages(this._parent);
  String get create => "Create invoice";
  String get delete => "Delete  invoice";
  String get help => "Use this function to generate new invoices and stuff. Awesome!";
  String count(int cnt) => "You have created $cnt ${_plural(cnt, one: 'invoice', many: 'invoices')}.";
  Object operator [](String key) {
    var index = key.indexOf('.');
    if (index > 0) {
      return (this[key.substring(0, index)] as i69n.I69nMessageBundle)[key.substring(index + 1)];
    }
    throw Exception('[] operator is disabled in en.invoice, see _i69n: nomap flag.');
  }
}

class ApplesExampleMessages implements i69n.I69nMessageBundle {
  final ExampleMessages _parent;
  const ApplesExampleMessages(this._parent);
  String _apples(int cnt) => "${_plural(cnt, zero: 'no apples', one: '$cnt apple', many: '$cnt apples')}";
  String count(int cnt) => "You have eaten ${_apples(cnt)}.";
  Object operator [](String key) {
    var index = key.indexOf('.');
    if (index > 0) {
      return (this[key.substring(0, index)] as i69n.I69nMessageBundle)[key.substring(index + 1)];
    }
    switch (key) {
      case '_apples':
        return _apples;
      case 'count':
        return count;
      default:
        return key;
    }
  }
}
