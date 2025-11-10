import 'package:cloud_firestore/cloud_firestore.dart';

class QuestionsService {
  final CollectionReference _questionsCollection =
      FirebaseFirestore.instance.collection('questions');

  /// Obtiene todas las preguntas para una asignatura específica.
  Future<QuerySnapshot> getQuestionsForSubject(String subjectId) {
    return _questionsCollection.where('subject_id', isEqualTo: subjectId).get();
  }
}