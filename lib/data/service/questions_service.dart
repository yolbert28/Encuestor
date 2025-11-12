import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:encuestor/domain/question.dart';
import 'package:encuestor/domain/question_option.dart';

class QuestionsService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late final CollectionReference _questionsCollection = _firestore.collection('questions');

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

    /// Actualiza las opciones de una pregunta específica.
  Future<void> updateQuestionOptions(
      String questionId, List<QuestionOption> newOptions) async {
    // 1. Crea un nuevo WriteBatch.
    WriteBatch batch = _firestore.batch();

    // 2. Itera sobre cada opción que necesita ser actualizada.
    for (final option in newOptions) {
      // Define la referencia al documento de la opción específica.
      final optionDocRef = _questionsCollection.doc(questionId).collection("options").doc(option.id);

      // Agrega una operación de actualización al batch. No se ejecuta todavía.
      batch.update(optionDocRef, {'text': option.text});
    }

    // 3. Ejecuta todas las operaciones en el batch de una sola vez.
    await batch.commit();
  }

}