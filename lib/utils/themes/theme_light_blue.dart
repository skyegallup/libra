import 'package:flutter/widgets.dart';
import 'package:libra/utils/themes/theme_tokens.dart';
import 'package:mix/mix.dart';

final themeLightBlue = MixThemeData(
  colors: {
    $tok.color.primaryDark: Color(0xFF051927),
    $tok.color.primary: Color(0xFF19304F),
    $tok.color.primaryLight: Color(0xFF7190BC),
    $tok.color.primaryLighter: Color(0xFF9FC3F0),

    $tok.color.grayDarker: Color(0xFF121417),
    $tok.color.grayDark: Color(0xFF1D1D22),
    $tok.color.gray: Color(0xFF454545),
    $tok.color.grayLight: Color(0xFF888888),

    $tok.color.white: Color(0xFFFCFCFF)
  },
  radii: {
    $tok.radius.buttonRadius: Radius.circular(12)
  },
  textStyles: {
    $tok.textStyle.body: TextStyle(fontFamily: 'NotoSans', fontWeight: FontWeight.w400, fontSize: 16, height: 1.6),
    $tok.textStyle.heading1: TextStyle(fontFamily: 'NotoSans', fontWeight: FontWeight.w700, fontSize: 40, height: 1.6),
    $tok.textStyle.heading2: TextStyle(fontFamily: 'NotoSans', fontWeight: FontWeight.w700, fontSize: 26, height: 1.6),
    $tok.textStyle.heading3: TextStyle(fontFamily: 'NotoSans', fontWeight: FontWeight.w700, fontSize: 20, height: 1.6),
    $tok.textStyle.link: TextStyle(fontFamily: 'NotoSans', fontWeight: FontWeight.w500, fontSize: 16, height: 1.6),
    $tok.textStyle.quote: TextStyle(fontFamily: 'NotoSans', fontWeight: FontWeight.w400, fontStyle: FontStyle.italic, fontSize: 16, height: 1.6)
  }
);
