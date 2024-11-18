import 'package:final_project/components/square_button.dart';
import 'package:flutter/material.dart';

class ChallengeResultPage extends StatefulWidget {
  final int score;
  const ChallengeResultPage({super.key, required this.score});

  @override
  State<ChallengeResultPage> createState() => _ChallengeResultPageState();
}

class _ChallengeResultPageState extends State<ChallengeResultPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      backgroundColor: Colors.blueGrey[800],
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: Text(
                widget.score > 3
                ? "Congratulations! You beat our model!"
                : widget.score == 3
                  ? "Good job. You tied our model."
                  : "Nice try. Our model beat you.",
                style: const TextStyle(
                  fontFamily: "Rowdies",
                  fontSize: 56.0,
                ),
              ),
            ),
          ),
          // const SizedBox(
          //   height: 10.0,
          // ),
          Text(
            "${widget.score} / 5",
            style: const TextStyle(
              fontSize: 30.0, 
              fontStyle: FontStyle.normal, 
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          const SizedBox(
            height: 10.0,
          ),
          SquareButton(
            displayText: "Return to home",
            onPressCallback: () {
              Navigator.of(context).popUntil((route) => route.isFirst);
            },
          ),
        ],
      ),
    );
  }
}
