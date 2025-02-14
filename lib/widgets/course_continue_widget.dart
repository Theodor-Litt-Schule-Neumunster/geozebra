import 'package:flutter/material.dart';

class CourseContinueWidget extends StatelessWidget {
  final List<String> courses;

  const CourseContinueWidget({super.key, required this.courses});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Continue',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        ...courses.map((course) => Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                color: Colors.grey[300],
                height: 100.0,
                width: double.infinity,
                child: Center(
                  child: Text(
                    course,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ),
              ),
            )),
      ],
    );
  }
}
