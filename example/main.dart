import 'package:flutter/material.dart';
import 'package:step_slider/slider.dart';

void main() => runApp(SliderExample());

class SliderExample extends StatefulWidget {
  @override
  _SliderExampleState createState() => _SliderExampleState();
}

class _SliderExampleState extends State<SliderExample> {
  double _currentStep = 150.0;
  SnapMode _snapMode = SnapMode.stretch();
  bool _hardSnap = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'StepSlider example',
      home: Scaffold(
        appBar: AppBar(title: Text('StepSlider example')),
        body: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(children: <Widget>[
            StepSlider(
              min: 100.0,
              max: 200.0,
              steps: {110, 150, 160, 195},
              initialStep: _currentStep,
              animCurve: Curves.ease,
              animDuration: Duration(seconds: 1),
              snapMode: _snapMode,
              hardSnap: _hardSnap,
              onStepChanged: (it) {
                setState(() => _currentStep = it);
              },
              // ... slider's other args
            ),
            Center(child: Text('Current step: $_currentStep')),
            Container(height: 32.0),
            Row(mainAxisSize: MainAxisSize.min, children: <Widget>[
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 32.0),
                child: Center(child: Text('Hard snap')),
              ),
              Switch(
                value: _hardSnap,
                onChanged: (it) {
                  setState(() => _hardSnap = it);
                },
              )
            ]),
            Container(height: 16.0),
            Row(mainAxisSize: MainAxisSize.min, children: <Widget>[
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 32.0),
                child: Center(child: Text('Snap mode')),
              ),
              DropdownButton<SnapMode>(
                value: _snapMode,
                onChanged: (it) {
                  setState(() => _snapMode = it);
                },
                items: [
                  DropdownMenuItem(
                    value: SnapMode.value(5),
                    child: Text('Value'),
                  ),
                  DropdownMenuItem(
                    value: SnapMode.percent(10),
                    child: Text('Percent'),
                  ),
                  DropdownMenuItem(
                    value: SnapMode.stretch(),
                    child: Text('Stretch'),
                  ),
                ],
              )
            ]),
          ]),
        ),
      ),
    );
  }
}
