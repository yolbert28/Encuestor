import 'package:encuestor/data/service/questions_service.dart';
import 'package:encuestor/domain/question.dart';
import 'package:encuestor/domain/question_option.dart';

class QuestionRepository {
  final service = QuestionsService();

  Future<List<Question>> getQuestionsForSubject(String subjectId) async {

    final questionsSnapshot = await service.getQuestionsForSubject(subjectId);

    final result = questionsSnapshot.docs.map((doc) => doc.data()).toList();

    List<Question> questions = [];

    for (var question in result) {
      final optionsSnapshot = await service.getOptionsForQuestion(question.id);
      question.options = optionsSnapshot.docs
          .map((doc) => doc.data())
          .toList();
      questions.add(question);
    }

    return questions;
  }

  /// Guarda las opciones actualizadas para una pregunta.
  Future<void> updateQuestionOptions(
      String questionId, List<QuestionOption> newOptions) {
    return service.updateQuestionOptions(questionId, newOptions);
  }
}
