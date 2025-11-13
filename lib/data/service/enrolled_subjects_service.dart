import 'package:cloud_firestore/cloud_firestore.dart';

class EnrolledSubjectsService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late final CollectionReference _enrolledSubjectsCollection =
      _firestore.collection('enrolled_subjects');

  /// Obtiene un stream de los documentos de estudiantes inscritos en una materia.
  Stream<QuerySnapshot> getEnrolledStudentsStream(String subjectId) {
    return _enrolledSubjectsCollection
        .where('subject_id', isEqualTo: subjectId)
        .snapshots();
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
}
