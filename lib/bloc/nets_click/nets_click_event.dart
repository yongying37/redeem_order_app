part of 'nets_click_bloc.dart';

sealed class NetsClickEvent {}

final class MakePayment extends NetsClickEvent {
  final PaymentDetails mainPaymentDetails;
  MakePayment(this.mainPaymentDetails);
}