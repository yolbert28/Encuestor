import 'package:flutter/material.dart';

class IconButtonApp extends StatefulWidget {
  final Widget child;
  final Function() onPressed;

  const IconButtonApp({super.key, required this.child, required this.onPressed});

  @override
  State<IconButtonApp> createState() => _IconButtonAppState();
}

class _IconButtonAppState extends State<IconButtonApp> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(onPressed: (){}, child: widget.child);
  }
}