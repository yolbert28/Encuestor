import 'package:encuestor/core/text_style.dart';
import 'package:flutter/material.dart';
import 'package:encuestor/core/app_color.dart';

class SecondaryButton extends StatefulWidget {
  final double height;
  final double width;
  final double horizontalPadding;
  final Color backgroundColor;
  final Color borderColor;
  final String text;
  final Function() onPressed;

  const SecondaryButton({super.key, this.height = 60, this.width = double.infinity, this.horizontalPadding = 20, required this.text, required this.onPressed, this.backgroundColor = AppColor.secondaryButtonBackground, this.borderColor = AppColor.accent});

  @override
  State<SecondaryButton> createState() => _SecondaryButtonState();
}

class _SecondaryButtonState extends State<SecondaryButton> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height,
      width: widget.width,
      child: Padding(
        padding: EdgeInsets.only(left: widget.horizontalPadding, right: widget.horizontalPadding),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
              side: BorderSide(width: 2, color: widget.borderColor)
            ),
            backgroundColor: widget.backgroundColor,
            foregroundColor: AppColor.white,
          ),
          onPressed: widget.onPressed,
          child: Text(widget.text, style: TextStyles.buttonText, textAlign: TextAlign.center,),
        ),
      ),
    );
  }
}
