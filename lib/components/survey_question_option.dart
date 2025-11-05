import 'package:encuestor/core/app_color.dart';
import 'package:flutter/material.dart';

class SurveyQuestionOption extends StatefulWidget {
  final String text;
  final int value;

  const SurveyQuestionOption({
    super.key,
    required this.text,
    required this.value,
  });

  @override
  State<SurveyQuestionOption> createState() => _SurveyQuestionOptionState();
}

class _SurveyQuestionOptionState extends State<SurveyQuestionOption> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 20),
      child: Row(
        children: [
          Radio(value: widget.value, activeColor: AppColor.accent),
          Expanded(child: Text(widget.text)),
        ],
      ),
    );
  }
}
