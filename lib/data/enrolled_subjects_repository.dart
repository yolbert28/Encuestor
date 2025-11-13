import 'package:encuestor/data/service/enrolled_subjects_service.dart';

class EnrolledSubjectsRepository {
  final _service = EnrolledSubjectsService();

  /// Obtiene un flujo de la lista de IDs de estudiantes para una materia.
  Stream<List<String>> getEnrolledStudentIds(String subjectId) {
    return _service.getEnrolledStudentsStream(subjectId).map((snapshot) {
      // Mapeamos los documentos a una lista de IDs de estudiantes.
      return snapshot.docs
          .map((doc) => doc.get('student_id') as String)
          .toList();
    });
  }

  /// Llama al servicio para inscribir a un estudiante.
  Future<void> enrollStudent(String studentId, String subjectId) {
    return _service.enrollStudent(studentId, subjectId);
  }
}
