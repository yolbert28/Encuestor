import 'package:encuestor/core/app_color.dart';
import 'package:flutter/material.dart';

class AnimatedSwitch extends StatefulWidget {
  final Widget leftWidget;
  final Widget rightWidget;
  final ValueChanged<bool> onChanged; // true para la derecha, false para la izquierda
  final double height;
  final double horizontalPadding;
  final bool initialValue;

  const AnimatedSwitch({
    super.key,
    required this.leftWidget,
    required this.rightWidget,
    required this.onChanged,
    this.height = 40,
    this.horizontalPadding = 20,
    this.initialValue = false,
  });

  @override
  State<AnimatedSwitch> createState() => _AnimatedSwitchState();
}

class _AnimatedSwitchState extends State<AnimatedSwitch> with SingleTickerProviderStateMixin {
  late bool _isRightSelected;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _isRightSelected = widget.initialValue;
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );

    if (_isRightSelected) {
      _animationController.value = 1.0;
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _handleTap() {
    setState(() {
      _isRightSelected = !_isRightSelected;
      if (_isRightSelected) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
      widget.onChanged(_isRightSelected);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: widget.horizontalPadding),
      child: GestureDetector(
        onTap: _handleTap,
        child: Container(
          height: widget.height,
          width: double.infinity,
          decoration: BoxDecoration(
            color: AppColor.lightGrey,
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Stack(
            children: [
              AnimatedAlign(
                alignment: _isRightSelected ? Alignment.centerRight : Alignment.centerLeft,
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeInOut,
                child: FractionallySizedBox(
                  widthFactor: 0.5,
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColor.accent,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                ),
              ),
              Row(
                children: [
                  Expanded(child: Center(child: widget.leftWidget)),
                  Expanded(child: Center(child: widget.rightWidget)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
