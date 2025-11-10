import 'package:encuestor/data/service/students_service.dart';
import 'package:encuestor/domain/student.dart';
import 'package:encuestor/domain/student_subject.dart';

class StudentsRepository {

  final service = StudentsService();

  // El tipo de retorno ahora es Future<Student?> para manejar el caso donde el estudiante no existe.
  Future<Student?> getStudent(String studentId) async {
    final studentDoc = await service.getStudent(studentId);

    if (studentDoc.exists) {
      // .data() ya devuelve un objeto Student gracias al conversor, no se necesita 'as Student'.
      return studentDoc.data();
    }
    // Si el documento no existe, retornamos null.
    return null;
  }

  // Nuevo método para obtener directamente la lista de materias de un estudiante.
  Future<List<StudentSubject>> getStudentSubjects(String studentId) async {
    // Reutilizamos el método que ya teníamos.
    final student = await getStudent(studentId);

    // Si el estudiante existe, devolvemos su lista de materias.
    // Si no existe (o no tiene materias), devolvemos una lista vacía.
    return student?.enrolledSubjects ?? [];
  }

}
