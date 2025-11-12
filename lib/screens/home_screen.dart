import 'package:encuestor/components/survey_card.dart';
import 'package:encuestor/core/app_color.dart';
import 'package:encuestor/core/text_style.dart';
import 'package:encuestor/data/students_repository.dart';
import 'package:encuestor/domain/subject.dart';
import 'package:encuestor/screens/survey_screen.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  final String studentId;
  const HomeScreen({super.key, required this.studentId});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final StudentsRepository _studentsRepository = StudentsRepository();

  bool _isLoading = true;
  List<Subject> _availableSubjects = [];

  @override
  void initState() {
    super.initState();
    _loadAvailableSurveys();
  }

  void _loadAvailableSurveys() async {
    try {
      final surveys = await _studentsRepository.getSubjectsForStudent(
        widget.studentId,
      );

      setState(() {
        _availableSubjects = surveys;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.primary,
        title: Image.asset("assets/images/logo.png", width: 140),
        automaticallyImplyLeading: false,
      ),
      backgroundColor: AppColor.background,
      body: Padding(
        padding: const EdgeInsets.only(top: 24, bottom: 16),
        child: _isLoading
            ? const Center(
                child: CircularProgressIndicator(color: AppColor.primary),
              )
            : _availableSubjects.isEmpty
            ? Center(
                child: Text(
                  "No tienes encuestas pendientes.",
                  style: TextStyles.title,
                  textAlign: TextAlign.center,
                ),
              )
            : Column(
                children: [
                  Text("Encuestas disponibles", style: TextStyles.title),
                  const SizedBox(height: 16),
                  Expanded(
                    // <-- Widget clave añadido
                    child: ListView.separated(
                      itemCount: _availableSubjects.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 8),
                      itemBuilder: (context, index) {
                        final subject = _availableSubjects[index];
                        return SurveyCard(
                          title: subject.name,
                          info: subject.info,
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    SurveyScreen(studentId: widget.studentId, subject: subject),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
