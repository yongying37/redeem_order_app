import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:redeem_order_app/bloc/nets_qr/nets_qr_bloc.dart';
import 'package:redeem_order_app/views/home/home_page.dart';

class TxnNetsSuccessStatusLayout extends StatefulWidget {
  final String orderType;

  const TxnNetsSuccessStatusLayout({super.key, required this.orderType});

  @override
  State<TxnNetsSuccessStatusLayout> createState() =>
      _TxnNetsSuccessStatusLayoutState();
}

class _TxnNetsSuccessStatusLayoutState
    extends State<TxnNetsSuccessStatusLayout> {
  @override
  Widget build(BuildContext context) {
    Widget btnSuccess() {
      return ElevatedButton(
        style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red.shade900,
            shape: RoundedRectangleBorder(
              borderRadius:
              BorderRadius.circular(10),
            )),
        onPressed: () async {
          BlocProvider.of<NetsQrBloc>(context).add(const CancelWebhookNetsQrEvent());
          await Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage()));
        },
        child: const Padding(
          padding: EdgeInsets.all(15.0),
          child: Text('BACK TO HOME PAGE',
              style: TextStyle(color: Colors.white, fontSize: 20)),
        ),
      );
    }

    return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.5,
              height: MediaQuery.of(context).size.height * 0.3,
              child: Image.asset('assets/images/greenTick.png'),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 20.0),
              child: Text(
                'TRANSACTION COMPLETED',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
            ),
            btnSuccess()
          ],
        ));
  }
}
