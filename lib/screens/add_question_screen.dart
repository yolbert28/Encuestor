import 'package:encuestor/components/primary_button.dart';
import 'package:encuestor/components/secondary_button.dart';
import 'package:encuestor/core/app_color.dart';
import 'package:encuestor/core/text_style.dart';
import 'package:encuestor/data/question_repository.dart';
import 'package:flutter/material.dart';

class AddQuestionScreen extends StatefulWidget {
  final String subjectId;

  const AddQuestionScreen({super.key, required this.subjectId});

  @override
  State<AddQuestionScreen> createState() => _AddQuestionScreenState();
}

class _AddQuestionScreenState extends State<AddQuestionScreen> {
  final _formKey = GlobalKey<FormState>();
  final _questionController = TextEditingController();
  final List<TextEditingController> _optionControllers = [];
  final _questionRepository = QuestionRepository();
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    // Iniciar con 2 campos de opción vacíos
    _addOptionField();
    _addOptionField();
  }

  @override
  void dispose() {
    _questionController.dispose();
    for (var controller in _optionControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _addOptionField() {
    setState(() {
      _optionControllers.add(TextEditingController());
    });
  }

  void _removeOptionField(int index) {
    setState(() {
      _optionControllers[index].dispose();
      _optionControllers.removeAt(index);
    });
  }

  Future<void> _saveQuestion() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isSaving = true;
    });

    try {
      final questionText = _questionController.text;
      final optionTexts = _optionControllers
          .map((controller) => controller.text.trim())
          .where((text) => text.isNotEmpty)
          .toList();

      if (optionTexts.length < 2) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Debe proporcionar al menos dos opciones.'),
              backgroundColor: Colors.red,
            ),
          );
        }
        setState(() => _isSaving = false);
        return;
      }

      await _questionRepository.addQuestion(
        questionText,
        optionTexts,
        widget.subjectId,
      );

      if (mounted) {
        Navigator.of(context).pop(true); // Devuelve 'true' para indicar éxito
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al guardar la pregunta: $e'),
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
    return Scaffold(
      backgroundColor: AppColor.backgroundP,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppColor.primaryP,
        title: Image.asset("assets/images/logo.png", width: 140),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: [
            Expanded(
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    const SizedBox(height: 16),
                    SizedBox(
                        width: double.infinity,
                        child: Text("Crear Pregunta",
                            style: TextStyles.titleProfesor,
                            textAlign: TextAlign.center)),
                    const SizedBox(height: 16),
                    Text("Pregunta", style: TextStyles.subtitleProfesor),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _questionController,
                      style: TextStyles.body,
                      cursorColor: AppColor.accent,
                      decoration: InputDecoration(
                        hintText: 'Ingresa tu pregunta',
                        hintStyle: TextStyles.body,
                        filled: true,
                        fillColor: AppColor.primaryP,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      validator: (value) => (value == null || value.isEmpty)
                          ? 'Este campo es obligatorio'
                          : null,
                      maxLines: 3,
                    ),
                    const SizedBox(height: 24),
                    Text("Opciones", style: TextStyles.subtitleProfesor),
                    const SizedBox(height: 8),
                    ..._optionControllers.asMap().entries.map((entry) {
                      int index = entry.key;
                      TextEditingController controller = entry.value;
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: controller,
                                style: TextStyles.body,
                                cursorColor: AppColor.accent,
                                decoration: InputDecoration(
                                  filled: true,
                                  hintText: 'Opción ${index + 1}',
                                  hintStyle: TextStyles.body,
                                  fillColor: AppColor.primaryP,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                    borderSide: BorderSide.none,
                                  ),
                                ),
                                validator: (value) {
                                  if (index < 2 &&
                                      (value == null || value.isEmpty)) {
                                    return 'Obligatorio';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            if (_optionControllers.length > 2)
                              IconButton(
                                icon: const Icon(Icons.remove_circle_outline,
                                    color: Colors.red),
                                onPressed: () => _removeOptionField(index),
                              ),
                          ],
                        ),
                      );
                    }),
                    const SizedBox(height: 8),
                    SecondaryButton(
                      horizontalPadding: 0,
                      text: "Añadir Opción",
                      onPressed: _addOptionField,
                    ),
                    const SizedBox(height: 16), // Espacio antes del botón final
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0, bottom: 16.0),
              child: PrimaryButton(
                horizontalPadding: 0,
                text: _isSaving ? "" : "Guardar Pregunta",
                onPressed: _isSaving ? () {} : _saveQuestion,
                child: _isSaving
                      ? const CircularProgressIndicator(color: Colors.white)
                      : SizedBox.shrink(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
