import 'package:encuestor/components/primary_button.dart';
import 'package:encuestor/components/secondary_button.dart';
import 'package:encuestor/components/survey_text_field.dart';
import 'package:encuestor/core/app_color.dart';
import 'package:encuestor/core/text_style.dart';
import 'package:encuestor/data/question_repository.dart';
import 'package:encuestor/domain/question.dart';
import 'package:encuestor/domain/question_option.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter/material.dart';

class SurveyEditCard extends StatefulWidget {
  final int index;
  final Question question;
  final VoidCallback onSaveChanges; // 1. Añadimos el callback
  const SurveyEditCard({
    super.key,
    required this.question,
    required this.index,
    required this.onSaveChanges,
  });

  @override
  State<SurveyEditCard> createState() => _SurveyEditCardState();
}

class _SurveyEditCardState extends State<SurveyEditCard> {
  final _questionRepository = QuestionRepository();
  var showInfo = false;
  var isEditable = false;
  bool _isSaving = false;

  // Lista local para gestionar las opciones (añadir, editar, etc.)
  late List<QuestionOption> _localOptions;
  // Controlador y variable local para el texto de la pregunta.
  late TextEditingController _questionTextController;
  late String _localQuestionText;
  final _uuid = Uuid();

  @override
  void initState() {
    super.initState();
    // Clonamos las opciones del widget a nuestra lista local.
    _localQuestionText = widget.question.question;
    _questionTextController = TextEditingController(text: _localQuestionText);
    _localOptions = widget.question.options.toList();
  }

  void _addOption() {
    setState(() {
      // Creamos una nueva opción con un ID único y texto por defecto.
      final newOption = QuestionOption(id: _uuid.v4(), text: 'Nueva opción');
      _localOptions.add(newOption);
    });
  }

  void _deleteOption(int index) {
    // No permitir eliminar si solo quedan 2 opciones, y mostrar un mensaje.
    if (_localOptions.length <= 2) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Una pregunta debe tener al menos dos opciones.'),
          backgroundColor: AppColor.textDarkProfesor,
        ),
      );
      return;
    }
    setState(() {
      _localOptions.removeAt(index);
    });
  }
  void _handleSave() async {
    setState(() {
      _isSaving = true;
    });

    try {
      // 1. Crear la nueva lista de opciones con los textos actualizados
      // Identificar las opciones a eliminar
      final originalOptionIds = widget.question.options.map((o) => o.id).toSet();
      final currentOptionIds = _localOptions.map((o) => o.id).toSet();
      final optionIdsToDelete = originalOptionIds.difference(currentOptionIds).toList();

      // 2. Llamar al repositorio para guardar el texto de la pregunta y las opciones.
      await _questionRepository.updateQuestionAndOptions(
        widget.question.id,
        _localQuestionText, // Enviamos el nuevo texto de la pregunta.
        _localOptions,      // Enviamos la lista local de opciones.
        optionIdsToDelete,
      );

      // 2. Llamamos al callback para notificar al padre que debe recargar
      widget.onSaveChanges();

      // 3. Salir del modo de edición
      setState(() {
        isEditable = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Cambios guardados con éxito.'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al guardar los cambios: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      setState(() {
        _isSaving = false;
      });
    }
  }

  @override
  void dispose() {
    // Liberamos el controlador para evitar fugas de memoria.
    _questionTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0),
          border: Border.all(width: 2, color: AppColor.primaryP),
          color: AppColor.surveyEditCardBackground,
        ),
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () {
                setState(() {
                  showInfo = !showInfo;
                });
              },
              behavior: HitTestBehavior.opaque, // <-- Añade esta línea
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Text(
                      "Pregunta ${widget.index}",
                      style: TextStyles.subtitleProfesor,
                    ),
                    Spacer(),
                    Icon(
                      color: AppColor.textDarkProfesor,
                      showInfo
                          ? Icons.keyboard_arrow_up
                          : Icons.keyboard_arrow_down,
                    ),
                  ],
                ),
              ),
            ),
            if (showInfo)
              Padding(
                padding: const EdgeInsets.only(top: 0, left: 16, right: 16, bottom: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 8,
                  children: [
                    isEditable
                        ? TextField(
                            controller: _questionTextController,
                            onChanged: (newText) {
                              setState(() {
                                _localQuestionText = newText;
                              });
                            },
                            maxLines: null,
                            style: TextStyles.body,
                            cursorColor: AppColor.accent,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: AppColor.primaryP,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          )
                        : Text(widget.question.question,
                            style: TextStyles.bodyProfesor),
                    for (var i = 0; i < _localOptions.length; i++)
                      SurveyTextField(
                        isEditable: isEditable,
                        option: _localOptions[i],
                        onChanged: (newText) {
                          // Actualizamos el texto de la opción en nuestra lista local.
                          setState(() {
                            _localOptions[i].text = newText;
                          });
                        },
                        onDelete: () => _deleteOption(i),
                      ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: isEditable
                          ? Column(
                              spacing: 8,
                              children: [
                                SecondaryButton(
                                  text: "Agregar opción",
                                  onPressed: _addOption,
                                  horizontalPadding: 0,
                                  height: 40,
                                ),
                                Row(
                                  spacing: 8,
                                  children: [
                                    Expanded(
                                      child: SecondaryButton(
                                        text: "Cancelar",
                                        onPressed: () {
                                          setState(() {
                                            // Revertimos la lista local a la original.
                                            _localQuestionText = widget.question.question;
                                            _questionTextController.text = widget.question.question;
                                            _localOptions = widget
                                                .question
                                                .options
                                                .toList();
                                            isEditable = false;
                                          });
                                        },
                                        backgroundColor:
                                            AppColor.cancelButtonBackground,
                                        borderColor: AppColor.darkGreen,
                                        horizontalPadding: 0,
                                        height: 40,
                                      ),
                                    ),
                                    Expanded(
                                      child: PrimaryButton(
                                        text: "Guardar",
                                        onPressed: _handleSave,
                                        horizontalPadding: 0,
                                        height: 40,
                                        // child: _isSaving
                                        //     ? const SizedBox(
                                        //         height: 20, width: 20,
                                        //         child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2,))
                                        //     : null),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            )
                          : SecondaryButton(
                              text: "Edit",
                              height: 40,
                              horizontalPadding: 0,
                              onPressed: () {
                                setState(() {
                                  isEditable = true;
                                });
                              },
                            ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
