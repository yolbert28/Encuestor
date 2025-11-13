import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:encuestor/domain/answer.dart';

class AnswersService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Guarda una lista de respuestas en un batch para asegurar que todas
  /// se escriban de forma atómica.
  /// Además, actualiza el estado 'responded' del estudiante para esa materia.
  Future<void> saveAnswers(List<Answer> answers, String subjectId, String studentId) async {
    WriteBatch batch = _firestore.batch();

    // --- 1. Guardar las respuestas ---
    final answersCollection = _firestore.collection('answers');
    for (var answer in answers) {
      final docRef = answersCollection.doc(); // Firestore genera el ID
      batch.set(docRef, answer.toFireStore());
    }

    // --- 2. Actualizar el estado en 'enrolled_subjects' ---
    // Buscamos el documento específico para el estudiante y la materia.
    final query = _firestore.collection('enrolled_subjects')
        .where('student_id', isEqualTo: studentId)
        .where('subject_id', isEqualTo: subjectId)
        .limit(1);

    final querySnapshot = await query.get();

    // Si encontramos el documento, lo añadimos a la operación de actualización del batch.
    if (querySnapshot.docs.isNotEmpty) {
      final docToUpdateRef = querySnapshot.docs.first.reference;
      batch.update(docToUpdateRef, {'responded': true});
    }

    // --- 3. Ejecutar todas las operaciones en la base de datos ---
    await batch.commit();
  }

  /// Obtiene un stream de los documentos de respuestas para una materia.
  Future<QuerySnapshot<Answer>> getAnswersForSubject(String subjectId) {
    return _firestore
        .collection('answers')
        .withConverter(
          fromFirestore: Answer.fromFireStore,
          toFirestore: (Answer answer, _) => answer.toFireStore(),
        )
        .where('subject_id', isEqualTo: subjectId)
        .get();
  }
}
