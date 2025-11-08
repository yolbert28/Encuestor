import 'package:encuestor/core/app_color.dart';
import 'package:encuestor/core/text_style.dart';
import 'package:flutter/material.dart';

class SurveyTextField extends StatefulWidget {
  final bool isEditable;
  final String text;

  const SurveyTextField({super.key, required this.isEditable, required this.text});

  @override
  State<SurveyTextField> createState() => _SurveyTextFieldState();
}

class _SurveyTextFieldState extends State<SurveyTextField> {
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
            controller: TextEditingController(
              text: widget.text
            ),
            maxLines: null,
            style: TextStyles.body,
            decoration: InputDecoration(
              // hint: Text(
              //   "Primer jodida larguisima Dios mio cuanto texto en este formulariooooooooooo",
              //   style: TextStyles.body,
              // ),
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
