import 'package:encuestor/components/primary_button.dart';
import 'package:encuestor/core/app_color.dart';
import 'package:encuestor/core/text_style.dart';
import 'package:encuestor/data/subject_repository.dart';
import 'package:flutter/material.dart';

class AddSubjectScreen extends StatefulWidget {
  final String professorId;

  const AddSubjectScreen({super.key, required this.professorId});

  @override
  State<AddSubjectScreen> createState() => _AddSubjectScreenState();
}

class _AddSubjectScreenState extends State<AddSubjectScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _infoController = TextEditingController();
  final _subjectRepository = SubjectRepository();
  bool _isSaving = false;

  @override
  void dispose() {
    _nameController.dispose();
    _infoController.dispose();
    super.dispose();
  }

  Future<void> _saveSubject() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isSaving = true;
    });

    try {
      await _subjectRepository.addSubject(
        name: _nameController.text.trim(),
        info: _infoController.text.trim(),
        professorId: widget.professorId,
      );

      if (mounted) {
        Navigator.of(context).pop(); // Regresa a la pantalla anterior
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al guardar la asignatura: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isKeyboardVisible = MediaQuery.of(context).viewInsets.bottom > 0;

    return Scaffold(
      backgroundColor: AppColor.backgroundP,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppColor.primaryP,
        title: Image.asset("assets/images/logo.png", width: 140),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 16,),
              SizedBox(
                width: double.infinity,
                child: Text(
                  "Crear Encuesta",
                  style: TextStyles.titleProfesor,
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12.0,
                  vertical: 4,
                ),
                child: Text(
                  "Nombre de la asignatura:",
                  style: TextStyles.bodyProfesor,
                ),
              ),
              TextFormField(
                controller: _nameController,
                cursorColor: AppColor.accent,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: AppColor.background,
                  hintText: "Nombre de la asignatura",
                  hintStyle: TextStyle(color: AppColor.hint),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide(
                      color: AppColor.accent,
                      width: 2.0,
                    ), // Color del borde cuando está enfocado
                  ),
                ),
                validator: (value) => (value == null || value.isEmpty)
                    ? 'Este campo es obligatorio'
                    : null,
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12.0,
                  vertical: 4,
                ),
                child: Text(
                  "Carrera:",
                  style: TextStyles.bodyProfesor,
                ),
              ),
              TextFormField(
                controller: _infoController,
                cursorColor: AppColor.accent,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: AppColor.background,
                  hintText: "Carrera (ej. Ingeniería Informática)",
                  hintStyle: TextStyle(color: AppColor.hint),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide(
                      color: AppColor.accent,
                      width: 2.0,
                    ), // Color del borde cuando está enfocado
                  ),
                ),
                validator: (value) => (value == null || value.isEmpty)
                    ? 'Este campo es obligatorio'
                    : null,
              ),
              const Spacer(), // Empuja el botón hacia abajo
              if (!isKeyboardVisible) ...[
                PrimaryButton(
                  text: _isSaving ? "" : "Guardar Asignatura",
                  onPressed: _isSaving ? () {} : _saveSubject,
                  child: _isSaving
                      ? const CircularProgressIndicator(color: Colors.white)
                      : SizedBox.shrink(),
                ),
                const SizedBox(height: 16),
              ]
            ],
          ),
        ),
      ),
    );
  }
}
