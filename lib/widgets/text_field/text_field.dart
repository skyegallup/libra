import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:libra/utils/themes/theme_tokens.dart';
import 'package:libra/widgets/text_field/text_field_spec.dart';
import 'package:libra/widgets/text_field/text_field_styles.dart';
import 'package:mix/mix.dart';

class LibraTextField extends StatefulWidget {
  const LibraTextField({
    super.key,
    this.onChanged,
    this.onSubmitted,
    this.style
  });

  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final Style? style;

  @override
  State<LibraTextField> createState() => _LibraTextField();
}

class _LibraTextField extends State<LibraTextField> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  String _value = '';

  String getValue() {
    return _value;
  }

  @override
  void initState() {
    super.initState();

    _controller.addListener(() {
      final newValue = _controller.text;
      if (newValue != _value) {
        setState(() {
          _value = newValue;
        });
        if (widget.onChanged != null) {
          widget.onChanged!(_controller.text);
        }
      }
    });
  }

  @override
  void dispose() {
    super.dispose();

    _controller.dispose();
    _focusNode.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FormField<String>(
      key: Key("field"),
      builder: (FormFieldState<String> field) => SpecBuilder(
        style: textFieldStyle(widget.style),
        builder: (context) {
          final textField = TextFieldSpec.of(context);
          return textField.container(
            child: EditableText(
              controller: _controller,
              focusNode: _focusNode,
              style: TextStyle(),
              cursorColor: $tok.color.primaryLighter.resolve(context),
              backgroundCursorColor: $tok.color.grayDarker.resolve(context),
              selectionColor: $tok.color.primary.resolve(context),
              onSubmitted: widget.onSubmitted,
            )
          );
        }
      )
    );
  }
}
