import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:redeem_order_app/models/payment_details_model.dart';
import 'package:redeem_order_app/views/home/home_page.dart';
import 'package:redeem_order_app/bloc/nets_click/nets_click_bloc.dart';
import 'package:redeem_order_app/utils/config.dart';

class NetsClickLoaderLayout extends StatefulWidget {
  final PaymentDetails mainPaymentDetails;
  final String userId;
  const NetsClickLoaderLayout({super.key, required this.mainPaymentDetails, required this.userId});

  @override
  State<NetsClickLoaderLayout> createState() => _NetsClickLoaderLayoutState();
}

class _NetsClickLoaderLayoutState extends State<NetsClickLoaderLayout> {
  @override
  void initState() {
    super.initState();
    // Delay event dispatch until after UI loads
    Future.microtask(() {
      BlocProvider.of<NetsClickBloc>(context).add(MakePayment(widget.mainPaymentDetails));
    });
  }

  Widget renderLoadingScreen(NetsClickState netsClickState) {
    if (netsClickState.status.isMakePaymentError) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(netsClickState.errorTitle, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black)),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset(
              Config().redCrossPath, fit: BoxFit.cover, width: 180,),
          ),
          Text(netsClickState.errorMessage, textAlign: TextAlign.center),
          const SizedBox(height: 20,),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Go back'),
          ),
        ],
      );
    } else if (netsClickState.status.isMakePaymentLoading) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const CircularProgressIndicator(),
          const SizedBox(height: 20,),
          Text(netsClickState.loadingTitle, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black)),
          Text(netsClickState.loadingMessage, textAlign: TextAlign.center),
        ],
      );
    } else {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(netsClickState.successTitle, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black)),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset(Config().greenTickPath, fit: BoxFit.cover, width: 180,),
          ),
          Text(netsClickState.successMessage, textAlign: TextAlign.center),
          const SizedBox(height: 20,),
          ElevatedButton(
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => HomePage(userId: widget.userId)),
                  (Route<dynamic> route) => false,
              );
            },
            child: const Text('Go back'),
          ),
        ],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NetsClickBloc, NetsClickState>(
      builder: (context, netsClickState) {
        return PopScope(
          canPop: false,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(child: renderLoadingScreen(netsClickState)),
          ),
        );
      },
    );
  }
}