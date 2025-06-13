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
  }) {
    const requestBody = '{}';

    final datetime = DateTime.now().toUtc().toIso8601String();
    final contentSha256 = base64.encode(sha256.convert(utf8.encode(requestBody)).bytes);
    final host = 'stg.foodservices.openapipaas.com';

    final uri = Uri.parse(requestUrl);
    final canonicalRequest = '$requestMethod\n${uri.path}?${uri.query}\n$datetime\n$contentSha256\n$host';

    final hmac = Hmac(sha256, utf8.encode(secretKey));
    final rawSignature = base64.encode(hmac.convert(utf8.encode(canonicalRequest)).bytes);

    final authHeader =
        'HMAC-SHA256 Credential=$apiKey&SignedHeaders=datetime|host|project-id|platform-syscode|content-sha256&Signature=$rawSignature';

    print('🧾 Canonical String:\n$canonicalRequest');
    print('datetime: $datetime');
    print('content-sha256: $contentSha256');
    print('Authorization: $authHeader');

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
