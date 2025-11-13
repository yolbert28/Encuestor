import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:encuestor/domain/subject.dart';

class SubjectsService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final CollectionReference<Subject> _subjectsCollection = FirebaseFirestore
      .instance
      .collection('subjects')
      .withConverter<Subject>(
        fromFirestore: Subject.fromFireStore,
        toFirestore: (Subject subject, _) => subject.toFireStore(),
      );
  late final CollectionReference _questionsCollection = _firestore.collection(
    'questions',
  );
  late final CollectionReference _enrolledSubjectsCollection = _firestore
      .collection('enrolled_subjects');
  late final CollectionReference _answersCollection = _firestore.collection(
    'answers',
  );

  // Obtiene un stream de todas las materias (ideal para listas en tiempo real)
  Stream<QuerySnapshot> getSubjectsStream() {
    return _subjectsCollection.snapshots();
  }

  // Obtiene las materias de un profesor específico
  Stream<QuerySnapshot<Subject>> getSubjectsForProfessorStream(
    String professorId,
  ) {
    return _subjectsCollection
        .where('professor_id', isEqualTo: professorId)
        .snapshots();
  }

  /// Obtiene una lista de asignaturas a partir de una lista de IDs.
  ///
  /// Esto es útil para obtener todas las asignaturas en las que un estudiante
  /// está inscrito.
  Future<QuerySnapshot<Subject>> getSubjectsByIds(
    List<String> subjectIds,
  ) async {
    if (subjectIds.isEmpty) {
      // Retorna una instantánea vacía si no hay IDs para evitar errores.
      return _subjectsCollection
          .where(FieldPath.documentId, whereIn: ['_'])
          .get();
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

  /// Elimina una asignatura y todos los datos relacionados en un batch.
  Future<void> deleteSubject(String subjectId) async {
    final batch = _firestore.batch();

    // 1. Referencia al documento de la asignatura a eliminar.
    final subjectRef = _subjectsCollection.doc(subjectId);
    batch.delete(subjectRef);

    // 2. Encuentra y elimina las preguntas asociadas.
    final questionsQuery = await _questionsCollection.where('subject_id', isEqualTo: subjectId).get();
    for (final doc in questionsQuery.docs) {
      // También eliminamos la subcolección de opciones
      final optionsQuery = await doc.reference.collection('options').get();
      for (final optionDoc in optionsQuery.docs) {
        batch.delete(optionDoc.reference);
      }
      batch.delete(doc.reference);
    }

    // 3. Encuentra y elimina las inscripciones de estudiantes asociadas.
    final enrolledQuery = await _enrolledSubjectsCollection.where('subject_id', isEqualTo: subjectId).get();
    for (final doc in enrolledQuery.docs) {
      batch.delete(doc.reference);
    }

    // 4. Encuentra y elimina las respuestas asociadas.
    final answersQuery = await _answersCollection.where('subject_id', isEqualTo: subjectId).get();
    for (final doc in answersQuery.docs) {
      batch.delete(doc.reference);
    }

    // 5. Ejecuta todas las operaciones de borrado.
    await batch.commit();
  }

}
