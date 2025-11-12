import 'package:encuestor/components/icon_button_app.dart';
import 'package:encuestor/core/app_color.dart';
import 'package:encuestor/core/text_style.dart';
import 'package:flutter/material.dart';

class SurveyAddTextField extends StatefulWidget {
  final bool isEditable;
  final String text;

  const SurveyAddTextField({
    super.key,
    required this.isEditable,
    required this.text,
  });

  @override
  State<SurveyAddTextField> createState() => _SurveyAddTextFieldState();
}

class _SurveyAddTextFieldState extends State<SurveyAddTextField> {
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
            controller: TextEditingController(text: widget.text),
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

        IconButtonApp(
          onPressed: () {},
          child: Icon(Icons.delete, color: AppColor.white),
        ),
      ],
    );
  }
}
