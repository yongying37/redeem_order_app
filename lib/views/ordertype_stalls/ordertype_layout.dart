import 'package:flutter/material.dart';

class OrderTypesLayout extends StatefulWidget {
  final bool supportsDinein;
  final bool supportsTakeaway;
  final String stallName;
  final void Function(String orderType) onContinue;

  const OrderTypesLayout({
    Key? key,
    required this.supportsDinein,
    required this.supportsTakeaway,
    required this.stallName,
    required this.onContinue,
  }) : super(key : key);

  @override
  _OrderTypesLayoutState createState() => _OrderTypesLayoutState();
}

class _OrderTypesLayoutState extends State<OrderTypesLayout> {
  String? selectedOption;
  // May add date time for users to select but for
  // now the collection time would be 'Now'
  Color normalBg = Colors.white;
  Color normalBorder = Colors.grey;
  Color normalText = Colors.black;

  Color selectedBg = Color(0xFF0072B2);
  Color selectedBorder = Color(0xFFD55E00);
  Color selectedText = Colors.white;

  void _handleOptionSelected(String option) {
    setState(() {
      selectedOption = option;
    });
  }

  void _onContinue() {
    if (selectedOption != null) {
      widget.onContinue(selectedOption!);
    }
  }

  Widget _buildOption(String label) {
    final bool isSelected = selectedOption == label;

    IconData iconData;
    if (label == "Take Away") {
      iconData = Icons.shopping_bag;
    }
    else if (label == "Dine In") {
      iconData = Icons.restaurant;
    }
    else {
      iconData = Icons.help_outline;
    }

    return GestureDetector(
      onTap: () => _handleOptionSelected(label),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
        margin: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? selectedBg : normalBg,
          border: Border.all(
            color: isSelected ? selectedBorder : normalBorder,
            width: isSelected ? 2.5 : 1.0,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Icon(
              iconData,
              color: isSelected ? selectedText : normalText,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  color: isSelected ? selectedText : normalText,
                  fontSize: 18,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),
            if (isSelected) ...[
              const SizedBox(width: 8),
              Icon(Icons.check_circle, color: selectedText),
            ],
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final onlyTakeaway = widget.supportsTakeaway && !widget.supportsDinein;
    final onlyDinein = widget.supportsDinein && !widget.supportsTakeaway;
    final bothOptions = widget.supportsDinein && widget.supportsTakeaway;

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              if (onlyTakeaway)
                const Text(
                  "This stall only allows take aways.",
                  style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                ),

              if (onlyDinein)
                const Text(
                  "This stall only allows dine in.",
                  style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                ),

              if (bothOptions)
                const Text(
                  "This stall allows both dine in and take away.",
                  style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                ),
              const SizedBox(height: 20),

              if (widget.supportsTakeaway) _buildOption("Take Away"),
              if (widget.supportsDinein) _buildOption("Dine In"),

              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: selectedOption != null ? _onContinue : null,
                child: Text("Continue"),
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(double.infinity, 50),
                  backgroundColor: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      )
    );
  }
}