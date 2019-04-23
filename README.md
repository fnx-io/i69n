Simple internationalization package for Dart and Flutter.

# Overview

Write your messages into YAML files, and let this package generate
a Dart objects from those files. Turn this **YAML** file:

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

Package is an extension (custom builder) for [https://pub.dartlang.org/packages/build_runner](https://pub.dartlang.org/packages/build_runner),
Dart standard for source generation and it can be used with Flutter, AngularDart or any other type of Dart application.

# i69n: 51 points simpler than your standard i18n!

## Motivation and goals

* The official Dart/Flutter approach to i18n seems to be ... complicated and kind of ... heavyweight.
* I would like my messages to be **checked during compile time**. Is that message really there?
* Key to the localized message should not be just some arbitrary String, it should be a **getter method**!
* And if the message takes some **parameters**, the method should take those parameters! 
* I like to bundle messages into thematic groups, the i18n tool should support that and help me with it.
* Dart has awesome **string interpolation**, I want to leverage that!
* I like build_runner and code generation.
* I love the name. i69n is hilarious.

## Solution

Write your messages into a YAML file:

    exampleMessages.i69n.yaml (default messages):
    
    generic:
      ok: OK
      done: DONE
    invoice:
      create: Create invoice
      delete: Delete invoice
  
  
Write your translations into other YAML files:

    exampleMessages_cs.i69n.yaml (_cs = Czech translation)
    
    generic:    
      done: Hotovo
    invoice:
      create: Vytvořit fakturu
      delete: Smazat fakturu
  
... run the `webdev` tool, or `build_runner` directly, and use your messages like this:

    ExampleMessages m = ExampleMessages();
    print(m.generic.ok); // output: OK
    print(m.generic.done); // output: DONE
    
    m = ExampleMessages_cs();
    print(m.generic.ok); // output: OK
    print(m.generic.done); // output: Hotovo
    
## Parameters and pluralization

The implementation is VERY straightforward, which that allows you to do all sorts of crazy stuff:

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
    
See how you can **reuse** the pluralization of `_apples(int cnt)`? (nice!)

There are three functions you can use in your message:

    String _plural(int count, {String zero, String one, String two, String few, String many, String other})

    String _cardinal(int count, {String zero, String one, String two, String few, String many, String other})

    String _ordinal(int count, {String zero, String one, String two, String few, String many, String other})

`_plural` and `_cardinal` do the same. I just felt that `_plural`
 is a little bit less scary name :-)

We need only two forms of the word apple in English. Apple (one) and apples (many). But in Czech:

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

## How to use with Flutter

Create YAML file with your messages, for example:

    lib/messages/foo.i69n.yaml

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

    flutter packages pub run build_runner watch
    
... and keep it running. Your message classes will appear next to YAML files and will be
rebuilt automatically each time you change the source YAML.

For one-time (re)build of your messages run:

    flutter packages pub run build_runner build
   
Import generated messages and use them:

    import 'messages/foo.i69n.dart'
    
    ...
    
    Foo m = Foo();
    return Text(m.bar);
    ...
    
## How to use with AngularDart

You are probably using `webdev` tool already, so you just need to add `i69n`
 as a dependency and that's all. See `example`.          

## Custom pluralization

The package can correctly decide between 'one', 'few', 'many', etc. only for
English and Czech (for now). But you can easily plug your own language,
see [example/main.dart](example/main.dart)
and [Czech](lib/src/cs.dart) and [English](lib/src/en.dart)
implementation.

If you implement support for your language, please let me know,
 I'll gladly embed it into the package. 
 
# TODO

* More detailed docs.
* Use it in some of our projects for real.
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