import 'package:encuestor/core/app_color.dart';
import 'package:flutter/material.dart';

class AppTextField extends StatefulWidget {
  final String? hintText;
  final double horizontalPadding;
  final bool enabled;
  final bool obscureText;
  final TextEditingController? controller;



  const AppTextField({super.key, this.hintText, this.horizontalPadding = 20, this.enabled = true, required this.controller, this.obscureText = false});

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  bool obscureText = false;

  @override
  void initState() {
    super.initState();
    obscureText = widget.obscureText;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: widget.horizontalPadding, right: widget.horizontalPadding),
      child: TextField(
        controller: widget.controller,
        enabled: widget.enabled,
        cursorColor: AppColor.accent,
        obscureText: obscureText,
        decoration: InputDecoration(
          suffixIcon: widget.obscureText ?  GestureDetector(
            onTap: () {
              setState(() {
                obscureText = !obscureText;
              });
            },
            child: Icon( obscureText ? Icons.visibility : Icons.visibility_off, color: AppColor.hint,)
            ) : null,
          filled: true,
          fillColor: widget.enabled ? AppColor.background : AppColor.textFieldDisabled,
          hintText: widget.hintText,
          hintStyle: TextStyle(color: AppColor.hint),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: BorderSide(
              color: AppColor.accent,
              width: 2.0,
            ), // Color del borde cuando está enfocado
          ),
        ),
      ),
    );
  }
}
