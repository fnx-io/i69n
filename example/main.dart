// Copyright (c) 2018, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.
import 'package:i69n/i69n.dart' as i69n;

import 'exampleMessages.i69n.dart';
import 'exampleMessages_cs.i69n.dart' deferred as cs;

void main() async {
  print("Hello from i69n!");
  print("Some english:");
  ExampleMessages m = ExampleMessages();
  print(m.generic.ok);
  print(m.generic.done);
  print(m.invoice.help);
  print(m.apples.count(1));
  print(m.apples.count(2));
  print(m.apples.count(5));

  print("Asynchronous load of Czech messages:");
  await cs.loadLibrary();
  print("Some czech:");
  m = cs.ExampleMessages_cs();
  print(m.generic.ok); // inherited from default
  print(m.generic.done);
  print(m.invoice.help);
  print(m.apples.count(1));
  print(m.apples.count(2));
  print(m.apples.count(5));

  print("Access messages at runtime, with plain old string keys");
  print("Static:  " + m.generic.ok);
  print("Dynamic: " + m.generic['ok']);
  print("Or even: " + m['generic.ok']);

  // Override plurals for Czech or register support for your own language:
  i69n.registerResolver("cs", (int count, i69n.QuantityType type) {
    if (type == i69n.QuantityType.cardinal && count == 1)
      return i69n.QuantityCategory.one;
    return i69n.QuantityCategory.other;
  });

  // See:
  // http://cldr.unicode.org/index/cldr-spec/plural-rules
  // https://www.unicode.org/cldr/charts/latest/supplemental/language_plural_rules.html
}
