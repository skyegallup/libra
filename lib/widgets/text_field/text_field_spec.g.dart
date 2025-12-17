// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'text_field_spec.dart';

// **************************************************************************
// MixGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND

/// A mixin that provides spec functionality for [TextFieldSpec].
mixin _$TextFieldSpec on Spec<TextFieldSpec> {
  static TextFieldSpec from(MixContext mix) {
    return mix.attributeOf<TextFieldSpecAttribute>()?.resolve(mix) ??
        const TextFieldSpec();
  }

  /// {@template text_field_spec_of}
  /// Retrieves the [TextFieldSpec] from the nearest [ComputedStyle] ancestor in the widget tree.
  ///
  /// This method uses [ComputedStyle.specOf] for surgical rebuilds - only widgets
  /// that call this method will rebuild when [TextFieldSpec] changes, not when other specs change.
  /// If no ancestor [ComputedStyle] is found, this method returns an empty [TextFieldSpec].
  ///
  /// Example:
  ///
  /// ```dart
  /// final textFieldSpec = TextFieldSpec.of(context);
  /// ```
  /// {@endtemplate}
  static TextFieldSpec of(BuildContext context) {
    return ComputedStyle.specOf<TextFieldSpec>(context) ??
        const TextFieldSpec();
  }

  /// Creates a copy of this [TextFieldSpec] but with the given fields
  /// replaced with the new values.
  @override
  TextFieldSpec copyWith({
    BoxSpec? container,
    TextSpec? value,
    AnimatedData? animated,
  }) {
    return TextFieldSpec(
      container: container ?? _$this.container,
      value: value ?? _$this.value,
      animated: animated ?? _$this.animated,
    );
  }

  /// Linearly interpolates between this [TextFieldSpec] and another [TextFieldSpec] based on the given parameter [t].
  ///
  /// The parameter [t] represents the interpolation factor, typically ranging from 0.0 to 1.0.
  /// When [t] is 0.0, the current [TextFieldSpec] is returned. When [t] is 1.0, the [other] [TextFieldSpec] is returned.
  /// For values of [t] between 0.0 and 1.0, an interpolated [TextFieldSpec] is returned.
  ///
  /// If [other] is null, this method returns the current [TextFieldSpec] instance.
  ///
  /// The interpolation is performed on each property of the [TextFieldSpec] using the appropriate
  /// interpolation method:
  /// - [BoxSpec.lerp] for [container].
  /// - [TextSpec.lerp] for [value].
  /// For [animated], the interpolation is performed using a step function.
  /// If [t] is less than 0.5, the value from the current [TextFieldSpec] is used. Otherwise, the value
  /// from the [other] [TextFieldSpec] is used.
  ///
  /// This method is typically used in animations to smoothly transition between
  /// different [TextFieldSpec] configurations.
  @override
  TextFieldSpec lerp(TextFieldSpec? other, double t) {
    if (other == null) return _$this;

    return TextFieldSpec(
      container: _$this.container.lerp(other.container, t),
      value: _$this.value.lerp(other.value, t),
      animated: _$this.animated ?? other.animated,
    );
  }

  /// The list of properties that constitute the state of this [TextFieldSpec].
  ///
  /// This property is used by the [==] operator and the [hashCode] getter to
  /// compare two [TextFieldSpec] instances for equality.
  @override
  List<Object?> get props => [_$this.container, _$this.value, _$this.animated];

  TextFieldSpec get _$this => this as TextFieldSpec;
}

/// Represents the attributes of a [TextFieldSpec].
///
/// This class encapsulates properties defining the layout and
/// appearance of a [TextFieldSpec].
///
/// Use this class to configure the attributes of a [TextFieldSpec] and pass it to
/// the [TextFieldSpec] constructor.
class TextFieldSpecAttribute extends SpecAttribute<TextFieldSpec> {
  final BoxSpecAttribute? container;
  final TextSpecAttribute? value;

  const TextFieldSpecAttribute({this.container, this.value, super.animated});

  /// Resolves to [TextFieldSpec] using the provided [MixContext].
  ///
  /// If a property is null in the [MixContext], it falls back to the
  /// default value defined in the `defaultValue` for that property.
  ///
  /// ```dart
  /// final textFieldSpec = TextFieldSpecAttribute(...).resolve(mix);
  /// ```
  @override
  TextFieldSpec resolve(MixContext mix) {
    return TextFieldSpec(
      container: container?.resolve(mix),
      value: value?.resolve(mix),
      animated: animated?.resolve(mix) ?? mix.animation,
    );
  }

  /// Merges the properties of this [TextFieldSpecAttribute] with the properties of [other].
  ///
  /// If [other] is null, returns this instance unchanged. Otherwise, returns a new
  /// [TextFieldSpecAttribute] with the properties of [other] taking precedence over
  /// the corresponding properties of this instance.
  ///
  /// Properties from [other] that are null will fall back
  /// to the values from this instance.
  @override
  TextFieldSpecAttribute merge(TextFieldSpecAttribute? other) {
    if (other == null) return this;

    return TextFieldSpecAttribute(
      container: container?.merge(other.container) ?? other.container,
      value: value?.merge(other.value) ?? other.value,
      animated: animated?.merge(other.animated) ?? other.animated,
    );
  }

  /// The list of properties that constitute the state of this [TextFieldSpecAttribute].
  ///
  /// This property is used by the [==] operator and the [hashCode] getter to
  /// compare two [TextFieldSpecAttribute] instances for equality.
  @override
  List<Object?> get props => [container, value, animated];
}

/// Utility class for configuring [TextFieldSpec] properties.
///
/// This class provides methods to set individual properties of a [TextFieldSpec].
/// Use the methods of this class to configure specific properties of a [TextFieldSpec].
class TextFieldSpecUtility<T extends SpecAttribute>
    extends SpecUtility<T, TextFieldSpecAttribute> {
  /// Utility for defining [TextFieldSpecAttribute.container]
  late final container = BoxSpecUtility((v) => only(container: v));

  /// Utility for defining [TextFieldSpecAttribute.value]
  late final value = TextSpecUtility((v) => only(value: v));

  /// Utility for defining [TextFieldSpecAttribute.animated]
  late final animated = AnimatedUtility((v) => only(animated: v));

  TextFieldSpecUtility(
    super.builder, {
    @Deprecated(
      'mutable parameter is no longer used. All SpecUtilities are now mutable by default.',
    )
    super.mutable,
  });

  @Deprecated(
    'Use "this" instead of "chain" for method chaining. '
    'The chain getter will be removed in a future version.',
  )
  TextFieldSpecUtility<T> get chain => TextFieldSpecUtility(attributeBuilder);

  static TextFieldSpecUtility<TextFieldSpecAttribute> get self =>
      TextFieldSpecUtility((v) => v);

  /// Returns a new [TextFieldSpecAttribute] with the specified properties.
  @override
  T only({
    BoxSpecAttribute? container,
    TextSpecAttribute? value,
    AnimatedDataDto? animated,
  }) {
    return builder(
      TextFieldSpecAttribute(
        container: container,
        value: value,
        animated: animated,
      ),
    );
  }
}

/// A tween that interpolates between two [TextFieldSpec] instances.
///
/// This class can be used in animations to smoothly transition between
/// different [TextFieldSpec] specifications.
class TextFieldSpecTween extends Tween<TextFieldSpec?> {
  TextFieldSpecTween({super.begin, super.end});

  @override
  TextFieldSpec lerp(double t) {
    if (begin == null && end == null) {
      return const TextFieldSpec();
    }

    if (begin == null) {
      return end!;
    }

    return begin!.lerp(end!, t);
  }
}
