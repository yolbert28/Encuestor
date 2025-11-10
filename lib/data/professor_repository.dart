import 'package:encuestor/data/service/professors_service.dart';
import 'package:encuestor/domain/professor.dart';

class ProfessorRepository {

  final service = ProfessorsService();

  Future<Professor?> getProfessor(String professorId) async {
    final professorDoc = await service.getProfessor(professorId);

    if (professorDoc.exists) {
      return professorDoc.data();
    }
    return null;
  }

}