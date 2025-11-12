import 'package:cloud_firestore/cloud_firestore.dart';

class Answer {
  final String id;
  final String questionId;
  final String selectedOptionId;
  final String subjectId;

  Answer({
    required this.id,
    required this.questionId,
    required this.selectedOptionId,
    required this.subjectId,
  });

  factory Answer.fromFireStore(DocumentSnapshot<Map<String, dynamic>> snapshot, SnapshotOptions? options){
    final data = snapshot.data();

    return Answer(
      id: snapshot.id,
      questionId: data?['question_id'] as String,
      selectedOptionId: data?['selected_option_id'] as String,
      subjectId: data?['subject_id'] as String,
    );
  }

  Map<String, dynamic> toFireStore() {
    return {
        "question_id": questionId,
        "selected_option_id": selectedOptionId, 
        "subject_id": subjectId,           
      };
  }
}