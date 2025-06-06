import 'package:flutter/material.dart';
import 'package:pickleball_app/core/utils/extensions.dart';

class ResponsiveText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;
  final double? fontSize;
  final FontWeight? fontWeight;
  final Color? color;
  final double? minFontSize;
  final double? maxFontSize;
  final bool autoScaleText;

  const ResponsiveText(
    this.text, {
    Key? key,
    this.style,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.fontSize,
    this.fontWeight,
    this.color,
    this.minFontSize,
    this.maxFontSize,
    this.autoScaleText = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = style ?? const TextStyle();
    
    if (fontSize != null) {
      textStyle = textStyle.copyWith(fontSize: fontSize!.sp);
    }
    
    if (fontWeight != null) {
      textStyle = textStyle.copyWith(fontWeight: fontWeight);
    }
    
    if (color != null) {
      textStyle = textStyle.copyWith(color: color);
    }
    
    if (autoScaleText) {
      return FittedBox(
        fit: BoxFit.scaleDown,
        child: Text(
          text,
          style: textStyle,
          textAlign: textAlign,
          maxLines: maxLines,
          overflow: overflow,
        ),
      );
    } else {
      return Text(
        text,
        style: textStyle,
        textAlign: textAlign,
        maxLines: maxLines,
        overflow: overflow,
      );
    }
  }
}
