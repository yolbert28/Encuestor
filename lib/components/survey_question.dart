import 'package:encuestor/components/survey_question_option.dart';
import 'package:encuestor/core/text_style.dart';
import 'package:encuestor/domain/question.dart';
import 'package:flutter/material.dart';

class SurveyQuestion extends StatefulWidget {
  final Question question;
  final String questionNumber;
  final Function(String?) onChanged;

  const SurveyQuestion({super.key, required this.questionNumber, required this.question, required this.onChanged});

  @override
  State<SurveyQuestion> createState() => _SurveyQuestionState();
}

class _SurveyQuestionState extends State<SurveyQuestion> {
  String? groupValue = "";

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 16,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 4,
            children: [
              Text("Pregunta ${widget.questionNumber}", style: TextStyles.subtitle),
              Text(
                widget.question.question,
              ),
            ],
          ),
          RadioGroup(
            onChanged: (t){
              setState(() {
                groupValue = t;
              });
              widget.onChanged(t);
            },
            groupValue: groupValue,
            child: Column(
              children: widget.question.options
                  .map((option) => SurveyQuestionOption(text: option.text, value: option.id))
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}
