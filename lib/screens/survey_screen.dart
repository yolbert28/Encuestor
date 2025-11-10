import 'package:encuestor/components/primary_button.dart';
import 'package:encuestor/components/survey_question.dart';
import 'package:encuestor/core/app_color.dart';
import 'package:encuestor/core/text_style.dart';
import 'package:encuestor/domain/survey.dart';
import 'package:encuestor/domain/survey_option.dart';
import 'package:flutter/material.dart';

class SurveyScreen extends StatefulWidget {
  final String subjectId;
  const SurveyScreen({super.key, required this.subjectId});

  @override
  State<SurveyScreen> createState() => _SurveyScreenState();
}

var survey = [
  Survey(
    id: 1,
    question: "Pregunta de prueba 1",
    subjectId: 1,
    options: [
      SurveyOption(id: "1", text: "Opción 1", questionId: 1),
      SurveyOption(id: "2", text: "Opción 2", questionId: 1),
      SurveyOption(id: "3", text: "Opción 3", questionId: 1),
      SurveyOption(id: "4", text: "Opción 4", questionId: 1),
    ],
  ),
  Survey(
    id: 2,
    question: "Pregunta de prueba 2",
    subjectId: 1,
    options: [
      SurveyOption(id: "1", text: "Opción 1", questionId: 2),
      SurveyOption(id: "2", text: "Opción 2", questionId: 2),
      SurveyOption(id: "3", text: "Opción 3", questionId: 2),
      SurveyOption(id: "4", text: "Opción 4", questionId: 2),
    ],
  ),
  Survey(
    id: 3,
    question: "Pregunta de prueba 3",
    subjectId: 1,
    options: [
      SurveyOption(id: "1", text: "Opción 1", questionId: 3),
      SurveyOption(id: "2", text: "Opción 2", questionId: 3),
      SurveyOption(id: "3", text: "Opción 3", questionId: 3),
      SurveyOption(id: "4", text: "Opción 4", questionId: 3),
    ],
  ),
  Survey(
    id: 4,
    question: "Pregunta de prueba 4",
    subjectId: 1,
    options: [
      SurveyOption(id: "1", text: "Opción 1", questionId: 4),
      SurveyOption(id: "2", text: "Opción 2", questionId: 4),
      SurveyOption(id: "3", text: "Opción 3", questionId: 4),
      SurveyOption(id: "4", text: "Opción 4", questionId: 4),
    ],
  ),
  Survey(
    id: 5,
    question: "Pregunta de prueba 5",
    subjectId: 1,
    options: [
      SurveyOption(id: "1", text: "Opción 1", questionId: 5),
      SurveyOption(id: "2", text: "Opción 2", questionId: 5),
      SurveyOption(id: "3", text: "Opción 3", questionId: 5),
      SurveyOption(id: "4", text: "Opción 4", questionId: 5),
    ],
  ),
  Survey(
    id: 6,
    question: "Pregunta de prueba 6",
    subjectId: 1,
    options: [
      SurveyOption(id: "1", text: "Opción 1", questionId: 6),
      SurveyOption(id: "2", text: "Opción 2", questionId: 6),
      SurveyOption(id: "3", text: "Opción 3", questionId: 6),
      SurveyOption(id: "4", text: "Opción 4", questionId: 6),
    ],
  ),
  Survey(
    id: 7,
    question: "Pregunta de prueba 7",
    subjectId: 1,
    options: [
      SurveyOption(id: "1", text: "Opción 1", questionId: 7),
      SurveyOption(id: "2", text: "Opción 2", questionId: 7),
      SurveyOption(id: "3", text: "Opción 3", questionId: 7),
      SurveyOption(id: "4", text: "Opción 4", questionId: 7),
    ],
  ),
  Survey(
    id: 8,
    question: "Pregunta de prueba 8",
    subjectId: 1,
    options: [
      SurveyOption(id: "1", text: "Opción 1", questionId: 8),
      SurveyOption(id: "2", text: "Opción 2", questionId: 8),
      SurveyOption(id: "3", text: "Opción 3", questionId: 8),
      SurveyOption(id: "4", text: "Opción 4", questionId: 8),
    ],
  ),
  Survey(
    id: 9,
    question: "Pregunta de prueba 9",
    subjectId: 1,
    options: [
      SurveyOption(id: "1", text: "Opción 1", questionId: 9),
      SurveyOption(id: "2", text: "Opción 2", questionId: 9),
      SurveyOption(id: "3", text: "Opción 3", questionId: 9),
      SurveyOption(id: "4", text: "Opción 4", questionId: 9),
    ],
  ),
  Survey(
    id: 10,
    question: "Pregunta de prueba 10",
    subjectId: 1,
    options: [
      SurveyOption(id: "1", text: "Opción 1", questionId: 10),
      SurveyOption(id: "2", text: "Opción 2", questionId: 10),
      SurveyOption(id: "3", text: "Opción 3", questionId: 10),
      SurveyOption(id: "4", text: "Opción 4", questionId: 10),
    ],
  ),
  Survey(
    id: 11,
    question: "Pregunta de prueba 11",
    subjectId: 1,
    options: [
      SurveyOption(id: "1", text: "Opción 1", questionId: 11),
      SurveyOption(id: "2", text: "Opción 2", questionId: 11),
      SurveyOption(id: "3", text: "Opción 3", questionId: 11),
      SurveyOption(id: "4", text: "Opción 4", questionId: 11),
    ],
  ),
  Survey(
    id: 12,
    question: "Pregunta de prueba 12",
    subjectId: 1,
    options: [
      SurveyOption(id: "1", text: "Opción 1", questionId: 12),
      SurveyOption(id: "2", text: "Opción 2", questionId: 12),
      SurveyOption(id: "3", text: "Opción 3", questionId: 12),
      SurveyOption(id: "4", text: "Opción 4", questionId: 12),
    ],
  ),
];

class _SurveyScreenState extends State<SurveyScreen> {
  var response = <int, int?>{};

  int _currentPage = 0;
  final int _pageSize = 5;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    for (var s in survey) {
      response[s.id] = 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    final int startIndex = _currentPage * _pageSize;
    final int endIndex = (startIndex + _pageSize > survey.length)
        ? survey.length
        : startIndex + _pageSize;
    final List<Survey> currentSurveys = survey.sublist(startIndex, endIndex);
    final bool isLastPage = (_currentPage + 1) * _pageSize >= survey.length;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppColor.primary,
        title: Image.asset("assets/images/logo.png", width: 140),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 16, bottom: 16),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                controller: _scrollController,
                child: Column(
                  children: [
                    SizedBox(height: 8),
                    Text("Sistemas Operativos", style: TextStyles.title),
                    SizedBox(height: 16),
                    for (var s in currentSurveys)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: SurveyQuestion(
                          key: Key(s.id.toString()),
                          survey: s,
                          questionNumber: s.id.toString(),
                          onChanged: (t) {
                            setState(() {
                              response[s.id] = t;
                            });
                          },
                        ),
                      ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16),
            PrimaryButton(
              text: isLastPage ? "Finalizar" : "Siguiente",
              onPressed: () {
                if (!isLastPage) {
                  setState(() {
                    _currentPage++;
                  });
                  _scrollController.animateTo(
                    0.0,
                    duration: Duration(milliseconds: 300),
                    curve: Curves.easeOut,
                  );
                } else {
                  // Lógica para finalizar la encuesta
                  showDialog(
                    context: context,
                    barrierDismissible: false, // El usuario debe presionar el botón
                    builder: (BuildContext context) {
                      return AlertDialog(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        insetPadding: EdgeInsets.all(20),
                        actionsPadding: EdgeInsets.only(bottom: 20, top: 8),
                        backgroundColor: AppColor.primary,
                        title: Text("Sus respuestas fueron enviadas con exito", textAlign: TextAlign.center, style: TextStyles.titleLight),
                        content: Text("¡Gracias por completar la encuesta!", style: TextStyles.body),
                        actions: <Widget>[
                          PrimaryButton(
                            text: "Aceptar",
                            onPressed: () {
                              // Navigator.pushAndRemoveUntil(
                              //   context,
                              //   MaterialPageRoute(builder: (context) => const HomeScreen()),
                              //   (Route<dynamic> route) => false,
                              // );
                            },
                          ),
                        ],
                      );
                    },
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
