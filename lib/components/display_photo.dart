import 'package:flutter/material.dart';

class DisplayPhoto extends StatelessWidget {
  final String displayImage;

  const DisplayPhoto({
    super.key,
    required this.displayImage,
  });

  @override
  Widget build(BuildContext context) {
    bool isWeb = false;
    if (displayImage.contains("http")) {
      isWeb = true;
    }
    return Column(
      children: [
        Card(
          child: Container(
            width: 300,
            height: 300,
            padding: const EdgeInsets.all(20.0),
            child:
              FittedBox(
                child: Center(
                  child: isWeb
                    ? Image.network(
                      displayImage,
                      width: 150,
                      height: 150,
                      fit: BoxFit.cover,
                    )
                    : Image.asset(
                      displayImage,
                      width: 150,
                      height: 150,
                      fit: BoxFit.cover,
                    ),
                )
              ),
            ),
        ),
      ],
    );
  }
}