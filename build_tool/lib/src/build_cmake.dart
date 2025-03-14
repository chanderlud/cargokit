import 'dart:io';

import 'package:path/path.dart' as path;

import 'artifacts_provider.dart';
import 'builder.dart';
import 'environment.dart';
import 'options.dart';
import 'target.dart';

class BuildCMake {
  final CargokitUserOptions userOptions;

  BuildCMake({required this.userOptions});

  Future<void> build() async {
    final targetPlatform = Environment.targetPlatform;
    final target = Target.forFlutterName(Environment.targetPlatform);
    if (target == null) {
      throw Exception("Unknown target platform: $targetPlatform");
    }

    final environment = BuildEnvironment.fromEnvironment(isAndroid: false);
    final provider = ArtifactProvider(
      environment: environment,
      userOptions: userOptions,
    );
    final artifacts = await provider.getArtifacts([target]);

    final libs = artifacts[target]!;

    for (final lib in libs) {
      if (lib.type == AritifactType.dylib) {
        File(
          lib.path,
        ).copySync(path.join(Environment.outputDir, lib.finalFileName));
      }
    }
  }
}
