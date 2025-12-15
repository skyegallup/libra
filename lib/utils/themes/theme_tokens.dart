import 'package:mix/mix.dart';

const $tok = ThemeTokens();

class ThemeTokens {
  const ThemeTokens();

  final radius = const ThemeBorderRadiusTokens();
  final color = const ThemeColorTokens();
  final textStyle = const ThemeTextStyle();
}

class ThemeBorderRadiusTokens {
  const ThemeBorderRadiusTokens();

  RadiusToken get buttonRadius => const RadiusToken('button-radius');
}

class ThemeColorTokens {
  const ThemeColorTokens();

  ColorToken get primaryDark => const ColorToken('primary-dark');
  ColorToken get primary => const ColorToken('primary');
  ColorToken get primaryLight => const ColorToken('primary-light');
  ColorToken get primaryLighter => const ColorToken('primary-lighter');

  ColorToken get grayDarker => const ColorToken('gray-darker');
  ColorToken get grayDark => const ColorToken('gray-dark');
  ColorToken get gray => const ColorToken('gray');
  ColorToken get grayLight => const ColorToken('gray-light');

  ColorToken get white => const ColorToken('white');
}

class ThemeTextStyle {
  const ThemeTextStyle();

  TextStyleToken get body => const TextStyleToken('body');
  TextStyleToken get heading1 => const TextStyleToken('heading-1');
  TextStyleToken get heading2 => const TextStyleToken('heading-2');
  TextStyleToken get heading3 => const TextStyleToken('heading-3');
  TextStyleToken get link => const TextStyleToken('link');
  TextStyleToken get quote => const TextStyleToken('quote');
}
