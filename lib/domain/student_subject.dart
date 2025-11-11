import 'package:cloud_firestore/cloud_firestore.dart';

class StudentSubject {
  final String subjectId;
  final bool responded;

  StudentSubject({required this.subjectId, required this.responded});

  // Factory para crear un StudentSubject desde un Map (como viene de Firestore)
  factory StudentSubject.fromFireStore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
    ) {
    final data = snapshot.data();

    return StudentSubject(
      subjectId: snapshot.id,
      responded: data?['responded'] as bool,
    );
  }

  // Método para convertir un StudentSubject a un Map (para enviar a Firestore)
  Map<String, dynamic> toFirestore() {
    return {
      'responded': responded,
    };
  }
}
