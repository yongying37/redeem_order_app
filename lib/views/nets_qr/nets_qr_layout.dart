import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:redeem_order_app/bloc/nets_qr/nets_qr_bloc.dart';
import 'package:redeem_order_app/bloc/cart/cart_bloc.dart';
import 'package:redeem_order_app/views/txn_nets_status/txn_nets_fail_status_page.dart';
import 'package:redeem_order_app/views/txn_nets_status/txn_nets_success_status_page.dart';
import 'package:redeem_order_app/views/home/home_page.dart';

class NetsQrLayout extends StatefulWidget {
  final String orderType;

  const NetsQrLayout({super.key, required this.orderType});

  @override
  State<NetsQrLayout> createState() => _NetsQrLayoutState();
}

class _NetsQrLayoutState extends State<NetsQrLayout> {
  Timer? netsTimer;
  int secondsNetsTimeout = 30;
  bool netsTimerActive = false;

  String get netsTimerText {
    int minutes = secondsNetsTimeout ~/ 60;
    int seconds = secondsNetsTimeout % 60;
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }

  void startNetsTimer() {
    netsTimer?.cancel();
    netsTimerActive = true;

    setState(() {});

    netsTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (secondsNetsTimeout > 0) {
          secondsNetsTimeout--;
        } else {
          timer.cancel();
          netsTimerActive = false;

          final cartBloc = context.read<CartBloc>();
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => BlocProvider.value(
                value: cartBloc,
                child: TxnNetsFailStatusPage(orderType: widget.orderType),
              ),
            ),
          );
        }
      });
    });
  }

  @override
  void dispose() {
    netsTimer?.cancel();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    BlocProvider.of<NetsQrBloc>(context).add(const RequestNetsQrEvent(
      amount: 3,
      txnId: 'sandbox_nets|m|8ff8e5b6-d43e-4786-8ac5-7accf8c5bd9b',
      notifyMobile: 0,
    ));
  }

  Widget netsQrCode(NetsQrState state) {
    if (state.isNetsQrCodeScanned != null) {
      netsTimer?.cancel();
      netsTimerActive = false;
    }

    if (state.netsQrRequest?.netsQrPayment != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && !netsTimerActive) {
          startNetsTimer();
        }
      });

      return Image.memory(state.netsQrRequest!.netsQrPayment);
    } else {
      return const SizedBox(height: 200);
    }
  }

  Widget btnCancel() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.red.shade600,
        padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      onPressed: () {
        netsTimer?.cancel();
        netsTimerActive = false;
        BlocProvider.of<NetsQrBloc>(context).add(const CancelWebhookNetsQrEvent(cancelWebhookNetsQr: true));
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const HomePage()));
      },
      child: const Text(
        'CANCEL',
        style: TextStyle(color: Colors.white, fontSize: 18),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<NetsQrBloc, NetsQrState>(
      listener: (context, state) async {
        if (state.isNetsQrCodeScanned == true) {
          if (state.isNetsQrPaymentSuccess) {
            await Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => TxnNetsSuccessStatusPage(orderType: widget.orderType),
              ),
            );
          } else {
            final cartBloc = context.read<CartBloc>();
            await Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => BlocProvider.value(
                  value: cartBloc,
                  child: TxnNetsFailStatusPage(orderType: widget.orderType),
                ),
              ),
            );
          }
        } else if (state.isNetsQrCodeScanned == false && state.netsQrQuery != null) {
          if (state.netsQrQuery!.netsQrResponseCode == "00" && state.netsQrQuery!.openApiPaasTxnStatus == 1) {
            await Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => TxnNetsSuccessStatusPage(orderType: widget.orderType),
              ),
            );
          } else {
            final cartBloc = context.read<CartBloc>();
            await Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => BlocProvider.value(
                  value: cartBloc,
                  child: TxnNetsFailStatusPage(orderType: widget.orderType),
                ),
              ),
            );
          }
        }
      },
      child: BlocBuilder<NetsQrBloc, NetsQrState>(
        builder: (context, netsQrState) {
          if (netsQrState.status.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return Scaffold(
            backgroundColor: Colors.white,
            body: SafeArea(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                      child: netsQrCode(netsQrState),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: Text(
                        netsTimerText,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      child: Image.asset(
                        'assets/images/netsQrInfo.png',
                        width: MediaQuery.of(context).size.width * 0.85,
                      ),
                    ),
                    const SizedBox(height: 24),
                    btnCancel(),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
