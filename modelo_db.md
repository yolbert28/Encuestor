# Modelo de Base de Datos Optimizado (NoSQL - Firestore)

Este modelo está diseñado para ser más escalable y eficiente, evitando el anidamiento profundo y facilitando las consultas.

---

### 1. Colección `professors`

Almacena la información de cada profesor.

```json
{
  "_id": "12345678", // Document ID (puede ser la cédula)
  "name": "Juan Pérez",
  "is_admin": true,
  "password": "contraseña123",
  // ... otros datos del profesor
}
```

---

### 2. Colección `subjects`

Contiene todas las asignaturas. Cada asignatura está vinculada a un profesor.

```json
{
  "_id": "SUB101", // Document ID
  "name": "Sistemas Operativos",
  "info": "Ingeniería Informática",
  "professor_id": "12345678", // Referencia (FK) a la colección 'professors'
  "color": 1
}
```

---

### 3. Colección `questions`

Almacena todas las preguntas, vinculadas a una asignatura. Las opciones se anidan aquí porque siempre se leen junto con la pregunta y su número es limitado.

```json
{
  "_id": "Q3001", // Document ID
  "question_text": "¿El rendimiento del sistema operativo es adecuado?",
  "subject_id": "SUB101", // Referencia (FK) a la colección 'subjects'
  "options": [
    { "id": "OPT1", "text": "Excelente" },
    { "id": "OPT2", "text": "Bueno" },
    { "id": "OPT3", "text": "Regular" },
    { "id": "OPT4", "text": "Malo" }
  ]
}
```

---

### 4. Colección `students`

Guarda la información de los estudiantes y, crucialmente, el estado de las encuestas que han respondido.

```json
{
  "_id": "30603453", // Document ID (puede ser la cédula)
  "enrolled_subjects": [
    {
      "subject_id": "SUB101", // Referencia a la asignatura
      "responded": false     // 'true' si ya completó la encuesta para esta materia
    },
    {
      "subject_id": "SUB102",
      "responded": true
    }
  ]
}
```

---

### 5. Colección `answers`

Almacena cada respuesta de forma anónima. **No hay ninguna referencia al estudiante.**

```json
{
  "_id": "ANS_XYZ", // Document ID (autogenerado por Firestore)
  "question_id": "Q3001",         // Referencia a la pregunta
  "selected_option_id": "OPT1",   // La opción que se seleccionó
  "subject_id": "SUB101"          // Referencia a la materia (útil para agregar resultados)
}
```