import 'package:encuestor/components/primary_button.dart';
import 'package:encuestor/components/secondary_button.dart';
import 'package:encuestor/components/survey_add_text_field.dart';
import 'package:encuestor/core/app_color.dart';
import 'package:encuestor/core/text_style.dart';
import 'package:flutter/material.dart';

class SurveyAddCard extends StatefulWidget {
  const SurveyAddCard({super.key});

  @override
  State<SurveyAddCard> createState() => _SurveyAddCardState();
}

class _SurveyAddCardState extends State<SurveyAddCard> {
  var showInfo = false;
  var isEditable = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0),
          border: Border.all(width: 2, color: AppColor.primaryP),
          color: AppColor.surveyEditCardBackground,
        ),
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: GestureDetector(
            onTap: () {
              setState(() {
                showInfo = !showInfo;
              });
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Pregunta 1", style: TextStyles.subtitleProfesor),
                if (showInfo)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 8,
                    children: [
                      Text(
                        "Una pregunta muy larga que hizo el profesor para joder",
                        style: TextStyles.bodyProfesor,
                      ),
                      SurveyAddTextField(isEditable: isEditable, text: "input 1"),
                      SurveyAddTextField(isEditable: isEditable, text: "input 1"),
                      SurveyAddTextField(isEditable: isEditable, text: "input 1"),
                      SurveyAddTextField(isEditable: isEditable, text: "input 1"),
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: isEditable
                            ? Column(
                                spacing: 8,
                                children: [
                                  SecondaryButton(
                                    text: "Agregar opción",
                                    onPressed: () {},
                                    horizontalPadding: 0,
                                    height: 40,
                                  ),
                                  Row(
                                    spacing: 8,
                                    children: [
                                      Expanded(
                                        child: SecondaryButton(
                                          text: "Cancelar",
                                          onPressed: () {
                                            setState(() {
                                              isEditable = false;
                                            });
                                          },
                                          backgroundColor:
                                              AppColor.cancelButtonBackground,
                                          borderColor: AppColor.darkGreen,
                                          horizontalPadding: 0,
                                          height: 40,
                                        ),
                                      ),
                                      Expanded(
                                        child: PrimaryButton(
                                          text: "Guardar",
                                          onPressed: () {},
                                          horizontalPadding: 0,
                                          height: 40,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              )
                            : SecondaryButton(
                                text: "Edit",
                                height: 40,
                                horizontalPadding: 0,
                                onPressed: () {
                                  setState(() {
                                    isEditable = true;
                                  });
                                },
                              ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
