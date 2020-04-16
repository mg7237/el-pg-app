import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiClient {
  static ApiClient _instance;

  /*static const BASE_URL_IMAGE =
      "http://13.233.103.136/";
  static const BASE_URL =
      "http://13.233.103.136/api/v1";*/

//  static const BASE_URL_IMAGE = "https://www.easyleases.in/";
//  static const BASE_URL = "https://www.easyleases.in/api/v1.1";

  static const BASE_URL_IMAGE = "http://13.233.104.141/";
  static const BASE_URL = "http://13.233.104.141/api/v2";

  static final DEVICE_TYPE = Platform.operatingSystem;

  factory ApiClient() => _instance ??= new ApiClient._();

  ApiClient._();

  Future<http.Response> getMethod(
    String url,
    Map<String, String> headers,
  ) async {
    print(url);
    var response = await http.get(
      url,
      headers: headers,
    );
    print(response.body.toString());
    return response;
  }

  Future<http.Response> postMethod(
    String method,
    Map<String, dynamic> body,
    Map<String, String> headers,
  ) async {
    print(method);
    print(body);
    var response = await http.post(
      BASE_URL + method,
      body: json.encode(body),
      headers: headers,
    );
    return response;
  }

  Future<http.Response> postMethodMultipart(var request) async {
    http.Response response = await http.Response.fromStream(await request.send());
    print(response.body);
    return response;
  }

  Future<http.Response> patchMethod(
    String method,
    Map<String, dynamic> body,
    Map<String, String> headers,
  ) async {
    print(body);
    var response = await http.patch(
      BASE_URL + method,
      body: json.encode(body),
      headers: headers,
    );
    return response;
  }

  Future<http.Response> patchMethodMultipart(var request) async {
    http.Response response = await http.Response.fromStream(await request.send());
    print(response.body);
    return response;
  }

  Future<http.Response> deleteMethod(
    String url,
    Map<String, String> headers,
  ) async {
    print(url);
    var response = await http.delete(
      url,
      headers: headers,
    );
    print(response.body.toString());
    return response;
  }
}
