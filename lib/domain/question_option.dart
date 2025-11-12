import 'package:cloud_firestore/cloud_firestore.dart';

class QuestionOption {
  final String id;
  String text;

  QuestionOption({
    required this.id,
    required this.text,
  });

  factory QuestionOption.fromFireStore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();

    return QuestionOption(
      id: snapshot.id,
      text: data?["text"] ?? "",
    );
  }

  Map<String, dynamic> toFirestore() {
    return {"text": text};
  }

}
