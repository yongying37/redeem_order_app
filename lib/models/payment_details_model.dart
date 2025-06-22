import 'package:equatable/equatable.dart';

class PaymentDetails extends Equatable {
  final String amtInDollars;
  final String recordId;
  final String? identifier;

  const PaymentDetails({
    required this.amtInDollars,
    required this.recordId,
    this.identifier,
  });

  @override
  List<Object?> get props => [
    amtInDollars,
    recordId,
    identifier,
  ];
}