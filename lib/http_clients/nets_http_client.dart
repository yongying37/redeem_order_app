import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:redeem_order_app/utils/config.dart';
import '../utils/common_enum.dart';
import '../utils/logger.dart';

class NetsHttpClient extends WidgetsBindingObserver {
  static const String _baseUrl = Config.commonUrl;
  static const Duration _httpTimeout = Duration(minutes: 1);

  static final Map<String, String> _apiHeader = {
    'Content-Type': 'application/json',
    'api-key': Config().sandboxApiKey,
    'project-id': Config().sandboxProjectId,
  };

  static Map<String, String> _httpHeaders({bool sse = false}) {
    final headers = Map<String, String>.from(_apiHeader);
    if (sse) {
      headers['Content-Type'] = 'text/event-stream';
      headers['Connection'] = 'keep-alive';
    }
    return headers;
  }

  static final http.Client _sseHttpClient = http.Client();
  static StreamSubscription<String>? _sseSubscription;

  static Future<Map<String, String>> _authHeaders({required String method, required Uri url, Map<String, dynamic> requestBody = const {}}) async {
    final headers = Map<String, String>.from(_apiHeader);
    return headers;
  }

  // Generic GET request
  static Future<dynamic> get(String endpoint, {Duration? timeout, bool useLogger = false}) async {
    final uri = Uri.parse('$_baseUrl$endpoint');
    //final headers = _httpHeaders(sse: false);
    final headers = await _authHeaders(method: RequestType.GET.stringValue, url: uri);
    if (useLogger) Logger.d(uri.toString(), requestType: RequestType.GET, tag: 'NetsHttpClient.get');
    final response = await http.get(uri, headers: headers).timeout(timeout ?? _httpTimeout);
    return httpResponseHandler(response);
  }

  // Generic POST request
  static Future<dynamic> post(String endpoint, {Map<String, dynamic> requestBody = const {}, Duration? timeout, bool useLogger = false}) async {
    final uri = Uri.parse('$_baseUrl$endpoint');
    final headers = await _authHeaders(method: RequestType.GET.stringValue, url: uri, requestBody: requestBody);
    if (useLogger) Logger.d(uri.toString(), requestType: RequestType.POST, tag: 'NetsHttpClient.post');
    final response = await http.post(uri, headers: headers, body: jsonEncode(requestBody)).timeout(timeout ?? _httpTimeout);
    return httpResponseHandler(response);
  }

  // Generic PUT request
  static Future<dynamic> put(String endpoint, {Map<String, dynamic> requestBody = const {}, Duration? timeout, bool useLogger = false}) async {
    final uri = Uri.parse('$_baseUrl$endpoint');
    final headers = await _authHeaders(method: RequestType.PUT.stringValue, url: uri, requestBody: requestBody);
    if (useLogger) Logger.d(uri.toString(), requestType: RequestType.PUT, tag: 'NetsHttpClient.put');
    final response = await http.put(uri, headers: headers, body: jsonEncode(requestBody)).timeout(timeout ?? _httpTimeout);
    return httpResponseHandler(response);
  }

  // Generic DELETE request
  static Future<dynamic> delete(String endpoint, {Map<String, dynamic> requestBody = const {}, Duration? timeout, bool useLogger = false}) async {
    final uri = Uri.parse('$_baseUrl$endpoint');
    final headers = await _authHeaders(method: RequestType.DELETE.stringValue, url: uri, requestBody: requestBody);
    if (useLogger) Logger.d(uri.toString(), requestType: RequestType.DELETE, tag: 'NetsHttpClient.delete');
    final response = await http.delete(uri, headers: headers, body: jsonEncode(requestBody)).timeout(timeout ?? _httpTimeout);
    return httpResponseHandler(response);
  }

  // ----------------------------- Start of Webhook API handling -----------------------------
  // Generic SSE (Server-Sent Events) GET request
  // The client initiates a SSE GET request, and the server keeps the connection open, allowing it to send updates as they become available.
  static Future<StreamSubscription<String>> getSse(
      String endpoint, {
        required Function(String) onMessage,
        int maxRetries = 0,
      }) async {
    final headers = _httpHeaders(sse: true);
    int retryCount = 0;

    // Function to handle the SSE connection
    Future<void> connect() async {
      final request = http.Request('GET', Uri.parse('$_baseUrl$endpoint'));
      request.headers.addAll(headers);

      final response = await _sseHttpClient.send(request);

      print('GET SSE $_baseUrl$endpoint');

      if (response.statusCode == HttpStatus.ok) {
        _sseSubscription = response.stream
            .transform(utf8.decoder)
            .transform(const LineSplitter())
            .listen(
              (data) {onMessage(data);},
          onError: (error) async {
            print('Error occurred: $error');
            if (maxRetries == 0) {
              _sseSubscription?.cancel();
              print('Connection closed');
            } else {
              if (retryCount < maxRetries) {
                retryCount++;
                connect();
                print("Reconnecting... \nretrycount: $retryCount");
              } else {
                print('Failed to connect after $maxRetries retries');
                _sseSubscription?.cancel();
                throw Exception('Failed to connect to SSE: $error');
              }
            }
          },
        );
      }
      else {
        print('Failed to connect to SSE: ${response.statusCode}');
        if (retryCount < maxRetries) {
          retryCount++;
          await Future.delayed(const Duration(seconds: 2));
          connect();
        } else {
          print('Failed to reconnect after $maxRetries attempts');
          _sseSubscription?.cancel();
          throw HttpException('Failed to connect to SSE: ${response.statusCode}');
        }
      }
    }

    // Start the initial connection
    await connect();

    // Return the subscription to allow external handling (e.g., cancellation)
    return _sseSubscription!;
  }

  // Close the HttpClient when done
  static void closeSseSubscription() {
    _sseSubscription?.cancel();
  }
  // ----------------------------- End of Webhook API handling -----------------------------

  // Handles HTTP responses
  static dynamic httpResponseHandler(http.Response response) {
    if (response.statusCode == HttpStatus.ok) {
      return jsonDecode(response.body);
    } else {
      if (response.body.isNotEmpty && jsonDecode(response.body)['result']['message'] != null && jsonDecode(response.body)['result']['message'] != '') {
        throw HttpException('HTTP Error ${response.statusCode} - ${jsonDecode(response.body)['result']['message']}', uri: response.request?.url);
      }
      throw HttpException('HTTP Error ${response.statusCode} - ${response.reasonPhrase ?? 'An error occurred'}.', uri: response.request?.url);
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.detached) {
      print('Detected user killing the app. Closing SSE connection.');
      _sseHttpClient.close();
    }
  }
}