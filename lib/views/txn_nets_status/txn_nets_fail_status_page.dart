import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:redeem_order_app/bloc/cart/cart_bloc.dart';
import 'package:redeem_order_app/bloc/nets_qr/nets_qr_bloc.dart';
import 'txn_nets_fail_status_layout.dart';

class TxnNetsFailStatusPage extends StatelessWidget {
  final String orderType;

  const TxnNetsFailStatusPage({super.key, required this.orderType});

  @override
  Widget build(BuildContext context) {
    final cartBloc = BlocProvider.of<CartBloc>(context);
    final netsQrBloc = BlocProvider.of<NetsQrBloc>(context);

    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: cartBloc),
        BlocProvider.value(value: netsQrBloc),
      ],
      child: TxnNetsFailStatusLayout(orderType: orderType),
    );
  }
}

