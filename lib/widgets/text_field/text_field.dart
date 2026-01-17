import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:libra/utils/themes/theme_tokens.dart';
import 'package:libra/widgets/text_field/text_field_spec.dart';
import 'package:libra/widgets/text_field/text_field_styles.dart';
import 'package:mix/mix.dart';

class LibraTextField extends StatefulWidget {
  const LibraTextField({
    super.key,
    this.defaultValue = '',
    this.controller,
    this.onChanged,
    this.onSubmitted,
    this.style
  });

  final String defaultValue;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final Style? style;

  @override
  State<LibraTextField> createState() => _LibraTextField();
}

class _LibraTextField extends State<LibraTextField> {
  final FocusNode _focusNode = FocusNode();

  late TextEditingController _controller;
  late bool _isOwnController;

  String _value = '';

  String getValue() {
    return _value;
  }

  @override
  void initState() {
    super.initState();

    _value = widget.defaultValue;
    if (widget.controller != null) {
      _controller = widget.controller!;
      _isOwnController = false;
    } else {
      _controller = TextEditingController();
      _isOwnController = true;
    }

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

    _focusNode.dispose();

    if (_isOwnController) {
      _controller.dispose();
    }
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
