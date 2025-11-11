import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:encuestor/domain/student_subject.dart';

class StudentsService {
  // Renombrado a StudentsService para reflejar mejor su propósito.
  // Tipado fuerte para la colección usando el conversor.
  final CollectionReference _studentsCollection = FirebaseFirestore.instance
      .collection('students');

  // Obtiene un estudiante por su ID (cédula)
  // Devuelve un DocumentSnapshot<Student> para mayor seguridad de tipos.
  Future<DocumentSnapshot> getStudent(String studentId) {
    return _studentsCollection.doc(studentId).get();
  }

  Future<QuerySnapshot<StudentSubject>> getSubjectsForStudentStream(
    String studentId,
  ) {
    return _studentsCollection
        .doc(studentId)
        .collection("enrolled_subjects")
        .withConverter(
          fromFirestore: StudentSubject.fromFireStore, 
          toFirestore: (StudentSubject studentSubject, _) => studentSubject.toFirestore()
          )
        .where('responded', isEqualTo: false)
        .get();
  }

  // Actualiza el estado de las encuestas de un estudiante
  Future<void> updateStudent(String studentId, Map<String, dynamic> data) {
    return _studentsCollection.doc(studentId).update(data);
  }
}
