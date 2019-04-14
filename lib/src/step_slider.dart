import 'package:flutter/material.dart';
import 'package:step_slider/src/snap_mode.dart';
import 'package:step_slider/src/snapper.dart';
import 'package:step_slider/step_slider.dart';

class StepSlider extends StatefulWidget {
  StepSlider({
    Key key,
    this.sliderKey,
    @required this.steps,
    this.initialStep,
    this.onStepChanged,
    this.snapMode,
    this.hardSnap: false,
    this.animCurve: Curves.fastLinearToSlowEaseIn,
    this.animDuration: const Duration(milliseconds: 500),
    this.min: 0.0,
    this.max: 1.0,
    this.label,
    this.divisions,
    this.onChanged,
    this.onChangeEnd,
    this.onChangeStart,
    this.activeColor,
    this.inactiveColor,
    this.semanticFormatterCallback,
  })  : assert(steps != null && steps.isNotEmpty,
            'There needs to be at least one step.'),
        assert(steps.every((it) => it >= min && it <= max),
            'Each step needs to be within slider values range.'),
        assert(initialStep == null || steps.contains(initialStep),
            'Initial step does not correspond to any of slider steps.'),
        super(key: key);

  // Key object passed to internal slider widget.
  final Key sliderKey;

  /// Slider values that the widget will snap to.
  final Set<double> steps;

  /// Slider value used when the widget's state is created for the first time.
  final double initialStep;

  /// Callback function invoked every time slider value gets snapped to adjacent step.
  final ValueChanged<double> onStepChanged;

  /// Whether the widget should display only step values or all the values
  /// between [min] and [max] (but won't snap to them regardless).
  final bool hardSnap;

  /// Modifies the way in which slider will snap to steps:
  /// * value - snaps to step if the value becomes less or equals to given value.
  /// * percent - snaps to step if the value becomes less or equals to given percent of [min]-to-[max] range.
  /// * stretch - snaps to step that is closest to slider's current value.
  final SnapMode snapMode;

  /// Slider's value animation curve.
  final Curve animCurve;

  /// Slider's value animation duration.
  final Duration animDuration;

  /// See [Slider.min].
  final double min;

  /// See [Slider.max].
  final double max;

  /// See [Slider.label].
  final String label;

  /// See [Slider.divisions].
  final int divisions;

  /// See [Slider.activeColor].
  final Color activeColor;

  /// See [Slider.inactiveColor].
  final Color inactiveColor;

  /// See [Slider.onChanged].
  final ValueChanged<double> onChanged;

  /// See [Slider.onChangeEnd].
  final ValueChanged<double> onChangeEnd;

  /// See [Slider.onChangeStart].
  final ValueChanged<double> onChangeStart;

  /// See [Slider.semanticFormatterCallback].
  final SemanticFormatterCallback semanticFormatterCallback;

  @override
  _StepSliderState createState() => _StepSliderState();
}

class _StepSliderState extends State<StepSlider>
    with SingleTickerProviderStateMixin {
  AnimationController _animator;
  Animation<double> _animation;
  double _currentStep;
  Snapper _snapper;

  @override
  void didUpdateWidget(StepSlider oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.snapMode != widget.snapMode) {
      _updateSnapper();
    }
  }

  @override
  void initState() {
    super.initState();
    _animator = AnimationController(vsync: this, duration: widget.animDuration);
    _currentStep = widget.initialStep ?? widget.steps.first;
    _animateTo(_currentStep, restart: false);
    _updateSnapper();
  }

  void _updateSnapper() {
    _snapper = (widget.snapMode ?? SnapMode.stretch())
        .snapperFor(widget.steps.toList(), widget.min, widget.max);
  }

  @override
  void dispose() {
    _animator.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (_, __) => Slider(
            key: widget.sliderKey,
            min: widget.min,
            max: widget.max,
            label: widget.label,
            divisions: widget.divisions,
            activeColor: widget.activeColor,
            inactiveColor: widget.inactiveColor,
            semanticFormatterCallback: widget.semanticFormatterCallback,
            value: _animation.value.clamp(widget.min, widget.max),
            onChangeStart: (it) {
              _onSliderChangeStart(it);
              widget.onChangeStart?.call(it);
            },
            onChangeEnd: (it) {
              _onSliderChangeEnd(it);
              widget.onChangeEnd?.call(it);
            },
            onChanged: (it) {
              _onSliderChanged(it);
              widget.onChanged?.call(it);
            },
          ),
    );
  }

  void _onSliderChangeStart(double value) {
    if (!widget.hardSnap) {
      _animateTo(value, restart: true);
    }
  }

  void _onSliderChangeEnd(double value) {
    if (!widget.hardSnap) {
      _animateTo(_currentStep, restart: true);
    }
  }

  void _onSliderChanged(double value) {
    if (!widget.hardSnap) {
      setState(() => _animateTo(value, restart: false));
    }
    final step = _snapper.snap(value);
    if (step != null && step != _currentStep) {
      _onStepChanged(step);
    }
  }

  void _onStepChanged(double step) {
    _currentStep = step;
    if (widget.hardSnap) {
      setState(() => _animateTo(_currentStep, restart: true));
    }
    widget.onStepChanged?.call(_currentStep);
  }

  void _animateTo(double end, {bool restart}) {
    _animation = Tween(begin: _animation?.value ?? end, end: end)
        .chain(CurveTween(curve: widget.animCurve))
        .animate(_animator);
    if (restart) {
      _animator.forward(from: 0.0);
    }
  }
}
