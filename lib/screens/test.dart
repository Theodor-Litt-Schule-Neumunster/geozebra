import 'package:flutter/material.dart';

class StepperExample extends StatefulWidget {
  @override
  _StepperExampleState createState() => _StepperExampleState();
}

class _StepperExampleState extends State<StepperExample> {
  int _currentStep = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Stepper Example')),
      body: Stepper(
        type: StepperType.vertical, // Can be StepperType.horizontal too
        currentStep: _currentStep,
        onStepContinue: () {
          if (_currentStep < 3) { // Change 3 to the number of steps you have
            setState(() {
              _currentStep += 1;
            });
          }
        },
        onStepCancel: () {
          if (_currentStep > 0) {
            setState(() {
              _currentStep -= 1;
            });
          }
        },
        steps: [
          Step(
            title: const Text('Step 1: Install Flutter'),
            content: const Text('Download and install Flutter SDK.'),
            isActive: _currentStep >= 0,
            state: _currentStep > 0 ? StepState.complete : StepState.indexed,
          ),
          Step(
            title: const Text('Step 2: Set up Emulator'),
            content: const Text('Install and configure an emulator or a real device.'),
            isActive: _currentStep >= 1,
            state: _currentStep > 1 ? StepState.complete : StepState.indexed,
          ),
          Step(
            title: const Text('Step 3: Create Flutter Project'),
            content: const Text('Run `flutter create my_project` in your terminal.'),
            isActive: _currentStep >= 2,
            state: _currentStep > 2 ? StepState.complete : StepState.indexed,
          ),
          Step(
            title: const Text('Step 4: Run the App'),
            content: const Text('Use `flutter run` to launch your application.'),
            isActive: _currentStep >= 3,
            state: _currentStep > 3 ? StepState.complete : StepState.indexed,
          ),
        ],
      ),
    );
  }
}
