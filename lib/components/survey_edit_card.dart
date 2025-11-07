import 'package:encuestor/components/primary_button.dart';
import 'package:encuestor/components/secondary_button.dart';
import 'package:encuestor/core/app_color.dart';
import 'package:encuestor/core/text_style.dart';
import 'package:flutter/material.dart';

class SurveyEditCard extends StatefulWidget {
  const SurveyEditCard({super.key});

  @override
  State<SurveyEditCard> createState() => _SurveyEditCardState();
}

class _SurveyEditCardState extends State<SurveyEditCard> {
  var showInfo = false;

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
            onTap: (){
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
                      Text("* primera jodida", style: TextStyles.bodyProfesor),
                      Text("* segunda jodida", style: TextStyles.bodyProfesor),
                      Text("* tercera jodida", style: TextStyles.bodyProfesor),
                      Padding(
                        padding: const EdgeInsets.only(top:8.0),
                        child: SecondaryButton(text: "Edit", height: 40, horizontalPadding: 0, onPressed: (){}),
                      )
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
