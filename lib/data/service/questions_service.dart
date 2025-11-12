import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:encuestor/domain/question.dart';
import 'package:encuestor/domain/question_option.dart';

class QuestionsService {
  final CollectionReference _questionsCollection = FirebaseFirestore.instance
      .collection('questions');

  /// Obtiene todas las preguntas para una asignatura específica.
  Future<QuerySnapshot<Question>> getQuestionsForSubject(String subjectId) {
    return _questionsCollection
        .withConverter<Question>(
          fromFirestore: Question.fromFireStore,
          toFirestore: (Question question, _) => question.toFirestore(),
        )
        .where('subject_id', isEqualTo: subjectId)
        .get();
  }

  Future<QuerySnapshot<QuestionOption>> getOptionsForQuestion(String questionId) {
    return _questionsCollection
        .doc(questionId)
        .collection("options")
        .withConverter(
          fromFirestore: QuestionOption.fromFireStore,
          toFirestore: (QuestionOption questionOption, _) =>
              questionOption.toFirestore(),
        ).get();
  }
}
