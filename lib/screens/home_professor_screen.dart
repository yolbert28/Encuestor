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

  Future<void> _showEditSubjectDialog(BuildContext context, Subject subject) async {
    final nameController = TextEditingController(text: subject.name);
    final infoController = TextEditingController(text: subject.info);
    final formKey = GlobalKey<FormState>();

    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Editar Asignatura'),
          insetPadding: const EdgeInsets.all(16), // Un padding razonable para que no pegue a los bordes
          contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20), // Padding interno
          content: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: SizedBox(
                width: MediaQuery.of(context).size.width, // Ocupa el ancho disponible
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      controller: nameController,
                      decoration: const InputDecoration(labelText: 'Nombre de la asignatura'),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Por favor, ingrese un nombre';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: infoController,
                      decoration: const InputDecoration(labelText: 'Información (Carrera)'),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Por favor, ingrese la información';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text('Guardar'),
              onPressed: () async {
                if (formKey.currentState!.validate()) {
                  // Guardamos el navigator antes del await
                  final navigator = Navigator.of(context);
                  await _subjectRepository.updateSubject(subjectId: subject.id, name: nameController.text, info: infoController.text);
                  // No necesitamos 'mounted' check aquí porque el contexto del diálogo
                  // es el que importa, y si el usuario no lo ha cerrado, es válido.
                  // Usamos el navigator que guardamos.
                  navigator.pop();
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
                    return Center(
                      child: Text('No tienes asignaturas.', style: TextStyles.subtitleProfesor,),
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
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Dismissible(
                          key: Key(subject.id),
                          direction: DismissDirection.horizontal,
                          background: Container(
                            color: AppColor.primaryP,
                            alignment: Alignment.centerLeft,
                            padding: const EdgeInsets.symmetric(horizontal: 20.0),
                            child: const Icon(Icons.edit, color: Colors.white),
                          ),
                          secondaryBackground: Container(
                            color: AppColor.red,
                            alignment: Alignment.centerRight,
                            padding: const EdgeInsets.symmetric(horizontal: 20.0),
                            child: const Icon(Icons.delete, color: Colors.white),
                          ),
                          confirmDismiss: (direction) async {
                            if (direction == DismissDirection.startToEnd) { // Swipe a la derecha (editar)
                              await _showEditSubjectDialog(context, subject);
                              return false; // No elimina el elemento de la lista
                            } else { // Swipe a la izquierda (eliminar)
                              return await showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    insetPadding: const EdgeInsets.all(16),
                                    title: const Text("Confirmar"),
                                    content: const Text(
                                        "¿Estás seguro de que deseas eliminar esta asignatura? Se borrarán todos los datos asociados (preguntas, estudiantes, respuestas)."),
                                    actions: <Widget>[
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.of(context).pop(false),
                                        child: const Text("CANCELAR"),
                                      ),
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.of(context).pop(true),
                                        child: const Text("ELIMINAR"),
                                      ),
                                    ],
                                  );
                                },
                              );
                            }
                          },
                          onDismissed: (direction) async {
                            // Guardamos el ScaffoldMessenger antes del await
                            final messenger = ScaffoldMessenger.of(context);
                            try {
                              await _subjectRepository.deleteSubject(subject.id);
                              messenger.showSnackBar(
                                SnackBar(
                                    content: Text(
                                        'Asignatura "${subject.name}" eliminada.')),
                              );
                            } catch (e) {
                              messenger.showSnackBar(
                                SnackBar(
                                    content: Text(
                                        "Error al eliminar la asignatura: $e")),
                              );
                            }
                          },
                          child: SurveyCard(
                            title: subject.name,
                            info: subject.info,
                            color: subject.color,
                            horizontalPadding: 0,
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      SurveyDetailScreen(subject: subject),
                                ),
                              );
                            },
                          ),
                        ),
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
