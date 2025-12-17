import 'package:libra/utils/themes/theme_tokens.dart';
import 'package:libra/widgets/text_field/text_field_spec.dart';
import 'package:mix/mix.dart';

final _util = TextFieldSpecUtility.self;
final _container = _util.container;
final _value = _util.value;

Style get _baseStyle => Style(
  _container.borderRadius.all.ref($tok.radius.buttonRadius),
  _container.padding.directional(12, 20),
  _container.color.ref($tok.color.grayDark),

  _value.style.ref($tok.textStyle.link),
  _value.color.ref($tok.color.white)
);

Style get _onDisabled => Style(
  _value.color.darken(50)
);

Style textFieldStyle(Style? style) {
  return Style(
    _baseStyle,

    $on.disabled(_onDisabled)
  ).merge(style);
}
