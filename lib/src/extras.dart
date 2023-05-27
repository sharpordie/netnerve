import 'package:flutter_inappwebview/flutter_inappwebview.dart';

/// ...
Future<String?> getTokenForRealdebrid(
  ({String username, String password}) private,
) async {
  String payload;
  URLRequest startup;
  final browser = HeadlessInAppWebView();
  await browser.dispose();
  await browser.run();
  startup = URLRequest(url: WebUri('https://real-debrid.com/'));
  await browser.webViewController.clearCache();
  await browser.webViewController.loadUrl(urlRequest: startup);
  await Future.delayed(const Duration(seconds: 6));
  payload = "document.querySelector('#allpage-login-top > span').click();";
  await browser.webViewController.evaluateJavascript(source: payload);
  await Future.delayed(const Duration(seconds: 6));
  payload = "document.querySelector('#loginform > fieldset:nth-child(1) > input[type=text]').value = '${private.username}';";
  await browser.webViewController.evaluateJavascript(source: payload);
  await Future.delayed(const Duration(seconds: 2));
  payload = "document.querySelector('#loginform > fieldset:nth-child(3) > input[type=password]').value = '${private.password}';";
  await browser.webViewController.evaluateJavascript(source: payload);
  await Future.delayed(const Duration(seconds: 2));
  payload = "document.querySelector('#submit').click();";
  await browser.webViewController.evaluateJavascript(source: payload);
  await Future.delayed(const Duration(seconds: 6));
  payload = "document.querySelector('#username') === null";
  final invalid = await browser.webViewController.evaluateJavascript(source: payload) as bool;
  if (invalid) return null;
  startup = URLRequest(url: WebUri('https://real-debrid.com/apitoken'));
  await browser.webViewController.loadUrl(urlRequest: startup);
  await Future.delayed(const Duration(seconds: 6));
  payload = "document.querySelector('#wrapper_global > div > div > input[type=text]').value;";
  final results = await browser.webViewController.evaluateJavascript(source: payload);
  return results;
}

/// ...
Future<bool> setPairForRealdebrid(
  ({String username, String password}) private,
  String pincode,
) async {
  if (pincode.length != 8) return false;
  String payload;
  URLRequest startup;
  final browser = HeadlessInAppWebView();
  await browser.dispose();
  await browser.run();
  startup = URLRequest(url: WebUri('https://real-debrid.com/'));
  await browser.webViewController.clearCache();
  await browser.webViewController.loadUrl(urlRequest: startup);
  await Future.delayed(const Duration(seconds: 6));
  payload = "document.querySelector('#allpage-login-top > span').click();";
  await browser.webViewController.evaluateJavascript(source: payload);
  await Future.delayed(const Duration(seconds: 6));
  payload = "document.querySelector('#loginform > fieldset:nth-child(1) > input[type=text]').value = '${private.username}';";
  await browser.webViewController.evaluateJavascript(source: payload);
  await Future.delayed(const Duration(seconds: 2));
  payload = "document.querySelector('#loginform > fieldset:nth-child(3) > input[type=password]').value = '${private.password}';";
  await browser.webViewController.evaluateJavascript(source: payload);
  await Future.delayed(const Duration(seconds: 2));
  payload = "document.querySelector('#submit').click();";
  await browser.webViewController.evaluateJavascript(source: payload);
  await Future.delayed(const Duration(seconds: 6));
  payload = "document.querySelector('#username') === null";
  final invalid = await browser.webViewController.evaluateJavascript(source: payload) as bool;
  if (invalid) return false;
  startup = URLRequest(url: WebUri('https://real-debrid.com/device'));
  await browser.webViewController.loadUrl(urlRequest: startup);
  await Future.delayed(const Duration(seconds: 6));
  payload = "document.querySelector('#usercode').value = '$pincode';";
  await browser.webViewController.evaluateJavascript(source: payload);
  await Future.delayed(const Duration(seconds: 4));
  payload = "document.querySelector('body > div > div > div:nth-child(2) > div > div.panel-body > form > fieldset > div.pull-right > input').click();";
  await browser.webViewController.evaluateJavascript(source: payload);
  await Future.delayed(const Duration(seconds: 6));
  return true;
}

/// ...
Future<bool> setPairForSpotify(
  ({String username, String password}) private,
  String pincode,
) async {
  throw UnimplementedError();
}

/// ...
Future<bool> setPairForTrakt(
  ({String username, String password}) private,
  String pincode,
) async {
  if (pincode.length != 8) return false;
  String address;
  String payload;
  URLRequest startup;
  final browser = HeadlessInAppWebView();
  await browser.dispose();
  await browser.run();
  startup = URLRequest(url: WebUri('https://trakt.tv/auth/signin'));
  await browser.webViewController.clearCache();
  await browser.webViewController.loadUrl(urlRequest: startup);
  await Future.delayed(const Duration(seconds: 6));
  payload = "document.querySelector('#user_login').value = '${private.username}';";
  await browser.webViewController.evaluateJavascript(source: payload);
  await Future.delayed(const Duration(seconds: 2));
  payload = "document.querySelector('#user_password').value = '${private.password}';";
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
  payload = "document.querySelector('#code').value = '$pincode';";
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

/// ...
Future<bool> setPairForYoutube(
    ({String username, String password}) private,
    String pincode,
    ) async {
  throw UnimplementedError();
}
