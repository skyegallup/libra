import 'package:flutter/widgets.dart';
import 'package:libra/utils/themes/theme_tokens.dart';
import 'package:libra/widgets/button/button.dart';
import 'package:libra/widgets/button/button_spec.dart';
import 'package:libra/widgets/button/button_variants.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:mix/mix.dart';

class Sidebar extends StatelessWidget {
  const Sidebar({super.key});

  @override
  Widget build(BuildContext context) {
    return Box(
      style: Style(
        $box.border.end.color.ref($tok.color.gray),
        $box.border.end.width(2),
        $box.color.ref($tok.color.grayDarker),
        $box.padding.all(16),
        $box.width(320)
      ),
      child: VBox(
        style: Style(
          $flex.gap(8),
          $flex.crossAxisAlignment.stretch()
        ),
        children: [
          LibraButton(
            style: Style(
              ButtonSpecUtility.self.flex.mainAxisAlignment.start()
            ),
            variant: ButtonVariant.outlined,
            label: 'skyebound.gay',
            onPressed: () => print('todo'),
          ),
          LibraButton(
            style: Style(
              ButtonSpecUtility.self.flex.mainAxisAlignment.start()
            ),
            variant: ButtonVariant.normal,
            label: 'New tab',
            icon: LucideIcons.plus,
            onPressed: () => print('todo'),
          )
        ]
      )
    );
  }
}