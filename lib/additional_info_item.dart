import 'package:flutter/material.dart';

//here we will make it constructor so that user can select icons and text
//on its' own

class AddtionalInfoItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const AddtionalInfoItem({
    super.key,
    //positional argument which is required this. in dart used
    //named argument can also be used
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(
          icon,
          size: 32,
        ),
        const SizedBox(
          height: 8,
        ),
        Text(label),
        const SizedBox(
          height: 8,
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
