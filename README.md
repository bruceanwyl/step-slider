# step_slider

Flutter slider widget that snaps to given step values and notifies about step changes.

![StepSlider demo](https://giant.gfycat.com/LongFailingDowitcher.gif)

## Getting Started

Add StepSlider to your widget tree along with needed custom arguments:

```dart
@override
Widget build(BuildContext context) {
    ...
    child: StepSlider(
        min: 100.0,
        max: 200.0,
        steps: {110, 150, 160, 195},
        initialStep: 150,
        animCurve: Curves.bounceInOut,
        animDuration: Duration(seconds: 1),
        snapMode: SnapMode.value(10),
        hardSnap: true,
        onStepChanged: (it) => print('Step changed to $it.'),
        // ... slider's other args
    ),
}
```
