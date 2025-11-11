import 'package:encuestor/data/service/students_service.dart';
import 'package:encuestor/data/service/subjects_service.dart';
import 'package:encuestor/domain/student_subject.dart';
import 'package:encuestor/domain/subject.dart';

class StudentsRepository {
  final service = StudentsService();
  final subjectsService = SubjectsService();

  // El tipo de retorno ahora es Future<Student?> para manejar el caso donde el estudiante no existe.
  Future<bool> studentExists(String studentId) async {
    final studentDoc = await service.getStudent(studentId);

    return studentDoc.exists;
  }

  Future<List<Subject>> getSubjectsForStudent(String studentId) async {
    
    final subjectsId = await service.getSubjectsForStudentStream(studentId);

    final subjects = await subjectsService.getSubjectsByIds(subjectsId.docs.map((doc) => doc.id).toList());

    final result = subjects.docs.map((doc) => doc.data()).toList();

    return result;
  }
}
