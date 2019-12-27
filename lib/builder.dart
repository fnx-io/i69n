// Copyright (c) 2018, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:build/build.dart';
import 'package:i69n/src/i69n_impl.dart';

Builder yamlBasedBuilder(BuilderOptions options) => YamlBasedBuilder();

class YamlBasedBuilder implements Builder {
  @override
  Future build(BuildStep buildStep) async {
    // Each [buildStep] has a single input.
    var inputId = buildStep.inputId;

    // Create a new target [AssetId] based on the old one.
    var contents = await buildStep.readAsString(inputId);

    var objectName = generateMessageObjectName(inputId.pathSegments.last);
    var dartContent = generateDartContentFromYaml(objectName, contents);

    var copy = inputId.changeExtension('.dart');

    // Write out the new asset.
    await buildStep.writeAsString(copy, dartContent);
  }

  @override
  final buildExtensions = const {
    '.i69n.yaml': ['.i69n.dart']
  };
}
