import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:encuestor/domain/student_subject.dart';

class StudentsService {
  // Renombrado a StudentsService para reflejar mejor su propósito.
  // Tipado fuerte para la colección usando el conversor.
  final CollectionReference<StudentSubject> _studentSubjectsCollection =
      FirebaseFirestore.instance
          .collection('enrolled_subjects')
          .withConverter(
            fromFirestore: StudentSubject.fromFireStore,
            toFirestore: (StudentSubject studentSubject, _) =>
                studentSubject.toFirestore(),
          );

  // Obtiene un estudiante por su ID (cédula)
  // Devuelve un DocumentSnapshot<Student> para mayor seguridad de tipos.
  Future<QuerySnapshot<StudentSubject>> getStudent(String studentId) {
    return _studentSubjectsCollection
        .where("student_id", isEqualTo: studentId).limit(1)
        .get();
  }

  Future<QuerySnapshot<StudentSubject>> getSubjectsForStudentStream(
    String studentId,
  ) {
    return _studentSubjectsCollection
        .where("student_id", isEqualTo: studentId)
        .where('responded', isEqualTo: false)
        .get();
  }

  // Actualiza el estado de las encuestas de un estudiante
  // Future<void> updateStudent(String studentId, Map<String, dynamic> data) {
  //   return _studentSubjectsCollection.doc(studentId).update(data);
  // }
}
