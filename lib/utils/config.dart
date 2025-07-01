import 'package:flutter_dotenv/flutter_dotenv.dart';

class Config {
  Config._privateConstructor();

  static final Config instance = Config._privateConstructor();

  factory Config() => instance;

  bool get debugMode => true;

  static const String commonUrl = 'https://sandbox.nets.openapipaas.com';

  static final ApiUrls apiUrls = ApiUrls();

  String get sandboxApiKey => dotenv.env["SANDBOX_API_KEY"]!;

  String get sandboxProjectId => dotenv.env["SANDBOX_PROJECT_ID"]!;

  String get devProjectId => dotenv.env["DEVELOPER_PROJECT_ID"]!;
  String get devApiKey => dotenv.env["DEVELOPER_PROJECT_API_KEY"]!;
  String get devSecretKey => dotenv.env["DEVELOPER_PROJECT_SECRET_KEY"]!;
  String get devPlatformSyscode => dotenv.env["DEVELOPER_PROJECT_PLATFORM_SYSCODE"]!;


  // For NETS Click
  String get netsLogoPath => 'assets/images/nets_logo.jpeg';
  String get greenTickPath => 'assets/images/greenTick.png';
  String get redCrossPath => 'assets/images/redCross.png';

  String get bundleId => 'stg.org.codeforeword';
  String get userId => '1324';
  String get mainPaymentCredentialSource => 'o';
  String get mainPaymentIdentifier => 'd2ea48c4-71e0-4152-9f08-6d635b83816b';
  String get openApiPaasProjectName => 'sandbox_nets';
  int get netsBankCardId => 1;

}

class ApiUrls {
  String get requestNetsApi => '/api/v1/common/payments/nets-qr/request';
  String webhookNetsApi(String netsQrRetrievalRef) => '/api/v1/common/payments/nets/webhook?txn_retrieval_ref=$netsQrRetrievalRef';
  String get queryNetsApi => '/api/v1/common/payments/nets-qr/query';

  // API URLS for NETS Click
  String get netsHealthCheck => '/api/v1/common/payments/nets-click/health';
  String get mainPurchaseNetsClick => '/api/v1/common/payments/nets-click/purchase';
}