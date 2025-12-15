import 'package:mix/mix.dart';

class ButtonVariant extends Variant {
  const ButtonVariant._(super.name);

  static const normal = ButtonVariant._('normal');
  static const outlined = ButtonVariant._('outlined');
}
