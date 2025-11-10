import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:encuestor/domain/student.dart';

class StudentsService {
  // Renombrado a StudentsService para reflejar mejor su propósito.
  // Tipado fuerte para la colección usando el conversor.
  final CollectionReference<Student> _studentsCollection = FirebaseFirestore
      .instance
      .collection('students')
      .withConverter<Student>(
        fromFirestore: Student.fromFireStore,
        toFirestore: (Student student, _) => student.toFirestore(),
      );

  // Obtiene un estudiante por su ID (cédula)
  // Devuelve un DocumentSnapshot<Student> para mayor seguridad de tipos.
  Future<DocumentSnapshot<Student>> getStudent(String studentId) {
    return _studentsCollection.doc(studentId).get();
  }

  // Actualiza el estado de las encuestas de un estudiante
  Future<void> updateStudent(String studentId, Map<String, dynamic> data) {
    return _studentsCollection.doc(studentId).update(data);
  }
}