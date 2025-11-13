import 'package:encuestor/core/app_color.dart';
import 'package:encuestor/core/text_style.dart';
import 'package:encuestor/domain/question_option.dart';
import 'package:flutter/material.dart';

class SurveyTextField extends StatefulWidget {
  final bool isEditable;
  final QuestionOption option;
  final Function(String) onChanged;
  final VoidCallback? onDelete;

  const SurveyTextField({
    super.key,
    required this.isEditable,
    required this.option,
    required this.onChanged,
    this.onDelete,
  });

  @override
  State<SurveyTextField> createState() => _SurveyTextFieldState();
}

class _SurveyTextFieldState extends State<SurveyTextField> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    // 1. Creamos el controlador UNA SOLA VEZ con el texto inicial.
    _controller = TextEditingController(text: widget.option.text);
  }

  @override
  void didUpdateWidget(covariant SurveyTextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    // 2. Si el texto de la opción cambia desde fuera (ej. al presionar "Cancelar"),
    // actualizamos el texto en nuestro controlador para reflejar el cambio.
    if (widget.option.text != _controller.text) {
      _controller.text = widget.option.text;
    }
  }

  @override
  void dispose() {
    // 3. Liberamos el controlador para evitar fugas de memoria.
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 8,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 20.0),
          child: Icon(Icons.circle, size: 8, color: AppColor.textDarkProfesor),
        ),
        Expanded(
          child: TextField(
            // 4. Usamos la instancia del controlador que creamos en initState.
            controller: _controller,
            onChanged: widget.onChanged,
            maxLines: null,
            style: TextStyles.body,
            cursorColor: AppColor.accent,
            decoration: InputDecoration(
              filled: true,
              fillColor: widget.isEditable
                  ? AppColor.primaryP
                  : AppColor.disableSurveyTextField,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: BorderSide.none,
              ),
            ),
            enabled: widget.isEditable,
          ),
        ),
        if (widget.isEditable)
          Padding(
            padding: const EdgeInsets.only(left: 4.0, top: 4),
            child: Container(
              decoration: BoxDecoration(
                color: AppColor.red,
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: IconButton(
                icon: Icon(Icons.delete_outline, color: AppColor.white),
                onPressed: widget.onDelete,
              ),
            ),
          ),
      ],
    );
  }
}
