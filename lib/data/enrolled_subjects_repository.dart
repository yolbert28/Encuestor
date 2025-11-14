import 'package:encuestor/data/service/enrolled_subjects_service.dart';
import 'package:encuestor/domain/student_subject.dart';

class EnrolledSubjectsRepository {
  final _service = EnrolledSubjectsService();

  //// Obtiene un flujo de la lista de estudiantes inscritos en una materia.
  Stream<List<StudentSubject>> getEnrolledStudents(String subjectId) {
    return _service.getEnrolledStudentsStream(subjectId).map((snapshot) {
      // Mapeamos los documentos a una lista de objetos StudentSubject.
      return snapshot.docs.map((doc) => doc.data()).toList();
    });
  }

  /// Obtiene una lista futura de estudiantes inscritos en una materia.
  Future<List<StudentSubject>> getEnrolledStudentsList(String subjectId) async {
    final snapshot = await _service.getEnrolledStudentsFuture(subjectId);
    return snapshot.docs.map((doc) => doc.data()).toList();
  }

  /// Llama al servicio para inscribir a un estudiante.
  Future<void> enrollStudent(String studentId, String subjectId) {
    return _service.enrollStudent(studentId, subjectId);
  }

  /// Llama al servicio para eliminar la inscripción de un estudiante.
  Future<void> unenrollStudent(String enrollmentId) {
    return _service.unenrollStudent(enrollmentId);
  }

  /// Verifica si un estudiante ya está inscrito en una materia.
  Future<bool> isStudentEnrolled(String studentId, String subjectId) async {
    return await _service.isStudentEnrolled(studentId, subjectId);
  }
}
