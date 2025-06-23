import 'package:flutter/material.dart';
import 'package:redeem_order_app/models/nets_bank_card_model.dart';
import 'package:redeem_order_app/utils/config.dart';

class NetsBankCardDetailsLayout extends StatefulWidget {
  final NetsBankCard netsBankCard;
  const NetsBankCardDetailsLayout({super.key, required this.netsBankCard});

  @override
  State<NetsBankCardDetailsLayout> createState() => _NetsBankCardDetailsLayoutState();
}

class _NetsBankCardDetailsLayoutState extends State<NetsBankCardDetailsLayout> {

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: MediaQuery.sizeOf(context).width,
          child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Image.asset(Config().netsLogoPath, width: 50, fit: BoxFit.cover,),
                      const SizedBox(width: 16),
                      Text('NETS Bank Card ${widget.netsBankCard.lastFourDigit}', style: Theme.of(context).textTheme.bodyLarge),
                    ],
                  ),
                  Text('${widget.netsBankCard.issuerShortName} Card (****${widget.netsBankCard.lastFourDigit})'),
                  Text('Valid until ${widget.netsBankCard.expiryDate.substring(0, 2)}/${widget.netsBankCard.expiryDate.substring(3, 5)}'),
                  const SizedBox(height: 10,),
                  GestureDetector(
                    child: const Text('Remove Card', style: TextStyle(color: Colors.teal, decoration: TextDecoration.underline,)),
                  ),
                  const SizedBox(height: 10,),
                  const Divider(),
                ],
              )
          ),
        ),
      ],
    );
  }

}