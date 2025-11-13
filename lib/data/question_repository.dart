import 'package:encuestor/data/service/questions_service.dart';
import 'package:encuestor/domain/question.dart';
import 'package:encuestor/domain/question_option.dart';
import 'package:uuid/uuid.dart';

class QuestionRepository {
  final service = QuestionsService();
  final _uuid = Uuid();

  Future<List<Question>> getQuestionsForSubject(String subjectId) async {
    final questionsSnapshot = await service.getQuestionsForSubject(subjectId);

    final result = questionsSnapshot.docs.map((doc) => doc.data()).toList();

    List<Question> questions = [];

    for (var question in result) {
      final optionsSnapshot = await service.getOptionsForQuestion(question.id);
      question.options = optionsSnapshot.docs.map((doc) => doc.data()).toList();
      questions.add(question);
    }

    return questions;
  }

  /// Añade una nueva pregunta con sus opciones a una asignatura.
  Future<void> addQuestion(
    String questionText,
    List<String> optionTexts,
    String subjectId,
  ) async {
    // 1. Genera un ID único para la nueva pregunta.
    final newQuestionId = _uuid.v4();

    // 2. Crea el objeto Question.
    final newQuestion = Question(
      id: newQuestionId,
      question: questionText,
      subjectId: subjectId,
      options: [], // Las opciones se guardarán en una subcolección.
    );

    // 3. Crea la lista de objetos QuestionOption, cada uno con un ID único.
    final options = optionTexts.map((text) {
      return QuestionOption(id: _uuid.v4(), text: text);
    }).toList();

    // 4. Llama al servicio para guardar la pregunta y sus opciones en Firestore.
    await service.addQuestion(newQuestion, options);
  }

  /// Guarda las opciones actualizadas para una pregunta.
  Future<void> updateQuestionAndOptions(
    String questionId,
    String newQuestionText,
    List<QuestionOption> newOptions,
    List<String> optionIdsToDelete,
  ) async {
    await service.updateQuestionAndOptions(
      questionId,
      newQuestionText,
      newOptions,
      optionIdsToDelete,
    );
  }

  /// Elimina una pregunta.
  Future<void> deleteQuestion(String questionId) async {
    await service.deleteQuestion(questionId);
  }
}
