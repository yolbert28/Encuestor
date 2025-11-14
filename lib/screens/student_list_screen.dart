import 'package:encuestor/core/app_color.dart';
import 'package:encuestor/core/text_style.dart';
import 'package:encuestor/data/enrolled_subjects_repository.dart';
import 'package:encuestor/domain/student_subject.dart';
import 'package:encuestor/domain/subject.dart';
import 'package:flutter/material.dart';

class StudentListScreen extends StatefulWidget {
  final Subject subject;
  const StudentListScreen({super.key, required this.subject});

  @override
  State<StudentListScreen> createState() => _StudentListScreenState();
}

class _StudentListScreenState extends State<StudentListScreen> {
  final _repository = EnrolledSubjectsRepository();
  final _studentIdController = TextEditingController();

  Future<void> _showAddStudentDialog() async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Agregar Estudiante a la materia',
            style: TextStyles.subtitleProfesor,
          ),
          content: TextField(
            controller: _studentIdController,
            decoration: const InputDecoration(
              hintText: "Ingrese la cédula del estudiante",
            ),
            keyboardType: TextInputType.number,
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Agregar'),
              onPressed: () async {
                // Guardamos el navigator y el messenger ANTES del await.
                final navigator = Navigator.of(context);
                final messenger = ScaffoldMessenger.of(context);

                final studentId = _studentIdController.text.trim();
                if (studentId.isEmpty) {
                  messenger.showSnackBar(
                    const SnackBar(
                      content: Text("Por favor, ingrese la cédula."),
                      backgroundColor: Colors.red,
                    ),
                  );
                  return;
                }
                if (studentId.length < 7 || studentId.length > 8) {
                  messenger.showSnackBar(
                    const SnackBar(
                      content: Text(
                        "La cédula debe tener entre 7 y 8 dígitos.",
                      ),
                      backgroundColor: Colors.red,
                    ),
                  );
                  return;
                }
                try {
                  await _repository.enrollStudent(studentId, widget.subject.id);
                  _studentIdController.clear();
                  navigator.pop(); // Usamos la variable guardada.
                } catch (e) {
                  // No es necesario 'mounted' aquí porque el messenger se muestra en el contexto de la pantalla principal.
                  messenger.showSnackBar(
                    SnackBar(
                      content: Text("Error al agregar: $e"),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
            ),
          ],
        );
      },
    );
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
      body: Column(
        children: [
          SizedBox(height: 16),
          Text(widget.subject.name, style: TextStyles.titleProfesor),
          SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Text(
                "Listado de estudiantes inscritos:",
                style: TextStyles.bodyProfesor,
                textAlign: TextAlign.start,
              ),
            ),
          ),
          Expanded(
            child: StreamBuilder<List<StudentSubject>>(
              stream: _repository.getEnrolledStudents(widget.subject.id),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(color: AppColor.primaryP),
                  );
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.only(
                        left: 20,
                        right: 20,
                        bottom: 80,
                      ),
                      child: Text(
                        'No hay estudiantes inscritos en esta materia.',
                        style: TextStyles.subtitleProfesor,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                }

                final enrolledStudents = snapshot.data!;

                return ListView.builder(
                  padding: const EdgeInsets.only(
                    top: 0,
                    left: 16,
                    right: 16,
                    bottom: 16,
                  ),
                  itemCount: enrolledStudents.length,
                  itemBuilder: (context, index) {
                    final enrolled = enrolledStudents[index];
                    return Dismissible(
                      key: Key(enrolled.id),
                      direction: DismissDirection.endToStart,
                      background: Container(
                        color: AppColor.red,
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: const Icon(Icons.delete, color: Colors.white),
                      ),
                      confirmDismiss: (direction) async {
                        if (enrolled.responded) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'No se puede eliminar un estudiante que ya respondió la encuesta.',
                              ),
                              backgroundColor: AppColor.textDarkProfesor,
                            ),
                          );
                          return false;
                        }
                        return await showDialog(
                          context: context,
                          builder: (BuildContext dialogContext) {
                            return AlertDialog(
                              title: const Text("Confirmar"),
                              content: Text(
                                "¿Estás seguro de que deseas eliminar al estudiante con C.I: ${enrolled.studentId}?",
                              ),
                              actions: <Widget>[
                                TextButton(
                                  // Usamos el contexto del diálogo para cerrarlo.
                                  onPressed: () =>
                                      Navigator.of(dialogContext).pop(false),
                                  child: const Text("CANCELAR"),
                                ),
                                TextButton(
                                  onPressed: () =>
                                      Navigator.of(dialogContext).pop(true),
                                  child: const Text("ELIMINAR"),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      onDismissed: (direction) async {
                        // Guardamos el messenger ANTES del await.
                        final messenger = ScaffoldMessenger.of(context);
                        await _repository.unenrollStudent(enrolled.id);
                        messenger.showSnackBar(
                          SnackBar(
                            content: Text(
                              'Estudiante C.I: ${enrolled.studentId} eliminado.',
                            ),
                          ),
                        );
                      },
                      child: Card(
                        child: ListTile(
                          leading: const Icon(
                            Icons.person,
                            color: AppColor.primaryP,
                          ),
                          title: Text(
                            'C.I: ${enrolled.studentId}',
                            style: TextStyles.bodyProfesor,
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddStudentDialog,
        backgroundColor: AppColor.primaryP,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
