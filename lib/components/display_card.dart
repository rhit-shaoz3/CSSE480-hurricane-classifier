import 'package:flutter/material.dart';

class DisplayCard extends StatelessWidget {
  final String labelText;
  final IconData iconData;
  final String displayText;

  const DisplayCard({
    super.key,
    required this.labelText,
    required this.iconData,
    required this.displayText,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          labelText,
          style: const TextStyle(
            fontSize: 30.0,
            fontFamily: "Rowdies",
          ),
        ),
        Card(
          child: Container(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              children: [
                Icon(iconData),
                const SizedBox(
                  width: 10.0,
                ),
                Expanded(
                  child: Text(
                    displayText,
                    style: const TextStyle(fontSize: 18.0),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}