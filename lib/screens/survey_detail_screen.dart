import 'package:encuestor/components/primary_button.dart';
import 'package:encuestor/components/survey_edit_card.dart';
import 'package:encuestor/core/app_color.dart';
import 'package:encuestor/core/text_style.dart';
import 'package:encuestor/data/question_repository.dart';
import 'package:encuestor/screens/add_question_screen.dart';
import 'package:encuestor/domain/question.dart';
import 'package:encuestor/domain/subject.dart';
import 'package:flutter/material.dart';

class SurveyDetailScreen extends StatefulWidget {
  final Subject subject;
  const SurveyDetailScreen({super.key, required this.subject});

  @override
  State<SurveyDetailScreen> createState() => _SurveyDetailScreenState();
}

class _SurveyDetailScreenState extends State<SurveyDetailScreen> {
  final _questionRepository = QuestionRepository();

  List<Question> questions = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadAvailableQuestions();
  }

  _loadAvailableQuestions() async {
    try {
      final availableQuestions = await _questionRepository
          .getQuestionsForSubject(widget.subject.id);

      setState(() {
        questions = availableQuestions;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al cargar las encuestas: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.primaryP,
        title: Image.asset("assets/images/logo.png", width: 140),
        automaticallyImplyLeading: false,
      ),
      backgroundColor: AppColor.backgroundP,
      body: Padding(
        padding: const EdgeInsets.only(bottom: 16, top: 16),
        child: _isLoading
            ? const Center(
                child: CircularProgressIndicator(color: AppColor.primaryP),
              )
            : Column(
                spacing: 16,
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: questions.isEmpty
                          ? Padding(
                            padding: const EdgeInsets.only(top: 32.0),
                            child: Center(
                                child: Text(
                                  "No hay preguntas en la encuesta.",
                                  style: TextStyles.titleProfesor,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                          )
                          : Column(
                              spacing: 16,
                              children: [
                                Text(
                                  widget.subject.name,
                                  style: TextStyles.titleProfesor,
                                ),
                                for (var i = 0; i < questions.length; i++)
                                  SurveyEditCard(
                                    // Usamos una Key para que Flutter reconstruya el widget si la pregunta cambia
                                    key: ValueKey(questions[i].id),
                                    question: questions[i],
                                    index: i + 1,
                                    onSaveChanges:
                                        _loadAvailableQuestions, // Pasamos la función de recarga
                                  ),
                              ],
                            ),
                    ),
                  ),
                  PrimaryButton(
                    text: "Agregar Pregunta",
                    onPressed: () async {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              AddQuestionScreen(subjectId: widget.subject.id),
                        ),
                      );
                      if (result == true) {
                        _loadAvailableQuestions();
                      }
                    },
                  ),
                ],
              ),
      ),
    );
  }
}
