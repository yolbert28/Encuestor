import 'dart:math';

import 'package:encuestor/data/service/subjects_service.dart';
import 'package:encuestor/domain/subject.dart';
import 'package:uuid/uuid.dart';

class SubjectRepository {
  final service = SubjectsService();
  final _uuid = Uuid();

  /// Obtiene un flujo de la lista de asignaturas para un profesor específico.
  ///
  /// Este método se suscribe a los cambios en tiempo real de la base de datos.
  /// Cada vez que las asignaturas de un profesor cambien en Firestore,
  /// este Stream emitirá una nueva lista actualizada de objetos [Subject].
  Stream<List<Subject>> getSubjectsForProfessor(String professorId) {
    // 1. Llama al método del servicio, que devuelve un Stream<QuerySnapshot<Subject>>.
    return service.getSubjectsForProfessorStream(professorId).map((snapshot) {
      // 2. El método .map del Stream nos permite transformar cada evento (QuerySnapshot) que llega.
      // 3. De cada snapshot, tomamos la lista de documentos (`snapshot.docs`).
      // 4. Mapeamos esa lista de documentos. Para cada `doc`, llamamos a `.data()`
      //    que, gracias al conversor `withConverter`, nos devuelve un objeto `Subject`.
      // 5. Finalmente, convertimos el resultado en una `List<Subject>`.
      return snapshot.docs.map((doc) => doc.data()).toList();
    });
  }

  /// Añade una nueva asignatura para un profesor.
  Future<void> addSubject({
    required String name,
    required String info,
    required String professorId,
  }) async {
    // 1. Crea un nuevo objeto Subject con un ID único.
    final newSubject = Subject(
      id: _uuid.v4(),
      name: name,
      info: info,
      professorId: professorId,
      color: Random().nextInt(3)
    );

    // 2. Llama al servicio para guardar la nueva asignatura en Firestore.
    await service.addSubject(newSubject);
  }

  /// Elimina una asignatura y todos sus datos asociados.
  Future<void> deleteSubject(String subjectId) async {
    await service.deleteSubject(subjectId);
  }
}