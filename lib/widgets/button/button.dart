import 'package:flutter/widgets.dart';
import 'package:libra/widgets/button/button_spec.dart';
import 'package:libra/widgets/button/button_variants.dart';
import 'package:mix/mix.dart';

class LibraButton extends StatelessWidget {
  const LibraButton({
    super.key,
    required this.label,
    this.disabled = false,
    this.icon,
    this.onPressed,
    this.variant = ButtonVariant.normal,
    this.style
  });

  final String label;
  final bool disabled;
  final IconData? icon;
  final ButtonVariant variant;
  final VoidCallback? onPressed;
  final Style? style;

  @override
  Widget build(BuildContext context) {
    return Pressable(
      onPress: disabled ? null : onPressed,
      enabled: !disabled,
      child: SpecBuilder(
        style: null,
        builder: (context) {
          final button = ButtonSpec.of(context);
          return button.container(
            child: button.flex(
              direction: Axis.horizontal,
              children: [
                if (icon != null) button.icon(icon),
                if (label.isNotEmpty) button.label(label),
              ]
            )
          );
        }
      )
    );
  }
}