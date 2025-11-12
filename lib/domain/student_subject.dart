import 'package:cloud_firestore/cloud_firestore.dart';

class StudentSubject {
  final String id;
  final String subjectId;
  final String studentId;
  final bool responded;

  StudentSubject({required this.id,required this.subjectId,required this.studentId, required this.responded});

  // Factory para crear un StudentSubject desde un Map (como viene de Firestore)
  factory StudentSubject.fromFireStore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
    ) {
    final data = snapshot.data();

    return StudentSubject(
      id: snapshot.id,
      subjectId: data?["subject_id"] as String,
      studentId: data?["student_id"] as String,
      responded: data?['responded'] as bool,
    );
  }

  // Método para convertir un StudentSubject a un Map (para enviar a Firestore)
  Map<String, dynamic> toFirestore() {
    return {
      'subject_id': subjectId,
      'student_id': studentId,
      'responded': responded,
    };
  }
}
