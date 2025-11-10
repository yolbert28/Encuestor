import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:encuestor/components/survey_card.dart';
import 'package:encuestor/core/app_color.dart';
import 'package:encuestor/core/text_style.dart';
import 'package:encuestor/data/service/students_service.dart';
import 'package:encuestor/data/service/subjects_service.dart';
import 'package:encuestor/screens/survey_screen.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  final String studentId;
  const HomeScreen({super.key, required this.studentId});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final StudentsService _studentsService = StudentsService();
  final SubjectsService _subjectsService = SubjectsService();

  bool _isLoading = true;
  List<QueryDocumentSnapshot> _availableSubjects = [];

  @override
  void initState() {
    super.initState();
    _loadAvailableSurveys();
  }

  void _loadAvailableSurveys() async {
    try {
      // 1. Obtener los datos del estudiante
      // Imprimimos el ID que estamos usando para la consulta
      print("HomeScreen: Buscando estudiante con ID: '${widget.studentId}'");
      final studentDoc = await _studentsService.getStudent(widget.studentId);

      final studentData = studentDoc.data() as Map<String, dynamic>;
      // print("sssss: " + studentDoc.toString());
      final List<dynamic> enrolledSubjects =
          studentData['enrolled_subjects'] ?? [];

      // 2. Filtrar para obtener solo los IDs de las materias no respondidas
      final List<String> subjectIdsToFetch = enrolledSubjects
          .where((subject) => subject['responded'] == false)
          .map((subject) => subject['subject_id'] as String)
          .toList();

      if (subjectIdsToFetch.isEmpty) {
        setState(() {
          _isLoading = false;
        });
        return;
      }

      // 3. Obtener los detalles de esas materias
      final subjectsSnapshot = await _subjectsService.getSubjectsByIds(
        subjectIdsToFetch,
      );

      setState(() {
        _availableSubjects = subjectsSnapshot.docs;
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
        padding: const EdgeInsets.only(
          top: 24,
          bottom: 16,
          left: 16,
          right: 16,
        ),
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _availableSubjects.isEmpty
            ? Center(
                child: Text(
                  "No tienes encuestas pendientes.",
                  style: TextStyles.title,
                  textAlign: TextAlign.center,
                ),
              )
            : SingleChildScrollView(
                child: Column(
                  children: [
                    Text("Encuestas disponibles", style: TextStyles.title),
                    const SizedBox(height: 16),
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _availableSubjects.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 16),
                      itemBuilder: (context, index) {
                        final subject = _availableSubjects[index];
                        final subjectData =
                            subject.data() as Map<String, dynamic>;
                        return SurveyCard(
                          title: subjectData['name'] ?? 'Sin nombre',
                          info: subjectData['info'] ?? 'Sin información',
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    SurveyScreen(subjectId: subject.id),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
