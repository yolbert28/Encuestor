import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:encuestor/domain/subject.dart';

class SubjectsService {
  final CollectionReference<Subject> _subjectsCollection =
      FirebaseFirestore.instance
      .collection('subjects')
      .withConverter<Subject>(
        fromFirestore: Subject.fromFireStore, 
        toFirestore: (Subject subject, _) => subject.toFireStore(),
        );

  // Obtiene un stream de todas las materias (ideal para listas en tiempo real)
  Stream<QuerySnapshot> getSubjectsStream() {
    return _subjectsCollection.snapshots();
  }

  // Obtiene las materias de un profesor específico
  Stream<QuerySnapshot<Subject>> getSubjectsForProfessorStream(String professorId) {
    return _subjectsCollection.where('professor_id', isEqualTo: professorId).snapshots();
  }

  /// Obtiene una lista de asignaturas a partir de una lista de IDs.
  ///
  /// Esto es útil para obtener todas las asignaturas en las que un estudiante
  /// está inscrito.
  Future<QuerySnapshot<Subject>> getSubjectsByIds(List<String> subjectIds) async {
    if (subjectIds.isEmpty) {
      // Retorna una instantánea vacía si no hay IDs para evitar errores.
      return _subjectsCollection.where(FieldPath.documentId, whereIn: ['_']).get();
    }
    return _subjectsCollection
        .where(FieldPath.documentId, whereIn: subjectIds)
        .get();
  }

  Future<DocumentSnapshot> getSubject(String subjectId) {
    return _subjectsCollection.doc(subjectId).get();
  }

  /// Añade una nueva asignatura a la colección 'subjects'.
  Future<void> addSubject(Subject subject) {
    // Firestore generará un ID de documento automáticamente si no se especifica.
    // Usamos .set() para asegurar que los datos coincidan con nuestro modelo.
    return _subjectsCollection.doc(subject.id).set(subject);
  }
}