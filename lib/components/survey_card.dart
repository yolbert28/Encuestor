import 'dart:math';

import 'package:encuestor/core/app_color.dart';
import 'package:encuestor/core/text_style.dart';
import 'package:flutter/material.dart';

class SurveyCard extends StatefulWidget {
  final String title;
  final String info;
  final Function() onPressed;

  const SurveyCard({
    super.key,
    required this.title,
    required this.info,
    required this.onPressed,
  });

  @override
  State<SurveyCard> createState() => _SurveyCardState();
}

class _SurveyCardState extends State<SurveyCard> {
  final colors = [
  Color(0xFFA88522), // Amarillo Dorado Oscuro
  Color(0xFF4DB065), // Verde Menta Oscuro
  Color(0xFFD45C50), // Coral Oscuro
  Color(0xFF987298), // Lila Oscuro
  Color(0xFF5A9AC0), // Azul Cielo Oscuro
];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20),
      child: Material(
        color: colors[Random().nextInt(5)],
        borderRadius: BorderRadius.circular(8.0),
        child: InkWell(
          onTap: widget.onPressed,
          borderRadius: BorderRadius.circular(
            8.0,
          ), // Para que la onda respete los bordes
          child: SizedBox(
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.only(
                left: 16,
                right: 16,
                top: 8,
                bottom: 8,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.title, style: TextStyles.titleSurvey),
                  const SizedBox(height: 28),
                  SizedBox(
                    width: double.infinity,
                    child: Text(
                      widget.info,
                      textAlign: TextAlign.end,
                      style: TextStyles.body,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
