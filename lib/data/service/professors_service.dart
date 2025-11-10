import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:encuestor/domain/professor.dart';

class ProfessorsService {
  final CollectionReference<Professor> _professorsCollection = FirebaseFirestore
      .instance
      .collection('professors')
      .withConverter<Professor>(
        fromFirestore: Professor.fromFireStore,
        toFirestore: (Professor professor, _) => professor.toFirestore(),
      );

  // Obtiene un profesor por su ID
  Future<DocumentSnapshot<Professor>> getProfessor(String professorId) {
    return _professorsCollection.doc(professorId).get();
  }

  // Puedes añadir más métodos como addProfessor, updateProfessor, etc.
}
