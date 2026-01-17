import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';

import '../utils/themes/theme_tokens.dart';

class LibraLoadingBar extends StatelessWidget {
  const LibraLoadingBar({
    super.key,
    required this.fillAmount,
    this.show = true
  });

  final double fillAmount;
  final bool show;

  @override
  Widget build(BuildContext context) {
    return Box(
      style: Style(
        $box.width.infinity(),
        $box.height(2),
        $box.color.ref($tok.color.gray),
        $box.alignment.directional.topStart()
      ),
      child: AnimatedOpacity(
        opacity: show ? 1.0 : 0.0,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeOut,
        child: Box(
          style: Style(
            $box.color.ref($tok.color.primaryLight)
          ),
          child: AnimatedSize(
            duration: Duration(milliseconds: 300),
            curve: Curves.easeOut,
            child: FractionallySizedBox(
              widthFactor: fillAmount,
              heightFactor: 1.0,
              alignment: FractionalOffset.topLeft
            )
          )
        )
      )
    );
  }
}
