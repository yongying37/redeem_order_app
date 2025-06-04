import 'package:flutter/material.dart';

class CartLayout extends StatefulWidget {
  const CartLayout({super.key});

  @override
  State<CartLayout> createState() => _CartLayoutState();
}

class _CartLayoutState extends State<CartLayout> {
  int quantity = 1;
  String orderType = 'Dine In';
  int selectedDiscount = 0;

  void showRedeemDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("Redeem Points", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                SizedBox(height: 4),
                Text("200 points available", style: TextStyle(color: Colors.grey)),

                SizedBox(height: 20),
                _buildRedeemOption("\$1 off", 100),
                _buildRedeemOption("\$2 off", 200),
                _buildRedeemOption("\$3 off", 300),

                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue, minimumSize: Size(double.infinity, 50)),
                  child: Text("Redeem Now"),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildRedeemOption(String label, int points) {
    return ListTile(
      shape: RoundedRectangleBorder(
        side: BorderSide(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(12),
      ),
      title: Text(label),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text("$points points"),
          Radio<int>(
            value: points,
            groupValue: selectedDiscount,
            onChanged: (value) {
              setState(() {
                selectedDiscount = value!;
              });
              Navigator.pop(context);
              showRedeemDialog(); // Refresh selection
            },
          )
        ],
      ),
      onTap: () {
        setState(() {
          selectedDiscount = points;
        });
        Navigator.pop(context);
        showRedeemDialog(); // Refresh selection
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double itemPrice = 3.90;
    double total = (quantity * itemPrice) - (selectedDiscount / 100.0);
    total = total < 0 ? 0 : total;

    return SafeArea(
      child: Column(
        children: [
          Container(
            color: Colors.grey[300],
            width: double.infinity,
            padding: EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Chicken Rice', style: TextStyle(fontWeight: FontWeight.bold)),
                Row(
                  children: [
                    Icon(Icons.location_on, size: 18),
                    Text('Foodgle Hub', style: TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
              ],
            ),
          ),
          ListTile(
            leading: Image.asset(
              'assets/images/roasted_chicken.jpeg',
              width: 109,
              height: 88,
            ),
            title: Text('Roasted Chicken'),
            subtitle: Text('Single Meat Rice'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.remove),
                  onPressed: () => setState(() {
                    if (quantity > 1) {
                      quantity--;
                    }
                  }),
                ),
                Text('$quantity'),
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () => setState(() {
                    quantity++;
                  }),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: TextField(
              decoration: InputDecoration(labelText: 'Order Note'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Order Info', style: TextStyle(fontWeight: FontWeight.bold)),
                Row(
                  children: [
                    Radio<String>(
                      value: 'Dine In',
                      groupValue: orderType,
                      onChanged: (value) => setState(() => orderType = value!),
                    ),
                    Text('Dine In'),
                    Radio<String>(
                      value: 'Take Out',
                      groupValue: orderType,
                      onChanged: (value) => setState(() => orderType = value!),
                    ),
                    Text('Take Out'),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Collection Time'),
                    TextButton(
                      onPressed: () {},
                      child: Text('Now'),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.attach_money),
            title: Text('Enjoy discounts with your points'),
            onTap: showRedeemDialog,
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child:Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Total \$${total.toStringAsFixed(2)}',
                    style: TextStyle(fontSize: 14, color: Colors.red)),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
                  onPressed: () {},
                  child: Text('Check Out'),
                ),
              ],
            ),
          ),
        ],
      ),
    );

  }
}
