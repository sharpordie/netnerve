import 'package:flutter_inappwebview/flutter_inappwebview.dart';

Future<String?> getRealdebridToken(List<String> private) async {
  throw UnimplementedError();
}

Future<bool> setRealdebridPair(List<String> private, String pairing) async {
  throw UnimplementedError();
}

Future<bool> setTraktPair(List<String> private, String pairing) async {
  String address;
  String payload;
  URLRequest startup;
  if (pairing.length != 8) return false;
  final browser = HeadlessInAppWebView();
  await browser.dispose();
  await browser.run();
  startup = URLRequest(url: WebUri('https://trakt.tv/auth/signin'));
  await browser.webViewController.clearCache();
  await browser.webViewController.loadUrl(urlRequest: startup);
  await Future.delayed(const Duration(seconds: 6));
  payload = "document.querySelector('#user_login').value = '${private[0]}';";
  await browser.webViewController.evaluateJavascript(source: payload);
  await Future.delayed(const Duration(seconds: 2));
  payload = "document.querySelector('#user_password').value = '${private[1]}';";
  await browser.webViewController.evaluateJavascript(source: payload);
  await Future.delayed(const Duration(seconds: 2));
  payload = "document.querySelector('#new_user > div.form-actions > input').click();";
  await browser.webViewController.evaluateJavascript(source: payload);
  await Future.delayed(const Duration(seconds: 12));
  address = (await browser.webViewController.getUrl()).toString();
  if (address != 'https://trakt.tv/dashboard') {
    await browser.dispose();
    return false;
  }
  startup = URLRequest(url: WebUri('https://trakt.tv/activate'));
  await browser.webViewController.loadUrl(urlRequest: startup);
  await Future.delayed(const Duration(seconds: 6));
  payload = "document.querySelector('#code').value = '$pairing';";
  await browser.webViewController.evaluateJavascript(source: payload);
  await Future.delayed(const Duration(seconds: 2));
  payload = "document.querySelector('#auth-form-wrapper > form > div.form-actions > input').click();";
  await browser.webViewController.evaluateJavascript(source: payload);
  await Future.delayed(const Duration(seconds: 12));
  address = (await browser.webViewController.getUrl()).toString();
  if (address != 'https://trakt.tv/activate/authorize') {
    await browser.dispose();
    return false;
  }
  payload = """
  const element = '#auth-form-wrapper > div.form-signin.less-top > div > form:nth-child(1) > input.btn.btn-success.btn-lg.btn-block';
  document.querySelector(element).click();
  """;
  await browser.webViewController.evaluateJavascript(source: payload);
  await Future.delayed(const Duration(seconds: 12));
  await browser.dispose();
  return true;
}
