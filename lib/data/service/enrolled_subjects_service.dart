import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:encuestor/domain/student_subject.dart';

class EnrolledSubjectsService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late final CollectionReference _enrolledSubjectsCollection = _firestore
      .collection('enrolled_subjects');

  /// Obtiene un stream de los documentos de estudiantes inscritos en una materia.
  Stream<QuerySnapshot<StudentSubject>> getEnrolledStudentsStream(String subjectId) {
    return _enrolledSubjectsCollection
        .withConverter(
          fromFirestore: StudentSubject.fromFireStore,
          toFirestore: (StudentSubject studentSubject, _) =>
              studentSubject.toFirestore(),
        )
        .where('subject_id', isEqualTo: subjectId)
        .snapshots();
  }

  /// Obtiene una única lista de los documentos de estudiantes inscritos en una materia.
  Future<QuerySnapshot<StudentSubject>> getEnrolledStudentsFuture(String subjectId) {
    return _enrolledSubjectsCollection
        .withConverter(
          fromFirestore: StudentSubject.fromFireStore,
          toFirestore: (StudentSubject studentSubject, _) =>
              studentSubject.toFirestore(),
        )
        .where('subject_id', isEqualTo: subjectId)
        .get();
  }

  /// Inscribe a un nuevo estudiante en una materia.
  Future<void> enrollStudent(String studentId, String subjectId) async {
    // Creamos un mapa con los datos del nuevo documento.
    final newEnrollment = {
      'student_id': studentId,
      'subject_id': subjectId,
      'responded': false,
    };

    // Añadimos el documento a la colección. Firestore generará el ID del documento.
    await _enrolledSubjectsCollection.add(newEnrollment);
  }

  /// Elimina la inscripción de un estudiante de una materia usando su ID de documento.
  Future<void> unenrollStudent(String enrollmentId) async {
    await _enrolledSubjectsCollection.doc(enrollmentId).delete();
  }

  Future<bool> isStudentEnrolled(String studentId, String subjectId) async {
    final query = _enrolledSubjectsCollection
        .where('student_id', isEqualTo: studentId)
        .where('subject_id', isEqualTo: subjectId)
        .limit(1);

    final snapshot = await query.get();
    return snapshot.docs.isNotEmpty;
  }
}
