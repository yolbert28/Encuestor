import 'package:cloud_firestore/cloud_firestore.dart';

class Subject {
  final String id;
  final String name;
  final String info;
  final String professorId;
  final int color;

  Subject({
    required this.id,
    required this.name,
    required this.info,
    required this.professorId,
    required this.color,
  });

  factory Subject.fromFireStore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();

    return Subject(
      id: snapshot.id,
      name: data?["name"] as String,
      info: data?["info"] as String,
      professorId: data?["professor_id"] as String,
      color: data?["color"] as int,
    );
  }

  Map<String, dynamic> toFireStore() {
    return {
      "name": name,
      "info": info,
      "profesor_id": professorId,
      "color": color,
    };
  }
}
