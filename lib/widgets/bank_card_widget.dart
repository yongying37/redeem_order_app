import 'package:flutter/material.dart';
import '../../models/nets_bank_card_model.dart';
import '../../utils/config.dart';
import '../views/nets_bank_card_details/nets_bank_card_details_page.dart';

class BankCard extends StatelessWidget {
  final NetsBankCard? netsBankCard;
  final double width;
  const BankCard({super.key, required this.netsBankCard, required this.width});

  Widget renderNetsBankCard(BuildContext context) {
    if (netsBankCard != null) {
      return Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: SizedBox(
          width: width,
          child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Image.asset(Config().netsLogoPath, width: 50, fit: BoxFit.cover,),
                  const SizedBox(width: 5),
                  Text('NETS Bank Card ${netsBankCard?.lastFourDigit}', style: Theme.of(context).textTheme.bodyLarge)
                ],
              )
          ),
        ),
      );
    } else {
      return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          if (netsBankCard != null) {
            Navigator.push(context, MaterialPageRoute(builder: (context) => NetsBankCardDetailsPage(netsBankCard: netsBankCard!)));
          }
        },
        child: renderNetsBankCard(context)
    );
  }
}