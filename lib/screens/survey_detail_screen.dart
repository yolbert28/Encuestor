import 'package:encuestor/components/primary_button.dart';
import 'package:encuestor/components/secondary_button.dart';
import 'package:encuestor/components/survey_edit_card.dart';
import 'package:encuestor/core/app_color.dart';
import 'package:encuestor/core/text_style.dart';
import 'package:encuestor/data/answers_repository.dart';
import 'package:encuestor/data/enrolled_subjects_repository.dart';
import 'package:encuestor/data/professor_repository.dart';
import 'package:encuestor/data/question_repository.dart';
import 'package:encuestor/screens/add_question_screen.dart';
import 'package:encuestor/domain/answer.dart';
import 'package:encuestor/domain/professor.dart';
import 'package:encuestor/domain/question.dart';
import 'package:encuestor/screens/student_list_screen.dart';
import 'package:encuestor/domain/subject.dart';
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';

class SurveyDetailScreen extends StatefulWidget {
  final Subject subject;
  const SurveyDetailScreen({super.key, required this.subject});

  @override
  State<SurveyDetailScreen> createState() => _SurveyDetailScreenState();
}

class _SurveyDetailScreenState extends State<SurveyDetailScreen> {
  final _questionRepository = QuestionRepository();
  final _answersRepository = AnswersRepository();
  final _professorRepository = ProfessorRepository();
  final _enrolledSubjectsRepository = EnrolledSubjectsRepository();

  List<Question> questions = [];
  bool _isLoading = true;
  bool _isGeneratingPdf = false;

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

  Future<void> _handleDeleteQuestion(
    String questionId,
    String questionText,
  ) async {
    final bool? confirm = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar Eliminación'),
        content: Text(
          '¿Estás seguro de que deseas eliminar la pregunta: "$questionText"?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Eliminar', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      final messenger = ScaffoldMessenger.of(context);
      try {
        await _questionRepository.deleteQuestion(questionId);
        messenger.showSnackBar(
          const SnackBar(
            content: Text('Pregunta eliminada con éxito.'),
            backgroundColor: Colors.green,
          ),
        );
        _loadAvailableQuestions(); // Recargar la lista
      } catch (e) {
        messenger.showSnackBar(
          SnackBar(
            content: Text('Error al eliminar la pregunta: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _generatePdf() async {
    setState(() {
      _isGeneratingPdf = true;
    });

    try {
      // 1. Obtener datos necesarios
      final Professor? professor = await _professorRepository.getProfessor(
        widget.subject.professorId,
      );
      final List<Answer> answers = await _answersRepository
          .getAnswersForSubject(widget.subject.id);
      final enrolledStudents = await _enrolledSubjectsRepository
          .getEnrolledStudentsList(widget.subject.id);

      // Calcular total de inscritos y respondidos
      final totalEnrolled = enrolledStudents.length;
      final totalResponded = enrolledStudents.where((s) => s.responded).length;

      // 2. Procesar respuestas para obtener conteos
      final Map<String, int> voteCounts = {};
      for (var answer in answers) {
        voteCounts.update(
          answer.selectedOptionId,
          (value) => value + 1,
          ifAbsent: () => 1,
        );
      }

      // 3. Crear el documento PDF
      final pdf = pw.Document();
      final font = await PdfGoogleFonts.robotoRegular();
      final boldFont = await PdfGoogleFonts.robotoBold();

      pdf.addPage(
        pw.MultiPage(
          pageFormat: PdfPageFormat.a4,
          build: (pw.Context context) {
            return [
              // Encabezado
              pw.Header(
                level: 0,
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      widget.subject.name,
                      style: pw.TextStyle(font: boldFont, fontSize: 24),
                    ),
                    pw.SizedBox(height: 8),
                    pw.Text(
                      'Profesor: ${professor?.name ?? 'No disponible'}',
                      style: pw.TextStyle(font: font, fontSize: 14),
                    ),
                    pw.SizedBox(height: 12),
                    pw.Text(
                      'Participación: $totalResponded de $totalEnrolled estudiantes respondieron la encuesta.',
                      style: pw.TextStyle(
                        font: font,
                        fontSize: 12,
                        color: PdfColors.grey800,
                      ),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.symmetric(vertical: 16),
                      child: pw.Divider(thickness: 2),
                    ),
                  ],
                ),
              ),

              // Contenido de preguntas y respuestas
              pw.ListView.builder(
                itemCount: questions.length,
                itemBuilder: (context, index) {
                  final question = questions[index];
                  return pw.Container(
                    margin: const pw.EdgeInsets.only(bottom: 20),
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text(
                          '${index + 1}. ${question.question}',
                          style: pw.TextStyle(font: boldFont, fontSize: 16),
                        ),
                        pw.SizedBox(height: 10),
                        pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: () {
                            // Lógica para encontrar la primera y segunda opción más votada
                            int totalVotesForQuestion = 0;
                            for (var opt in question.options) {
                              totalVotesForQuestion += voteCounts[opt.id] ?? 0;
                            }

                            var sortedOptions = question.options.map((opt) {
                              return MapEntry(opt, voteCounts[opt.id] ?? 0);
                            }).toList();

                            sortedOptions.sort(
                              (a, b) => b.value.compareTo(a.value),
                            );

                            final maxVotes = sortedOptions.isNotEmpty
                                ? sortedOptions.first.value
                                : 0;
                            final secondMaxVotes = sortedOptions.length > 1
                                ? sortedOptions[1].value
                                : -1;

                            // No hay segundo lugar si hay empate en el primero o si no hay votos
                            final hasSecondPlace =
                                maxVotes > 0 &&
                                secondMaxVotes > 0 &&
                                maxVotes > secondMaxVotes;

                            return question.options.map((option) {
                              final count = voteCounts[option.id] ?? 0;
                              final percentage = totalVotesForQuestion > 0
                                  ? (count / totalVotesForQuestion) * 100
                                  : 0.0;

                              PdfColor? highlightColor;

                              if (count > 0 && count == maxVotes) {
                                highlightColor =
                                    PdfColors.green100; // Más votada
                              } else if (hasSecondPlace &&
                                  count == secondMaxVotes &&
                                  question.options.length > 2) {
                                highlightColor =
                                    PdfColors.amber100; // Segunda más votada
                              }

                              return pw.Container(
                                color: highlightColor,
                                padding: const pw.EdgeInsets.symmetric(
                                  vertical: 4,
                                  horizontal: 8,
                                ),
                                margin: const pw.EdgeInsets.only(bottom: 2),
                                child: pw.Row(
                                  children: [
                                    pw.Expanded(
                                      child: pw.Text(
                                        '- ${option.text}',
                                        style: pw.TextStyle(
                                          font: font,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                    pw.Container(
                                      width: 60,
                                      alignment: pw.Alignment.centerRight,
                                      child: pw.Text(
                                        '${percentage.toStringAsFixed(1)}%',
                                        style: pw.TextStyle(
                                          font: font,
                                          fontSize: 12,
                                          color: PdfColors.grey700,
                                        ),
                                      ),
                                    ),
                                    pw.Container(
                                      width: 70,
                                      alignment: pw.Alignment.centerRight,
                                      child: pw.Text(
                                        '$count voto(s)',
                                        style: pw.TextStyle(
                                          font: boldFont,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }).toList();
                          }(),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ];
          },
        ),
      );

      // 4. Guardar y abrir el archivo
      final output = await getTemporaryDirectory();
      final file = File(
        "${output.path}/reporte_${widget.subject.name.replaceAll(' ', '_')}.pdf",
      );
      await file.writeAsBytes(await pdf.save());

      OpenFile.open(file.path);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al generar el PDF: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isGeneratingPdf = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Verificamos si el teclado está visible. viewInsets.bottom será > 0 si lo está.
    final isKeyboardVisible = MediaQuery.of(context).viewInsets.bottom > 0;
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
                  Text(widget.subject.name, style: TextStyles.titleProfesor),
                  Expanded(
                    child: SingleChildScrollView(
                      child: questions.isEmpty
                          ? Padding(
                              padding: const EdgeInsets.only(top: 32.0),
                              child: Center(
                                child: Text(
                                  "No hay preguntas en la encuesta.",
                                  style: TextStyles.subtitleProfesor,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            )
                          : Column(
                              spacing: 16,
                              children: [
                                for (var i = 0; i < questions.length; i++)
                                  SurveyEditCard(
                                    // Usamos una Key para que Flutter reconstruya el widget si la pregunta cambia
                                    key: ValueKey(questions[i].id),
                                    question: questions[i],
                                    index: i + 1,
                                    onSaveChanges: _loadAvailableQuestions,
                                    onDelete: () => _handleDeleteQuestion(
                                      questions[i].id,
                                      questions[i].question,
                                    ),
                                  ),
                              ],
                            ),
                    ),
                  ),
                  if (_isGeneratingPdf)
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: CircularProgressIndicator(
                        color: AppColor.primaryP,
                      ),
                    ),
                  // Solo mostramos los botones si el teclado NO está visible.
                  if (!isKeyboardVisible) ...[
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          spacing: 12,
                          children: [
                            SecondaryButton(
                              text: "Ver listado de estudiantes",
                              width: (MediaQuery.of(context).size.width * 0.66),
                              horizontalPadding: 0,
                              height: 60,
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => StudentListScreen(
                                      subject: widget.subject,
                                    ),
                                  ),
                                );
                              },
                            ),
                            PrimaryButton(
                              width: (MediaQuery.of(context).size.width * 0.18),
                              horizontalPadding: 0,
                              height: 60,
                              onPressed: _isGeneratingPdf ? () {} : _generatePdf,
                              innerPadding: EdgeInsets.all(0),
                              onlyIcon: true,
                              child: Icon(Icons.print_rounded, size: 25, color: AppColor.backgroundP,),
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
                ],
              ),
      ),
    );
  }
}
