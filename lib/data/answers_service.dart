import 'package:cloud_firestore/cloud_firestore.dart';

class AnswersService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Guarda una lista de respuestas en un batch para asegurar que todas
  /// se escriban de forma atómica.
  Future<void> saveAnswers(List<Map<String, dynamic>> answers) async {
    WriteBatch batch = _firestore.batch();

    CollectionReference answersCollection = _firestore.collection('answers');

    for (var answer in answers) {
      // Crea un nuevo documento sin ID específico para que Firestore lo genere.
      DocumentReference docRef = answersCollection.doc();
      batch.set(docRef, answer);
    }

    await batch.commit();
  }
}