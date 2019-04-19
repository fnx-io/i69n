Alternative internationalization package for Dart and Flutter.

Write your messages into YAML files, and let this package generate
a Dart objects from those files.

**WARNING: Not battle tested yet!** Also the documentation is rather rudimentary.

# i69n: 51 points better than i18n!

(nice!)

## Motivation

* The official Dart/Flutter approach for i18n seems ... complicated and kind of ... heavyweight.
* I would like my messages to be **checked during compile time** - is that message really there? Key to the localized message should
 not be just some random string, it should be a method!
* And if the massage takes some parameters, the method should take those parameters! 
* I like to bundle messages into thematic groups, the i18n tool should support that and help me with it
* Dart has awesome **string interpolation**, I want to leverage that!
* I like build_runner and code generation.
* I love the name. i69n is hilarious.

# Solution

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
  
... run the "webdev" tool, or "build_runner" directly, and use your messages like this:

    ExampleMessages m = ExampleMessages();
    print(m.generic.ok);
    print(m.generic.done);
    
## Parameters and pluralization

In fact, you can do a lot of crazy stuff:

    generic:
      ok: OK
      done: DONE
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
      
Maybe it will help, if I show you the generated classes: 

    class ExampleMessages {
        const ExampleMessages();
        GenericExampleMessages get generic => GenericExampleMessages(this);
        ApplesExampleMessages get apples => ApplesExampleMessages(this);
        InvoiceExampleMessages get invoice => InvoiceExampleMessages(this);
    }
    
    class GenericExampleMessages {
        final ExampleMessages _parent;
        const GenericExampleMessages(this._parent);
        String get ok => "OK";
        String get done => "DONE";
    }
    
    class ApplesExampleMessages {
        final ExampleMessages _parent;
        const ApplesExampleMessages(this._parent);
        String _apples(int cnt) => "${_plural(cnt, one:'apple', many:'apples')}";
        String count(int cnt) => "You have eaten $cnt ${_apples(cnt)}.";
    }
    
    class InvoiceExampleMessages {
        final ExampleMessages _parent;
        const InvoiceExampleMessages(this._parent);
        String get create => "Create invoice";
        String get help => "Use this function to generate new invoices and stuff. Awesome!";
        String get delete => "Delete invoice";
        String count(int cnt) => "You have created $cnt ${_plural(cnt, one:'invoice', many:'invoices')}.";
    } 
    
Please notice, how you can reuse the pluralization of "apples". Nice, isn't it?
And here is how to work with different translations:

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
    
                      

How to decide what translation to use (ExampleMessages_cs?, ExampleMessages_hu?) **is up to you**.
The package simply generates message objects, that's all.
Where and how to store instances of these message classes - 
again, **up to you**. I would consider ScopedModel for Flutter and registering
messages instance into dependency injection in AngularDart, but that's just me.

## Custom pluralization

For now the package can correctly decide between 'one', 'few', 'many', etc. only for English and Czech.
But you can easily plug your own language, see [example/index.dart](example/index.dart).
If your implement support for your language, please let me know, I'll gladly embed it into the package. 

## TODO

* More detailed docs.
* Use it in some of our projects for real.
* Current limitation: default language must be english
* TODO: support custom imports 

## Example

See [example](example). Clone the repository and run:

    webdev serve example:8080

or

    pub run build_runner serve example:8080

Now open the browser http://localhost:8080/ and watch the dev tools console.