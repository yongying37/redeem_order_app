import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:redeem_order_app/models/cart_item_model.dart';
import 'package:redeem_order_app/models/nets_bank_card_model.dart';
import 'package:redeem_order_app/models/payment_details_model.dart';
import 'package:redeem_order_app/utils/config.dart';
import 'package:redeem_order_app/views/nets_click_loader/nets_click_loader_page.dart';
import 'package:redeem_order_app/widgets/bank_card_widget.dart';

class NetsClickLayout extends StatefulWidget {
  final String orderType;
  final List<CartItem> cartItems;
  final double totalAmount;
  const NetsClickLayout({
    super.key,
    required this.orderType,
    required this.cartItems,
    required this.totalAmount,
  });

  @override
  State<NetsClickLayout> createState() => _NetsClickLayoutState();
}

class _NetsClickLayoutState extends State<NetsClickLayout> {
  final GlobalKey<FormState> _mainPaymentFormKey = GlobalKey<FormState>();
  late final TextEditingController _mainPaymentAmountController;
  late final TextEditingController _mainPaymentRecordIdController;

  @override
  void initState() {
    super.initState();

    _mainPaymentAmountController = TextEditingController(text: widget.totalAmount.toStringAsFixed(2));
    _mainPaymentRecordIdController = TextEditingController(text: '1'); // Hardcoded value
  }

  @override
  void dispose() {
    _mainPaymentAmountController.dispose();
    _mainPaymentRecordIdController.dispose();
    super.dispose();
  }

  List<Widget> renderPaymentForm() {
    return [
      const Text('Payment to be made', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      Form(
        key: _mainPaymentFormKey,
        child: Column(
          children: [
            TextFormField(
              controller: _mainPaymentRecordIdController,
              decoration: const InputDecoration(labelText: 'Record ID'),
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(9),
              ],
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter Record ID';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _mainPaymentAmountController,
              readOnly: true,
              decoration: const InputDecoration(labelText: 'Amount'),
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(9),
              ],
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter Amount';
                }
                return null;
              },
            ),
          ],
        ),
      ),
    ];
  }

  List<Widget> renderPaymentCards() {
    return [
      const SizedBox(height: 16),
      const Text('Select Payment Card', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      const SizedBox(height: 5),
      BankCard(netsBankCard: NetsBankCard(id: Config().netsBankCardId, issuerShortName: 'TEST', paymentMode: 'NETS Click', lastFourDigit: '1234', expiryDate: '27/12'), width: MediaQuery.sizeOf(context).width)
    ];
  }

  _onSubmit() async {
    if (!_mainPaymentFormKey.currentState!.validate()) return;

    final mainPaymentDetails = PaymentDetails(
      amtInDollars: _mainPaymentAmountController.text,
      recordId: _mainPaymentRecordIdController.text,
      identifier: Config().mainPaymentIdentifier,
    );

    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NetsClickLoaderPage(
          mainPaymentDetails: mainPaymentDetails,
          orderType: widget.orderType,
          cartItems: widget.cartItems,
          totalAmount: widget.totalAmount,
        ),
      ),
    );

    if (result == 'reset_order_type') {
      Navigator.pop(context, 'reset_order_type');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ...renderPaymentForm(),
              ...renderPaymentCards(),
            ],
          ),
          Container(
            width: MediaQuery.sizeOf(context).width,
            decoration: BoxDecoration(
              color: Colors.deepPurple,
              borderRadius: BorderRadius.circular(10),
            ),
            child: TextButton(
              style: TextButton.styleFrom(
                backgroundColor: Colors.red, // same as ElevatedButton
                foregroundColor: Colors.white, // text/icon color
                padding: const EdgeInsets.symmetric(vertical: 16),
                textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              onPressed: () {
                _onSubmit();
              },
              child: const Text('Proceed with Payment', style: TextStyle(color: Colors.white)),
            ),
          )
        ],
      ),
    );
  }

}

