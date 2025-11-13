import 'package:encuestor/data/service/answers_service.dart';
import 'package:encuestor/domain/answer.dart';

class AnswersRepository {
  final _service = AnswersService();

  /// Guarda las respuestas de una encuesta.
  ///
  /// Transforma el mapa de respuestas de la UI a una lista de mapas
  /// con el formato esperado por Firestore y lo envía al servicio.
  Future<void> saveAnswers(
      Map<String, String> responses, String subjectId, String studentId) async {

    // 2. Convertimos cada respuesta al formato de la base de datos.
    final List<Answer> answersToSave = responses.entries.map((entry) {
      return Answer(
        id: "",
        questionId: entry.key,          // El ID de la pregunta
        selectedOptionId: entry.value, // El ID de la opción seleccionada
        subjectId: subjectId,           // El ID de la asignatura
    );
    }).toList();

    // 3. Llamamos al servicio para guardar los datos en un batch.
    await _service.saveAnswers(answersToSave, subjectId, studentId);
  }

  /// Obtiene todas las respuestas para una asignatura específica.
  Future<List<Answer>> getAnswersForSubject(String subjectId) async {
    final snapshot = await _service.getAnswersForSubject(subjectId);
    return snapshot.docs.map((doc) => doc.data()).toList();
  }
}
