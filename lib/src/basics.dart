import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

Future<File?> getFromAddress(String address) async {
  try {
    final fetcher = Dio()
      ..options.followRedirects = true
      ..options.headers = {'user-agent': 'mozilla/5.0'};
    final deposit = (await getTemporaryDirectory()).path;
    final suggest = Uri.parse(address).pathSegments.last.toString();
    final fetched = File(p.join(deposit, suggest));
    await fetcher.download(address, fetched.path);
    return fetched;
  } on Exception {
    return null;
  }
}

Future<File?> getFromAndroidfilehost(String address) async {
  String payload;
  URLRequest startup;
  final browser = HeadlessInAppWebView();
  await browser.dispose();
  await browser.run();
  startup = URLRequest(url: WebUri(address));
  await browser.webViewController?.clearCache();
  await browser.webViewController?.loadUrl(urlRequest: startup);
  await Future.delayed(const Duration(seconds: 6));
  payload = "document.querySelector('#loadMirror').click();";
  await browser.webViewController?.evaluateJavascript(source: payload);
  await Future.delayed(const Duration(seconds: 10));
  payload = "document.querySelector('#mirrors > a').href;";
  address =
      await browser.webViewController?.evaluateJavascript(source: payload);
  return await getFromAddress(address);
}

Future<File?> getFromDropbox(String address) async {
  address = Uri.parse(address).replace(queryParameters: {'dl': '1'}).toString();
  return await getFromAddress(address);
}

Future<File?> getFromGithub(String address, RegExp pattern) async {
  final fetcher = Dio()
    ..options.followRedirects = true
    ..options.headers = {'user-agent': 'mozilla/5.0'};
  final content = await (await fetcher.get(address)).data;
  final results = content['assets'];
  final factors = results.map((x) => x['browser_download_url']).toList();
  final element = factors.firstWhere((x) => pattern.hasMatch(x.toString()),
      orElse: () => null);
  if (element == null) return null;
  return await getFromAddress(element);
}
