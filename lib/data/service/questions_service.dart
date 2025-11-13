import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:encuestor/domain/question.dart';
import 'package:encuestor/domain/question_option.dart';

class QuestionsService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late final CollectionReference _questionsCollection = _firestore.collection(
    'questions',
  );
  late final CollectionReference _answersCollection = _firestore.collection(
    'answers',
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
  Future<void> updateQuestionAndOptions(
      String questionId,
      String newQuestionText,
      List<QuestionOption> newOptions,
      List<String> optionIdsToDelete) async {
    // 1. Crea un nuevo WriteBatch.
    WriteBatch batch = _firestore.batch();
    final questionDocRef = _questionsCollection.doc(questionId);
    final optionsCollectionRef = questionDocRef.collection("options");

    // 2. Agrega la operación para actualizar el texto de la pregunta.
    batch.update(questionDocRef, {'question_text': newQuestionText});


    // 3. Itera sobre cada opción que necesita ser actualizada o creada.
    for (final option in newOptions) {
      // Define la referencia al documento de la opción, usando su ID.
      final optionDocRef = optionsCollectionRef.doc(option.id);

      // Agrega una operación 'set' al batch.
      // Esto crea el documento si no existe (nueva opción) o lo
      // sobrescribe si ya existe (opción editada).
      batch.set(optionDocRef, option.toFirestore());
    }

    // 4. Itera sobre los IDs de las opciones a eliminar.
    for (final optionId in optionIdsToDelete) {
      final optionDocRef = optionsCollectionRef.doc(optionId);
      // Agrega una operación 'delete' al batch.
      batch.delete(optionDocRef);
    }

    // 5. Ejecuta todas las operaciones en el batch de una sola vez.
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

  /// Elimina una pregunta, su subcolección de opciones y todas las respuestas asociadas.
  Future<void> deleteQuestion(String questionId) async {
    final batch = _firestore.batch();
    final questionRef = _questionsCollection.doc(questionId);

    // 1. Encuentra y elimina las respuestas asociadas a la pregunta.
    final answersQuery = await _answersCollection.where('question_id', isEqualTo: questionId).get();
    for (final doc in answersQuery.docs) {
      batch.delete(doc.reference);
    }

    // 2. Eliminar la subcolección de opciones de la pregunta.
    final optionsQuery = await questionRef.collection('options').get();
    for (final doc in optionsQuery.docs) {
      batch.delete(doc.reference);
    }

    // 3. Eliminar el documento de la pregunta.
    batch.delete(questionRef);

    // 4. Ejecutar todas las operaciones de borrado en el batch.
    await batch.commit();
  }
}
