import 'package:flutter_dotenv/flutter_dotenv.dart';

class Config {
  Config._privateConstructor();

  static final Config instance = Config._privateConstructor();

  factory Config() => instance;

  static const String commonUrl = 'https://sandbox.nets.openapipaas.com';

  static final ApiUrls apiUrls = ApiUrls();

  String get sandboxApiKey => dotenv.env["SANDBOX_API_KEY"]!;

  String get sandboxProjectId => dotenv.env["SANDBOX_PROJECT_ID"]!;

}

class ApiUrls {
  String get requestNetsApi => '/api/v1/common/payments/nets-qr/request';
  String webhookNetsApi(String netsQrRetrievalRef) => '/api/v1/common/payments/nets/webhook?txn_retrieval_ref=$netsQrRetrievalRef';
  String get queryNetsApi => '/api/v1/common/payments/nets-qr/query';
}