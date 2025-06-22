part of 'nets_click_bloc.dart';

enum NetsClickStatus {
  initial,
  makePaymentLoading,
  makePaymentSuccess,
  makePaymentError
}

extension NetsClickStatusExtension on NetsClickStatus {
  bool get isMakePaymentLoading => this == NetsClickStatus.makePaymentLoading;
  bool get isMakePaymentSuccess => this == NetsClickStatus.makePaymentSuccess;
  bool get isMakePaymentError => this == NetsClickStatus.makePaymentError;
  bool get isInitial => this == NetsClickStatus.initial;
}

final class NetsClickState extends Equatable {
  final NetsClickStatus status;
  final String loadingTitle;
  final String errorTitle;
  final String successTitle;
  final String loadingMessage;
  final String errorMessage;
  final String successMessage;

  const NetsClickState({
    this.status = NetsClickStatus.initial,
    this.loadingTitle = '',
    this.errorTitle = '',
    this.successTitle = '',
    this.loadingMessage = '',
    this.errorMessage = '',
    this.successMessage = '',
  });

  NetsClickState copyWith({
    NetsClickStatus? status,
    String? loadingTitle,
    String? errorTitle,
    String? successTitle,
    String? loadingMessage,
    String? errorMessage,
    String? successMessage,
  }) {
    return NetsClickState(
      status: status ?? this.status,
      loadingTitle: loadingTitle ?? this.loadingTitle,
      errorTitle: errorTitle ?? this.errorTitle,
      successTitle: successTitle ?? this.successTitle,
      loadingMessage: loadingMessage ?? this.loadingMessage,
      errorMessage: errorMessage ?? this.errorMessage,
      successMessage: successMessage ?? this.successMessage,
    );
  }

  @override
  List<Object?> get props => [
    status,
    loadingTitle,
    errorTitle,
    successTitle,
    loadingMessage,
    errorMessage,
    successMessage,
  ];
}