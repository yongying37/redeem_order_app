import 'package:equatable/equatable.dart';

class NetsQrWebhookResponseDto extends Equatable {
  final String message;
  final String netsQrResponseCode;

  const NetsQrWebhookResponseDto({
    required this.message,
    required this.netsQrResponseCode,
  });

  factory NetsQrWebhookResponseDto.fromJson(Map<String, dynamic> json) {
    return NetsQrWebhookResponseDto(
      message: json['message'] as String,
      netsQrResponseCode: json['response_code'] as String,
    );
  }

  @override
  List<Object?> get props => [
    message,
    netsQrResponseCode,
  ];
}