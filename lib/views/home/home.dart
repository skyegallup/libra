import 'package:flutter/widgets.dart';
import 'package:libra/data/loading_state.dart';
import 'package:libra/data/page_state_repository.dart';
import 'package:libra/utils/themes/theme_tokens.dart';
import 'package:libra/widgets/button/button.dart';
import 'package:libra/widgets/button/button_variants.dart';
import 'package:libra/widgets/loading_bar.dart';
import 'package:libra/widgets/page.dart';
import 'package:libra/widgets/sidebar/sidebar.dart';
import 'package:libra/widgets/text_field/text_field.dart';
import 'package:libra/widgets/text_field/text_field_spec.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:mix/mix.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _urlController = TextEditingController();

  Map<LoadingState, double> loadingStateToLoadingBarMap = {
    LoadingState.idle:         0.00,
    LoadingState.connecting:   0.15,
    LoadingState.dataTransfer: 0.30,
    LoadingState.complete:     1.00
  };

  @override
  Widget build(BuildContext context) {
    // Build view
    return VBox(
      style: Style(
        $box.color(Color.fromRGBO(29, 29, 34, 1)),
        $flex.crossAxisAlignment.stretch(),
        $flex.mainAxisSize.max()
      ),
      children: [
        // Action bar
        VBox(
          children: [
            // Action bar items
            HBox(
              style: Style(
                $box.padding(12, 24),
                $box.color.ref($tok.color.primary),

                $flex.mainAxisAlignment.center(),
                $flex.crossAxisAlignment.center(),
                $flex.gap(8)
              ),
              children: [
                LibraButton(
                  variant: ButtonVariant.primary,
                  label: '',
                  icon: LucideIcons.refreshCw,
                  onPressed: () {
                    final repo = Provider.of<PageStateRepository>(context, listen: false);
                    repo.navigatePage(repo.currentPageState, repo.currentPageState.uri);
                  },
                ),
                Consumer<PageStateRepository>(  // TODO: Make data models immutable so that we can use Selector for better performance
                  builder: (context, repo, child) => LibraTextField(
                    defaultValue: repo.currentPageState.uri,
                    controller: _urlController,
                    style: Style(
                      TextFieldSpecUtility.self.container.color.ref($tok.color.primaryDark),
                      TextFieldSpecUtility.self.container.width(720)
                    ),
                    onSubmitted: (value) => repo.navigatePage(repo.currentPageState, value)
                  ),
                )
              ]
            ),

            Consumer<PageStateRepository>(
              builder: (context, repo, child) {
                // TODO: Consider moving this logic into LibraLoadingBar or a subclass thereof
                final loadingState = repo.currentPageState.loadingState;
                final fillAmount = loadingStateToLoadingBarMap[loadingState] ?? 0.0;
                final showLoadingBar = loadingState != LoadingState.complete;

                return LibraLoadingBar(
                  fillAmount: fillAmount,
                  show: showLoadingBar,
                );
              }
            )
          ]
        ),

        // Main section
        HBox(
          style: Style(
            $flex.crossAxisAlignment.stretch(),
            $with.expanded()
          ),
          children: [
            Sidebar(),
            Consumer<PageStateRepository>(
              builder: (context, repo, child) => LibraPage(
                pageState: repo.currentPageState  // TODO: This might work with Selector as-is?
              )
            )
          ]
        )
      ]
    );
  }
}
