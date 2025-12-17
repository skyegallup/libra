import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';
import 'package:mix_annotations/mix_annotations.dart';

part 'text_field_spec.g.dart';

@MixableSpec()
class TextFieldSpec extends Spec<TextFieldSpec> with _$TextFieldSpec {
  final BoxSpec container;
  final TextSpec value;

  static const of = _$TextFieldSpec.of;

  static const from = _$TextFieldSpec.from;

  const TextFieldSpec({
    BoxSpec? container,
    TextSpec? value,
    super.animated
  }) : container = container ?? const BoxSpec(),
    value = value ?? const TextSpec();
}