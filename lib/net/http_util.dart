import 'dart:io';
import 'dart:convert';

class HttpUtil {
  static Future<String> get(String authority, String unencodedPath,
      {Map<String, String> params}) async {

    print("http get : url = " + authority + unencodedPath);

    var httpClient = new HttpClient();
    var uri = new Uri.http(authority, unencodedPath, params);
    var request = await httpClient.getUrl(uri);
    var response = await request.close();
    return await response.transform(utf8.decoder).join();
  }

  static Future<String> post(String authority, String unencodedPath,
      {Map<String, String> params}) async {
    var httpClient = new HttpClient();
    var uri = new Uri.http(authority, unencodedPath, params);
    var request = await httpClient.postUrl(uri);
    var response = await request.close();
    return await response.transform(utf8.decoder).join();
  }
}
