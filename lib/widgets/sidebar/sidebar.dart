import 'package:flutter/widgets.dart';
import 'package:libra/data/page_state_repository.dart';
import 'package:libra/utils/themes/theme_tokens.dart';
import 'package:libra/widgets/button/button.dart';
import 'package:libra/widgets/button/button_spec.dart';
import 'package:libra/widgets/button/button_variants.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:mix/mix.dart';
import 'package:provider/provider.dart';

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
      child: Consumer<PageStateRepository>(
        builder: (context, repo, child) {
          final pageStates = repo.pageStates;
          final currentPageUuid = repo.currentPageState.uuid;

          return VBox(
            style: Style(
              $flex.gap(8),
              $flex.crossAxisAlignment.stretch()
            ),
            children: [
              for (var pageState in pageStates) LibraButton(
                style: Style(
                  ButtonSpecUtility.self.flex.mainAxisAlignment.start(),
                  ButtonSpecUtility.self.label.overflow.ellipsis()
                ),
                variant: pageState.uuid == currentPageUuid ? ButtonVariant.outlined : ButtonVariant.normal,
                label: pageState.uri.isNotEmpty ? pageState.uri : "New Tab",
                onPressed: () => repo.switchCurrentPage(pageState),
              ),
              LibraButton(
                style: Style(
                  ButtonSpecUtility.self.flex.mainAxisAlignment.start(),
                  ButtonSpecUtility.self.label.overflow.ellipsis()
                ),
                variant: ButtonVariant.normal,
                label: 'New tab',
                icon: LucideIcons.plus,
                onPressed: () => repo.openNewPage(),
              )
            ]
          );
        }
      )
    );
  }
}