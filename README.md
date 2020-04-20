Simple internationalization (i18n) package for Dart and Flutter.

[![Build Status](https://travis-ci.org/fnx-io/i69n.svg?branch=master)](https://travis-ci.org/fnx-io/i69n)
[![pub package](https://img.shields.io/badge/pub.dev-i69n-brightgreen)](https://pub.dev/packages/i69n)
[![open source](https://img.shields.io/badge/Github-i69n-brightgreen)](https://github.com/fnx-io/i69n)

**Supports:**

- AngularDart
- Flutter hot reload
- deferred loading of translations
- social distancing

(Migrating from < 1.0 to >= 1.0 ? See few notes at the very bottom of this page.) 

# Overview

Turn this **YAML** file:

    lib/exampleMessages.i69n.yaml
    
    button:
      save: Save
      load: Load
    users:
      welcome(String name): "Hello $name!"
      logout: Logout
  
Into these **generated** Dart classes:

    class ExampleMessages {
        const ExampleMessages();
        ButtonExampleMessages get button => ButtonExampleMessages(this);
        UsersExampleMessages get users => UsersExampleMessages(this);
    }
    class ButtonExampleMessages {
        final ExampleMessages _parent;
        const ButtonExampleMessages(this._parent);
        String get save => "Save";
        String get load => "Load";
    }
    class UsersExampleMessages {
        final ExampleMessages _parent;
        const UsersExampleMessages(this._parent);
        String get logout => "Logout";
        String welcome(String name) => "Hello $name!";
    }

... and **use them** in your code - plain and simple.

    ExampleMessages m = ExampleMessages();
    print(m.users.welcome('World'));
    // outputs: Hello World!

Package is an extension (custom builder) for [build_runner](https://pub.dartlang.org/packages/build_runner)
(Dart standard for source generation) and it can be used with Flutter, AngularDart
or any other type of Dart project.

# i69n: 51 points simpler than your standard i18n!

* The official Dart/Flutter approach to i18n seems to be ... complicated and kind of ... heavyweight.
* I would like my messages to be **checked during compile time**. Is that message really there?
* Key to the localized message shouldn't be just some arbitrary String, it should be a **getter method**!
* And if the message takes some **parameters**, it should be a method which take those parameters! 
    
## How to use with Flutter

Create YAML file with your messages, for example:

    lib/messages/foo.i69n.yaml
    
    generic:    
      done: Done
      ok: OK
    invoice:
      create: Create an invoice
      delete: Delete this invoice    
    
Add translations for different languages:

    lib/messages/foo_cs.i69n.yaml (_cs = Czech translation)
    
    generic:    
      done: Hotovo
      # ok is the same and Foo_cs extends Foo.
    invoice:
      create: Vytvořit fakturu
      delete: Smazat fakturu
    
Add `build_runner` as a dev_dependency and `i69n` as a dependency to `pubspec.yaml`:

    dependencies:
      flutter:
        sdk: flutter
      i69n: any
      ...
    
    dev_dependencies:
      build_runner: any
      flutter_test:
        sdk: flutter
 
Open a terminal and in the root of your Flutter project run:

    flutter packages pub run build_runner watch --delete-conflicting-outputs
    
... and keep it running. Your message classes will appear next to YAML files and will be
rebuilt automatically each time you change the source YAML.

For one-time (re)build of your messages run:

    flutter packages pub run build_runner build --delete-conflicting-outputs
   
Import generated messages and use them:

    import 'packages:my_app/messages/foo.i69n.dart'
    
    ...
    
    Foo m = Foo();
    return Text(m.bar);
    ...
    
... or ...

    import 'packages:my_app/messages/foo_cs.i69n.dart'
    
    Foo m = Foo_cs(); // Notice: Foo_cs extends Foo
    return Text(m.bar);
           
    
## How to use with AngularDart

You are using `webdev` tool already, so you just need to add `i69n`
 as a dependency and **that's all**.        
      
## Parameters and pluralization

The implementation is VERY straightforward, which allows you to do all sorts of crazy stuff:

    invoice:
      create: Create invoice
      delete: Delete invoice
      help: "Use this function
      to generate new invoices and stuff.
      Awesome!"
      count(int cnt): "You have created $cnt ${_plural(cnt, one:'invoice', many:'invoices')}."
    apples:
      _apples(int cnt): "${_plural(cnt, one:'apple', many:'apples')}"
      count(int cnt): "You have eaten $cnt ${_apples(cnt)}."
      
Now see the generated classes: 

    class ExampleMessages {
        const ExampleMessages();
        InvoiceExampleMessages get invoice => InvoiceExampleMessages(this);        
        ApplesExampleMessages get apples => ApplesExampleMessages(this);
    }
        
    class InvoiceExampleMessages {
        final ExampleMessages _parent;
        const InvoiceExampleMessages(this._parent);
        String get create => "Create invoice";
        String get help => "Use this function to generate new invoices and stuff. Awesome!";
        String get delete => "Delete invoice";
        String count(int cnt) => "You have created $cnt ${_plural(cnt, one:'invoice', many:'invoices')}.";
    }
    
    class ApplesExampleMessages {
        final ExampleMessages _parent;
        const ApplesExampleMessages(this._parent);
        String _apples(int cnt) => "${_plural(cnt, one:'apple', many:'apples')}";
        String count(int cnt) => "You have eaten $cnt ${_apples(cnt)}.";
    }         
    
See how you can **reuse** the pluralization of `_apples(int cnt)`? (!!!)

There are three functions you can use in your message:

    String _plural(int count, {String zero, String one, String two, String few, String many, String other})

    String _cardinal(int count, {String zero, String one, String two, String few, String many, String other})

    String _ordinal(int count, {String zero, String one, String two, String few, String many, String other})

`_plural` and `_cardinal` do the same. I just felt that `_plural`
 sounds a little bit less scary and in most cases that's the one you need.

We need only two forms of the word "apple" in English. "Apple" (one) and "apples" (many).
But in Czech, we need three:

    apples:
      _apples(int cnt): "${_plural(cnt, one:'jablko', few: 'jablka', many:'jablek')}"
 
See also:

* http://cldr.unicode.org/index/cldr-spec/plural-rules
* https://www.unicode.org/cldr/charts/latest/supplemental/language_plural_rules.html

## How to use generated classes

How to decide what translation to use (ExampleMessages_cs?, ExampleMessages_hu?) **is up to you**.
The package simply generates message classes, that's all.

    import 'exampleMessages.i69n.dart';
    import 'exampleMessages_cs.i69n.dart' deferred as cs;
    
    void main() async {
      ExampleMessages m = ExampleMessages();
      print(m.apples.count(1));
      print(m.apples.count(2));
      print(m.apples.count(5));
    
      await cs.loadLibrary();
      m = cs.ExampleMessages_cs(); // see? ExampleMessages_cs extends ExampleMessages
      print(m.apples.count(1));
      print(m.apples.count(2));
      print(m.apples.count(5));    
    }    
                      
Where and how to store instances of these message classes - 
again, **up to you**. I would consider ScopedModel for Flutter and registering
messages instance into dependency injection in AngularDart.

But in this case a singleton would be acceptable also.     

# Customization and speacial features

## Dynamic access using String keys

It's still useful to access your messages using the String keys in some cases. For example when the key
of the message is composed dynamically at runtime, maybe like this:

    var vehicleTypeMessageKey = "VehicleType.${data['type']'}";
 
You can access your messages like this:

    print("static:  "+m.generic.ok);
    print("dynamic: "+m.generic['ok']);
    print("or even: "+m['generic.ok']);

In some rare cases you might want to 'disable' this map generation (maybe to enable better tree-shaking of unused messages?).
In such case use a simple flag 'nomap':

    generic:
      _i69n: nomap
      done: Done
      ok: OK             
      
No message in 'generic' message group will be accessible through the `[]` operator. Scope of the flag is very narrow - one message object
in one file. Flag is not inherited into lower levels of messages and in
most cases you want to repeat it in all translations files to make an impact.

## Escaping special characters

i69n uses double quotes in generated source files. Unless you need to use double quotes in your string,
you should be fine.

    message: Let's go!
    ...
    String get message => "Let's go!";
                
Only "\t", "\r" and "\n" characters are automatically escaped by i69n. 

    message: "Let's\ngo!" // quotes needed by YAML, \n is converted to new line by YAML
    ...
    String get message => "Let's\ngo!"; // new line escaped by i69n -> result is the same string    

If you need to disable escaping, use "noescape" flag.

    _i69n: noescape
    message: Let's go!

### Escaping the details of escaping

These are a few examples of more complicated strings in which you might need to add a backslash here and there:
  
    problematic: "Hello \\\"world\\\"!"  
    //                  ^^^ yes, tripple backslash
    
    lessProblematic: 'Hello \"world\"!'
    //                      ^ use single quotes in YAML, add only one backslash for Dart    
    
    alsoProblematic(int count): "${_plural(count, zero:'didn\\'t find any tasks', other: 'found some tasks')}"
    //                                                      ^ here
    
Please prefer single quotes inside pluralization functions.

But in most cases you will be fine. Just observe generated classes and maybe experiment a little bit.    
    
## More configuration flags

So far only 'noescape' and 'nomap'. If you need both, separate them with comma.

    _i69n: noescape,nomap            
     
## Custom pluralization

The package can correctly decide between 'one', 'few', 'many', etc. only for
English and Czech (for now). But you can easily plug your own language,
see [example/main.dart](example/main.dart)
and [Czech](lib/src/cs.dart) and [English](lib/src/en.dart)
implementation.

If you implement support for your language, please let me know,
 I'll gladly embed it into the package: tomucha@gmail.com
 
# TODO

* Current limitation: default language must be english
* TODO: support custom imports

# Example

See [example](example). Clone the package repository ([https://github.com/fnx-io/i69n](https://github.com/fnx-io/i69n)) and run:

    webdev serve example:8080

or

    pub run build_runner serve example:8080

Now open the browser http://localhost:8080/ and watch the dev tools console.

# Credits

Created by [https://fnx.io](https://fnx.io).

# Migration

## From < 1.0 to >= 1.0

You will (maybe) need to make some changes because of new escaping rules.
Either add/remove some backslashes here and there, or use
`_i69n: noescape` flag. See "Escaping special characters" above.
