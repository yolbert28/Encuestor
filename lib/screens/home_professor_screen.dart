import 'package:encuestor/components/primary_button.dart';
import 'package:encuestor/components/survey_card.dart';
import 'package:encuestor/core/app_color.dart';
import 'package:encuestor/core/text_style.dart';
import 'package:encuestor/domain/subject.dart';
import 'package:encuestor/data/subject_repository.dart';
import 'package:encuestor/screens/add_subject_screen.dart';
import 'package:encuestor/screens/survey_detail_screen.dart';
import 'package:flutter/material.dart';

class HomeProfesorScreen extends StatefulWidget {
  final String professorId;

  const HomeProfesorScreen({super.key, required this.professorId});

  @override
  State<HomeProfesorScreen> createState() => _HomeProfessorScreenState();
}

class _HomeProfessorScreenState extends State<HomeProfesorScreen> {
  final SubjectRepository _subjectRepository = SubjectRepository();

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
        child: Column(
          spacing: 16,
          children: [
            Text("Mis Asignaturas", style: TextStyles.titleProfesor),
            Expanded(
              child: StreamBuilder<List<Subject>>(
                // 1. Usamos el método del repositorio para obtener el stream de asignaturas.
                stream: _subjectRepository.getSubjectsForProfessor(
                  widget.professorId,
                ),
                builder: (context, snapshot) {
                  // 2. Mientras esperamos los datos, mostramos un indicador de carga.
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(color: AppColor.primary),
                    );
                  }
                  // 3. Si ocurre un error, lo mostramos.
                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }
                  // 4. Si no hay datos o la lista está vacía, mostramos un mensaje.
                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(
                      child: Text('No tienes asignaturas asignadas.'),
                    );
                  }

                  // 5. Si tenemos datos, los guardamos en una variable.
                  final subjects = snapshot.data!;

                  // 6. Usamos ListView.builder para construir la lista dinámicamente.
                  return ListView.separated(
                    itemCount: subjects.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 8),
                    itemBuilder: (context, index) {
                      final subject = subjects[index];
                      return SurveyCard(
                        title: subject.name,
                        info: subject.info,
                        color: subject.color,
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              // TODO: Pasa el ID de la asignatura a la pantalla de detalles.
                              builder: (context) => SurveyDetailScreen(subject: subject,),
                            ),
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ),
            PrimaryButton(
              text: "Agregar",
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        AddSubjectScreen(professorId: widget.professorId),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
