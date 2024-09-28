import 'package:flutter/material.dart';
import 'package:sign_recognition/questionConstants.dart';

class quizQuestion extends StatefulWidget {
  final int level;
  const quizQuestion({super.key, required this.level});

  @override
  State<quizQuestion> createState() => _QuizQuestionState();
}

class _QuizQuestionState extends State<quizQuestion> {
  int score = 0;
  int quesNumber = 1;
  int? selectedOption;
  bool? isCorrect;
  int correctAnswerIndex = 0;

  @override
  void initState() {
    super.initState();
    // Initialize any data or state here
  }

  void _nextQuestion(int selectedIndex) {
    setState(() {
      selectedOption = selectedIndex;
      isCorrect = selectedIndex == 0;
      if (selectedIndex == 0) {
        score++;
      }
    });

    Future.delayed(const Duration(seconds: 1), () {
      if (quesNumber < Questions().map[widget.level]!.length) {
        setState(() {
          quesNumber++;
          selectedOption = null; // Reset selection
          isCorrect = null; // Reset feedback
        });
      } else {
        _showFinalScore(context);
      }
    });
  }


  void _showFinalScore(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Quiz Finished!'),
        content: Text('Your final score is $score.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop(); // Go back to previous screen
            },
            child: const Text('OK'),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const SizedBox(height: 60),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Align(
                alignment: Alignment.topLeft,
                child: Text(
                  "Level ${widget.level}",
                  style: const TextStyle(color: Colors.white, fontSize: 30),
                ),
              ),
            ),
            const SizedBox(height: 20),
            _questionTile(context, widget.level, quesNumber),
            const SizedBox(height: 20),
            Expanded(
              child: _optionTile(context, widget.level, quesNumber),
            ),
            const SizedBox(height: 20),
            Text(
              "Score: $score",
              style: const TextStyle(color: Colors.white, fontSize: 20),
            ),
          ],
        ),
      ),
    );
  }

  Widget _questionTile(BuildContext context, int level, int quesNumber) {
    return ListTile(
      leading: Text(
        '$quesNumber',
        style: const TextStyle(color: Colors.white, fontSize: 20),
      ),
      title: Container(
        height: 200,
        width: 200,
        decoration: BoxDecoration(
          color: Colors.grey,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Image.asset(
          "assets/img.png",
          fit: BoxFit.cover,
        ),

      )
    );
  }

  Widget _optionTile(BuildContext context, int level, int quesNumber) {
    return GridView.count(
      crossAxisCount: 2,
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      childAspectRatio: 2.5,
      children: List.generate(4, (index) {
        Color tileColor;

        if (selectedOption == null) {
          tileColor = Colors.grey;
        } else if (index == selectedOption && isCorrect == true) {
          tileColor = Colors.green;
        } else if (index == selectedOption && isCorrect == false) {
          tileColor = Colors.red;
        } else if (index == correctAnswerIndex && isCorrect == false) {
          tileColor = Colors.green;
        } else {
          tileColor = Colors.grey;
        }

        return GestureDetector(
          onTap: selectedOption == null ? () => _nextQuestion(index) : null,
          child: Container(
            decoration: BoxDecoration(
              color: tileColor,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Center(
              child: Text(
                'Option ${index + 1}',
                style: const TextStyle(fontSize: 20, color: Colors.white),
              ),
            ),
          ),
        );
      }),
    );
  }
}
