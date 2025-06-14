import 'dart:convert';
import 'package:crypto/crypto.dart';

class HmacUtil {
  static Map<String, String> generateHeaders({
    required String apiKey,
    required String projectId,
    required String platformSyscode,
    required String secretKey,
    required String requestMethod,
    required String requestUrl,
    String? overrideDatetime, // Allows manual datetime override for testing
  }) {
    const requestBody = '{}';

    final now = overrideDatetime != null
        ? DateTime.parse(overrideDatetime)
        : DateTime.now().toUtc();

    final datetime = now.toIso8601String().substring(0, 23) + 'Z';

    final contentSha256 = base64.encode(sha256.convert(utf8.encode(requestBody)).bytes);

    final uri = Uri.parse(requestUrl);
    final canonicalUriPath = uri.path;

    final canonicalUriQuery = uri.hasQuery ? '?${uri.query}' : '';

    // Use the parsed host to match exactly what the server expects
    final host = uri.host;

    // Construct the canonical string
    final canonicalRequest = [
      requestMethod,                              // e.g., GET
      '$canonicalUriPath$canonicalUriQuery',      // full path + raw query
      '$datetime|$host|$projectId|$platformSyscode|$contentSha256'
    ].join('\n');

    print('Canonical Request Lines:');
    canonicalRequest.split('\n').forEach((line) => print('➡ "$line"'));


    final stringToSign = canonicalRequest + secretKey;
    final bytes = sha256.convert(utf8.encode(stringToSign)).bytes;
    final rawSignature = base64.encode(bytes);

    final signedHeadersString = 'datetime|host|project-id|platform-syscode|content-sha256';

    final authHeader =
        'HMAC-SHA256 Credential=$apiKey&SignedHeaders=$signedHeadersString&Signature=$rawSignature';

    // Debug output
    print('--- HMAC-SHA256 DEBUG ---');
    print('Canonical Request:\n$canonicalRequest');
    print('datetime: $datetime');
    print('content-sha256: $contentSha256');
    print('Authorization: $authHeader');
    print('--------------------------');

    return {
      'api-key': apiKey,
      'project-id': projectId,
      'platform-syscode': platformSyscode,
      'datetime': datetime,
      'content-sha256': contentSha256,
      'Authorization': authHeader,
    };
  }
}
