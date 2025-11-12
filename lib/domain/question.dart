import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:encuestor/domain/question_option.dart';

class Question {
  final String id;
  final String question;
  final String subjectId;
  List<QuestionOption> options;

  Question({
    required this.id,
    required this.question,
    required this.subjectId,
    required this.options,
  });

  factory Question.fromFireStore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();

    return Question(
      id: snapshot.id,
      question: data?["question_text"] as String,
      subjectId: data?["subject_id"] as String,
      options: [],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      "question": question,
      "subject_id": subjectId,
      "options": options.map((option) => option.toFirestore()).toList(),
    };
  }
}
