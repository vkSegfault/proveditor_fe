import 'package:flutter/material.dart';
import 'dart:ui';

class GlassTextButton extends StatelessWidget {
  const GlassTextButton({ super.key, required this.text, required this.f, this.height = 100, this.width = 100 });

  final String text;
  final void Function() f;
  final double height;
  final double width;

  @override
  Widget build(BuildContext context) {
    return TextButton(
            onPressed: f,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
                child: Container(
                  alignment: Alignment.center,
                  height: height,
                  width: width,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: Colors.black38
                  ),
                  child: Text( text, textAlign: TextAlign.center, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold) ),
                ),
              ),
            )
          );
  }
}