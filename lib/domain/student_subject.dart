class StudentSubject {
  final String subjectId;
  final bool responded;

  StudentSubject({required this.subjectId, required this.responded});

  // Factory para crear un StudentSubject desde un Map (como viene de Firestore)
  factory StudentSubject.fromMap(Map<String, dynamic> map) {
    return StudentSubject(
      subjectId: map['subject_id'] as String,
      responded: map['responded'] as bool,
    );
  }

  // Método para convertir un StudentSubject a un Map (para enviar a Firestore)
  Map<String, dynamic> toMap() {
    return {
      'subject_id': subjectId,
      'responded': responded,
    };
  }
}
