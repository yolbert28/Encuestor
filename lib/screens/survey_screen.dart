import 'package:encuestor/components/primary_button.dart';
import 'package:encuestor/components/survey_question.dart';
import 'package:encuestor/core/app_color.dart';
import 'package:encuestor/core/text_style.dart';
import 'package:encuestor/data/answers_repository.dart';
import 'package:encuestor/data/question_repository.dart';
import 'package:encuestor/domain/subject.dart';
import 'package:encuestor/domain/question.dart';
import 'package:encuestor/screens/home_screen.dart';
import 'package:flutter/material.dart';

class SurveyScreen extends StatefulWidget {
  final String studentId;
  final Subject subject;
  const SurveyScreen({super.key, required this.subject, required this.studentId});

  @override
  State<SurveyScreen> createState() => _SurveyScreenState();
}


class _SurveyScreenState extends State<SurveyScreen> {
  final QuestionRepository _questionRepository = QuestionRepository();
  final AnswersRepository _answersRepository = AnswersRepository();
  var response = <String, String?>{};
  List<Question> _questions = [];

  int _currentPage = 0;
  final int _pageSize = 5;
  final ScrollController _scrollController = ScrollController();
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadAvailableQuestions();
  }

  void _loadAvailableQuestions() async {
    try {
      final questions = await _questionRepository.getQuestionsForSubject(
        widget.subject.id,
      );

      setState(() {
        _questions = questions;
        _isLoading = false;
      });
    } catch (e) {
      // Manejo de errores
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

  /// Verifica si todas las preguntas en la página actual tienen una respuesta.
  bool _areAllCurrentQuestionsAnswered(List<Question> currentQuestions) {
    // Usamos .every() para chequear que cada pregunta en la lista cumpla la condición.
    return currentQuestions.every((question) {
      // La condición es que la respuesta para el ID de esta pregunta no sea nula.
      return response[question.id] != null;
    });
  }

  void _showValidationError() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Por favor, responda todas las preguntas.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final int startIndex = _currentPage * _pageSize;
    final int endIndex = (startIndex + _pageSize > _questions.length)
        ? _questions.length
        : startIndex + _pageSize;
    final List<Question> currentSurveys = _questions.sublist(
      _questions.isEmpty ? 0 : startIndex,
      endIndex,
    );
    final bool isLastPage = (_currentPage + 1) * _pageSize >= _questions.length;

    return Scaffold(
      backgroundColor: AppColor.background,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppColor.primary,
        title: Image.asset("assets/images/logo.png", width: 140),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 16, bottom: 16),
        child: _isLoading
            ? const Center(child: CircularProgressIndicator(
              color: AppColor.primary,
            ))
            : _questions.isEmpty
            ? Center(
                child: Text(
                  "No hay preguntas en la encuesta.",
                  style: TextStyles.title,
                  textAlign: TextAlign.center,
                ),
              )
            : Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      controller: _scrollController,
                      child: Column(
                        children: [
                          SizedBox(height: 8),
                          Text(widget.subject.name, style: TextStyles.title),
                          SizedBox(height: 16),
                          for (var i = 0; i < currentSurveys.length; i++)
                            Padding(
                              padding: const EdgeInsets.only(bottom: 16.0),
                              child: SurveyQuestion(
                                key: Key(currentSurveys[i].id.toString()),
                                question: currentSurveys[i],
                                questionNumber: (i + 1).toString(),
                                onChanged: (t) {
                                  // No es necesario llamar a setState aquí,
                                  // solo actualizamos el mapa de respuestas.
                                  response[currentSurveys[i].id] = t;
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
                    onPressed: () async {
                      // --- INICIO DE LA VALIDACIÓN ---
                      if (!_areAllCurrentQuestionsAnswered(currentSurveys)) {
                        _showValidationError();
                        return; // Detiene la ejecución si no se han respondido todas.
                      }
                      // --- FIN DE LA VALIDACIÓN ---
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
                        // Filtramos las respuestas nulas antes de guardar.
                        final validResponses = Map<String, String>.fromEntries(
                            response.entries.where((e) => e.value != null).map(
                                (e) => MapEntry(e.key, e.value as String)));
                        try {
                          await _answersRepository.saveAnswers(validResponses, widget.subject.id, widget.studentId);
                        } catch (e) {
                          if (mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content: Text(
                                      'Error al guardar las respuestas: $e')),
                            );
                          }
                          return; // No continuar si hay un error
                        }
                        // Lógica para finalizar la encuesta
                        showDialog(
                          context: context,
                          barrierDismissible:
                              false, // El usuario debe presionar el botón
                          builder: (BuildContext context) {
                            return AlertDialog(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                              insetPadding: EdgeInsets.all(20),
                              actionsPadding: EdgeInsets.only(
                                bottom: 20,
                                top: 8,
                              ),
                              backgroundColor: AppColor.primary,
                              title: Text(
                                "Sus respuestas fueron enviadas con exito",
                                textAlign: TextAlign.center,
                                style: TextStyles.titleLight,
                              ),
                              content: Text(
                                "¡Gracias por completar la encuesta!",
                                style: TextStyles.body,
                              ),
                              actions: <Widget>[
                                PrimaryButton(
                                  text: "Aceptar",
                                  onPressed: () {
                                    Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(builder: (context) => HomeScreen(studentId: widget.studentId)),
                                      (Route<dynamic> route) => false,
                                    );
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
