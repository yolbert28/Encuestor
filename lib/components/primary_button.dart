import 'package:encuestor/core/text_style.dart';
import 'package:flutter/material.dart';
import 'package:encuestor/core/app_color.dart';

class PrimaryButton extends StatefulWidget {
  final double height;
  final double width;
  final double horizontalPadding;
  final String text;
  final Widget child;
  final bool onlyIcon;
  final EdgeInsetsGeometry? innerPadding;
  final Function() onPressed;

  const PrimaryButton({super.key, this.height = 60, this.width = double.infinity, this.horizontalPadding = 20,this.text = "", required this.onPressed, this.child = const SizedBox(), this.onlyIcon = false, this.innerPadding});

  @override
  State<PrimaryButton> createState() => _PrimaryButtonState();
}

class _PrimaryButtonState extends State<PrimaryButton> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height,
      width: widget.width,
      child: Padding(
        padding: EdgeInsets.only(left: widget.horizontalPadding, right: widget.horizontalPadding),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            padding: widget.innerPadding,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
            backgroundColor: AppColor.accent,
            foregroundColor: AppColor.white,
          ),
          onPressed: widget.onPressed,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if(!widget.onlyIcon)
                Text(widget.text, style: TextStyles.buttonText),
              widget.child
            ]
            )
        ),
      ),
    );
  }
}
