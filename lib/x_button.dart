import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';

class XButton extends StatefulWidget {
  const XButton({
    super.key,
    this.onPressed,
    this.borderColor = Colors.black,
    this.textStyle,
    this.paddingButton,
    required this.text,
  });

  final void Function()? onPressed;
  final String text;
  final Color borderColor;
  final TextStyle? textStyle;
  final EdgeInsets? paddingButton;

  @override
  State<XButton> createState() => _XButtonState();
}

class _XButtonState extends State<XButton> {
  bool _isPressed = false; // Track button press state

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() {
        _isPressed = true;
      }),
      onTapUp: (_) => setState(() {
        _isPressed = false;
      }),
      onTapCancel: () => setState(() {
        _isPressed = false;
      }),
      child: AnimatedContainer(
        padding: EdgeInsets.all(0),
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          color: Colors.transparent,
          boxShadow: _isPressed
              ? [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.6),
                    spreadRadius: 10,
                    blurRadius: 50,
                  ),
                ]
              : [],
        ),
        child: TextButton(
          onPressed: widget.onPressed,
          style: ButtonStyle(
            padding: MaterialStateProperty.all<EdgeInsets>(
              widget.paddingButton != null
                  ? widget.paddingButton!
                  : const EdgeInsets.fromLTRB(20, 12, 20, 10),
            ),
            backgroundColor: MaterialStateProperty.resolveWith<Color?>(
              (Set<MaterialState> states) {
                if (states.contains(MaterialState.pressed)) {
                  return Colors.black;
                }
                return Colors.black;
              },
            ),
            foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
                side: BorderSide(color: widget.borderColor),
              ),
            ),
          ),
          child: Text(
            widget.text,
            style: widget.textStyle != null
                ? widget.textStyle
                : ResponsiveBreakpoints.of(context).isDesktop
                    ? Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w400,
                        )
                    : Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w400,
                        ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
