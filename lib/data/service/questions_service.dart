import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:encuestor/domain/question.dart';
import 'package:encuestor/domain/question_option.dart';

class QuestionsService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late final CollectionReference _questionsCollection = _firestore.collection(
    'questions',
  );

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

  Future<QuerySnapshot<QuestionOption>> getOptionsForQuestion(
    String questionId,
  ) {
    return _questionsCollection
        .doc(questionId)
        .collection("options")
        .withConverter(
          fromFirestore: QuestionOption.fromFireStore,
          toFirestore: (QuestionOption questionOption, _) =>
              questionOption.toFirestore(),
        )
        .get();
  }

  /// Actualiza las opciones de una pregunta específica.
  Future<void> updateQuestionOptions(
    String questionId,
    List<QuestionOption> newOptions,
  ) async {
    // 1. Crea un nuevo WriteBatch.
    WriteBatch batch = _firestore.batch();

    // 2. Itera sobre cada opción que necesita ser actualizada.
    for (final option in newOptions) {
      // Define la referencia al documento de la opción, usando su ID.
      final optionDocRef = _questionsCollection
          .doc(questionId)
          .collection("options")
          .doc(option.id);

      // Agrega una operación 'set' al batch.
      // Esto crea el documento si no existe (nueva opción) o lo
      // sobrescribe si ya existe (opción editada).
      batch.set(optionDocRef, option.toFirestore());
    }

    // 3. Ejecuta todas las operaciones en el batch de una sola vez.
    await batch.commit();
  }

  /// Añade una nueva pregunta y sus opciones a Firestore.
  Future<void> addQuestion(Question newQuestion, List<QuestionOption> options) async {
    // 1. Crea una referencia para el nuevo documento de pregunta.
    // Firestore generará un ID único automáticamente.
    final questionDocRef = _questionsCollection.doc(newQuestion.id);

    // 2. Crea un WriteBatch para ejecutar múltiples operaciones atómicamente.
    final batch = _firestore.batch();

    // 3. Añade la operación para crear el documento de la pregunta.
    batch.set(questionDocRef, newQuestion.toFirestore());

    // 4. Añade las operaciones para crear cada documento de opción
    //    en la subcolección 'options'.
    for (final option in options) {
      final optionDocRef = questionDocRef.collection('options').doc(option.id);
      batch.set(optionDocRef, option.toFirestore());
    }

    // 5. Ejecuta todas las operaciones del batch.
    // Esto garantiza que o se crea la pregunta con todas sus opciones, o no se crea nada.
    await batch.commit();
  }
}
