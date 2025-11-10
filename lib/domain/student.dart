import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:encuestor/domain/student_subject.dart';

class Student {
  final String id;
  final List<StudentSubject> enrolledSubjects;

  Student({required this.id, required this.enrolledSubjects});

  // Factory para crear un Student desde un DocumentSnapshot de Firestore
  factory Student.fromFireStore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    // Aquí está la magia:
    // 1. Obtenemos la lista 'enrolled_subjects' o una lista vacía si no existe.
    // 2. La convertimos a una lista de dynamic.
    // 3. Usamos .map() para transformar cada item del mapa en un objeto StudentSubject.
    final subjectsList = (data?['enrolled_subjects'] as List<dynamic>? ?? [])
        .map((subjectData) =>
            StudentSubject.fromMap(subjectData as Map<String, dynamic>))
        .toList();

    return Student(id: snapshot.id, enrolledSubjects: subjectsList);
  }

  // Método para convertir un Student a un Map para Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'enrolled_subjects': enrolledSubjects.map((s) => s.toMap()).toList(),
    };
  }
}