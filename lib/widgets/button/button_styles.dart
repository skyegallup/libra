import 'package:libra/utils/themes/theme_tokens.dart';
import 'package:libra/widgets/button/button_spec.dart';
import 'package:libra/widgets/button/button_variants.dart';
import 'package:mix/mix.dart';

final _util = ButtonSpecUtility.self;
final _label = _util.label;
final _container = _util.container;
final _flex = _util.flex;
final _icon = _util.icon;

Style get _baseStyle => Style(
  _container.borderRadius.all.ref($tok.radius.buttonRadius),
  _container.padding.directional(8, 20),

  _flex.gap(8),
  _flex.mainAxisAlignment.center(),
  _flex.crossAxisAlignment.center(),
  _flex.mainAxisSize.min(),

  _label.style.ref($tok.textStyle.link),

  _icon.size(24)
);

Style get _normalStyle => Style(
  _container.color.ref($tok.color.grayDarker),
  _label.color.ref($tok.color.white),
  _icon.color.ref($tok.color.white)
);

Style get _normalLightStyle => Style(
  _container.color.ref($tok.color.grayDark),
  _label.color.ref($tok.color.white),
  _icon.color.ref($tok.color.white)
);

Style get _outlinedStyle => Style(
  _normalStyle,
  _container.border.width(2),
  _container.border.color.ref($tok.color.grayLight)
);

Style get _onDisabled => Style(
  _label.color.darken(50),
  _icon.color.darken(50)
);

Style get _onHover => Style(
  _container.color.ref($tok.color.grayDark)
);

Style buttonStyle(Style? style, ButtonVariant? variant) {
  return Style(
    _baseStyle,

    ButtonVariant.normal(_normalStyle),
    ButtonVariant.normalLight(_normalLightStyle),
    ButtonVariant.outlined(_outlinedStyle),

    $on.disabled(_onDisabled),
    $on.hover(_onHover)
  ).applyVariant(variant).merge(style);
}
