import 'package:encuestor/core/app_color.dart';
import 'package:encuestor/core/text_style.dart';
import 'package:encuestor/domain/question_option.dart';
import 'package:flutter/material.dart';

class SurveyTextField extends StatefulWidget {
  final bool isEditable;
  final QuestionOption option;
  final Function(String) onChanged;

  const SurveyTextField(
      {super.key,
      required this.isEditable,
      required this.option,
      required this.onChanged});

  @override
  State<SurveyTextField> createState() => _SurveyTextFieldState();
}

class _SurveyTextFieldState extends State<SurveyTextField> {
  late final TextEditingController _controller;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 8,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 20.0),
          child: Icon(Icons.circle, size: 8, color: AppColor.textDarkProfesor),
        ),
        Expanded(
          child: TextField(
            controller: TextEditingController(text: widget.option.text),
            onChanged: widget.onChanged,
            maxLines: null,
            style: TextStyles.body,
            decoration: InputDecoration(
              filled: true,
              fillColor: widget.isEditable
                  ? AppColor.primaryP
                  : AppColor.disableSurveyTextField,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: BorderSide.none,
              ),
            ),
            enabled: widget.isEditable,
          ),
        ),
      ],
    );
  }
}
