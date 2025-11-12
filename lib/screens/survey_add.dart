import 'package:encuestor/components/app_text_field.dart';
import 'package:encuestor/components/survey_add_card.dart';
import 'package:encuestor/core/app_color.dart';
import 'package:encuestor/core/text_style.dart';
import 'package:flutter/material.dart';

class SurveyAdd extends StatefulWidget {
  const SurveyAdd({super.key});

  @override
  State<SurveyAdd> createState() => _SurveyAddState();
}

class _SurveyAddState extends State<SurveyAdd> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.backgroundP,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppColor.primaryP,
        title: Image.asset("assets/images/logo.png", width: 140),
      ),
      body: Padding(
        padding: const EdgeInsets.only(bottom: 16, top: 16),
        child: SingleChildScrollView(
          child: Column(
            spacing: 16,
            children: [
              Text("Crear Encuesta", style: TextStyles.titleProfesor),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Text(
                      "Nombre de la asignatura:",
                      style: TextStyles.bodyProfesor,
                    ),
                  ),
                  AppTextField(
                    hintText: "Nombre de la asignatura",
                    controller: null,
                  ),
                  SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Text(
                      "Carrera de la materia:",
                      style: TextStyles.bodyProfesor,
                    ),
                  ),
                  AppTextField(
                    hintText: "Carrera de la materia",
                    controller: null,
                  ),
                  SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    child: Text(
                      "Preguntas",
                      style: TextStyles.subtitleProfesor,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(height: 8),
                  SurveyAddCard(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
