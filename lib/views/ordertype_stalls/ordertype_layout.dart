import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/ordertype/ordertype_bloc.dart';

class OrderTypesLayout extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return BlocConsumer<OrderTypeBloc, OrderTypeState>(
        listener: (context, state) {
          if (state.status == OrderTypeStatus.confirmed && state.selectedOption != null) {
            onContinue(state.selectedOption!);
          }
        },
        builder: (context, state) {
          final selectedType = state.selectedOption;

          Widget buildOption(String label) {
            final isSelected = selectedType == label;

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
              onTap: () => context.read<OrderTypeBloc>().add(SelectOrderType(label)),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                margin: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: isSelected ? const Color(0xFF0072B2) : Colors.white,
                  border: Border.all(
                    color: isSelected ? const Color(0xFFD55E00) : Colors.grey,
                    width: isSelected ? 2.5 : 1.0,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    Icon(
                      iconData,
                      color: isSelected ? Colors.white : Colors.black,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        label,
                        style: TextStyle(
                          color: isSelected ? Colors.white : Colors.black,
                          fontSize: 18,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                    ),
                    if (isSelected) const Icon(Icons.check_circle, color: Colors.white),
                  ],
                ),
              ),
            );
          }

          return SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    if (supportsTakeaway && !supportsDinein)
                      const Text("This stall only allows take away.", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 18)),
                    if (supportsDinein && !supportsTakeaway)
                      const Text("This stall only allows dine in.", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 18)),
                    if (supportsDinein && supportsTakeaway)
                      const Text("This stall allows both dine in and take away.", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 18)),
                    const SizedBox(height: 20),
                    if (supportsTakeaway) buildOption("Take Away"),
                    if (supportsDinein) buildOption("Dine In"),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: selectedType != null
                          ? () => context.read<OrderTypeBloc>().add(const CfmOrderType())
                          : null,
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 50),
                        backgroundColor: Colors.grey,
                      ),
                      child: const Text("Continue"),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
    );
  }
}
