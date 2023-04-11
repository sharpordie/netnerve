import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:netnerve/netnerve.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    PathProviderPlatform.instance = FakePathProviderPlatform();
  });

  test('getFromAddress returns correct file', () async {
    final fetched = await getFromAddress('https://7-zip.org/a/7z2201-linux-x64.tar.xz');
    expect(fetched!.lengthSync() > 0, true);
  });

  test('getFromDropbox returns correct file', () async {
    final fetched = await getFromDropbox('');
    expect(fetched!.lengthSync() > 0, true);
  }, skip: 'not implemented yet');

  test('getFromGithub returns correct file', () async {
    const address = 'https://api.github.com/repos/moonlight-stream/moonlight-android/releases/latest';
    final fetched = await getFromGithub(address, RegExp('nonRoot'));
    expect(fetched!.lengthSync() > 0, true);
  });
}

class FakePathProviderPlatform extends Fake with MockPlatformInterfaceMixin implements PathProviderPlatform {
  @override
  Future<String?> getTemporaryPath() async {
    return Directory.systemTemp.path;
  }
}
