// ignore_for_file: unused_element, unused_field, camel_case_types, annotate_overrides, prefer_single_quotes
// GENERATED FILE, do not edit!
import 'package:i69n/i69n.dart' as i69n;
import 'dart:io';

String get _languageCode => 'sk';
String get _localeName => 'en';

String _plural(int count, {String? zero, String? one, String? two, String? few, String? many, String? other}) =>
    i69n.plural(count, _languageCode, zero: zero, one: one, two: two, few: few, many: many, other: other);
String _ordinal(int count, {String? zero, String? one, String? two, String? few, String? many, String? other}) =>
    i69n.ordinal(count, _languageCode, zero: zero, one: one, two: two, few: few, many: many, other: other);
String _cardinal(int count, {String? zero, String? one, String? two, String? few, String? many, String? other}) =>
    i69n.cardinal(count, _languageCode, zero: zero, one: one, two: two, few: few, many: many, other: other);

class TestMessages implements i69n.I69nMessageBundle {
  const TestMessages();
  GenericTestMessages get generic => GenericTestMessages(this);
  InvoiceTestMessages get invoice => InvoiceTestMessages(this);
  ApplesTestMessages get apples => ApplesTestMessages(this);
  FriendsTestMessages get friends => FriendsTestMessages(this);
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
      case 'friends':
        return friends;
      default:
        return key;
    }
  }
}

class GenericTestMessages implements i69n.I69nMessageBundle {
  final TestMessages _parent;
  const GenericTestMessages(this._parent);
  String get ok => "OK";
  String get done => "DONE";
  String get letsGo => "Let's go!";
  String ordinalNumber(int n) => "${_ordinal(n, one: '1st', two: '2nd', few: '3rd', other: '${n}th')}";
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
      case 'ordinalNumber':
        return ordinalNumber;
      default:
        return key;
    }
  }
}

class InvoiceTestMessages implements i69n.I69nMessageBundle {
  final TestMessages _parent;
  const InvoiceTestMessages(this._parent);
  String get create => "Create invoice";
  String get delete => "Delete  invoice";
  String get help => "Use this function to generate new invoices and stuff. Awesome!";
  String count(int cnt) => "You have created $cnt ${_plural(cnt, one: 'invoice', many: 'invoices')}.";
  String get something => "Let\'s go!";
  Object operator [](String key) {
    var index = key.indexOf('.');
    if (index > 0) {
      return (this[key.substring(0, index)] as i69n.I69nMessageBundle)[key.substring(index + 1)];
    }
    throw Exception('[] operator is disabled in en.invoice, see _i69n: nomap flag.');
  }
}

class ApplesTestMessages implements i69n.I69nMessageBundle {
  final TestMessages _parent;
  const ApplesTestMessages(this._parent);
  String _apples(int cnt) => "${_plural(cnt, zero: 'no apples', one: '$cnt apple', many: '$cnt apples')}";
  String count(int cnt) => "You have eaten ${_apples(cnt)}.";
  String problematic(int count) => "${_plural(count, zero: 'didn\'t find any tasks', one: 'found 1 task', other: 'found $count tasks')}";
  String get anotherProblem => "here\nthere";
  String get quotes => "Hello \"world\"!";
  String get quotes2 => "Hello \"world\"!";
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
      case 'problematic':
        return problematic;
      case 'anotherProblem':
        return anotherProblem;
      case 'quotes':
        return quotes;
      case 'quotes2':
        return quotes2;
      default:
        return key;
    }
  }
}

class FriendsTestMessages implements i69n.I69nMessageBundle {
  final TestMessages _parent;
  const FriendsTestMessages(this._parent);
  MichaelFriendsTestMessages get michael => MichaelFriendsTestMessages(this);
  EvaFriendsTestMessages get eva => EvaFriendsTestMessages(this);
  Object operator [](String key) {
    var index = key.indexOf('.');
    if (index > 0) {
      return (this[key.substring(0, index)] as i69n.I69nMessageBundle)[key.substring(index + 1)];
    }
    switch (key) {
      case 'michael':
        return michael;
      case 'eva':
        return eva;
      default:
        return key;
    }
  }
}

class MichaelFriendsTestMessages implements i69n.I69nMessageBundle {
  final FriendsTestMessages _parent;
  const MichaelFriendsTestMessages(this._parent);
  String get name => "Aaaaa";
  String get description => "Aa Aa Aa";
  Object operator [](String key) {
    var index = key.indexOf('.');
    if (index > 0) {
      return (this[key.substring(0, index)] as i69n.I69nMessageBundle)[key.substring(index + 1)];
    }
    switch (key) {
      case 'name':
        return name;
      case 'description':
        return description;
      default:
        return key;
    }
  }
}

class EvaFriendsTestMessages implements i69n.I69nMessageBundle, MichaelFriendsTestMessages {
  final FriendsTestMessages _parent;
  const EvaFriendsTestMessages(this._parent);
  String get _i69n_implements => "MichaelFriendsTestMessages";
  String get name => "Bbbbb";
  String get description => "Bb Bb Bb";
  Object operator [](String key) {
    var index = key.indexOf('.');
    if (index > 0) {
      return (this[key.substring(0, index)] as i69n.I69nMessageBundle)[key.substring(index + 1)];
    }
    switch (key) {
      case '_i69n_implements':
        return _i69n_implements;
      case 'name':
        return name;
      case 'description':
        return description;
      default:
        return key;
    }
  }
}
