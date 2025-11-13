import 'package:encuestor/core/app_color.dart';
import 'package:encuestor/core/text_style.dart';
import 'package:encuestor/data/enrolled_subjects_repository.dart';
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
          title: Text('Agregar Estudiante a la materia', style: TextStyles.subtitleProfesor,),
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
                final studentId = _studentIdController.text.trim();
                if (studentId.isNotEmpty) {
                  try {
                    await _repository.enrollStudent(
                        studentId, widget.subject.id);
                    _studentIdController.clear();
                    if (mounted) Navigator.of(context).pop();
                  } catch (e) {
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content: Text("Error al agregar: $e"),
                            backgroundColor: Colors.red),
                      );
                    }
                  }
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
          SizedBox(width: double.infinity, child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Text("Listado de estudiantes inscritos:", style: TextStyles.bodyProfesor, textAlign: TextAlign.start,),
          )),
          Expanded(
            child: StreamBuilder<List<String>>(
              stream: _repository.getEnrolledStudentIds(widget.subject.id),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                      child: CircularProgressIndicator(color: AppColor.primaryP));
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20, right: 20, bottom: 80),
                      child: Text(
                        'No hay estudiantes inscritos en esta materia.',
                        style: TextStyles.subtitleProfesor,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                }
            
                final studentIds = snapshot.data!;
            
                return ListView.builder(
                  padding: const EdgeInsets.only(top: 0, left: 16, right: 16, bottom: 16),
                  itemCount: studentIds.length,
                  itemBuilder: (context, index) {
                    final studentId = studentIds[index];
                    return Card(
                      child: ListTile(
                        leading: const Icon(Icons.person, color: AppColor.primaryP),
                        title: Text('C.I: $studentId', style: TextStyles.bodyProfesor),
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
