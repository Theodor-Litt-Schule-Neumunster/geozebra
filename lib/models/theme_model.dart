import 'package:flutter/material.dart';

@immutable
class TaskColors extends ThemeExtension<TaskColors> {
  final Color uncompletedTask;
  final Color completedTask;

  const TaskColors({
    required this.uncompletedTask,
    required this.completedTask,
  });

  @override
  TaskColors copyWith({Color? uncompletedTask, Color? completedTask}) {
    return TaskColors(
      uncompletedTask: uncompletedTask ?? this.uncompletedTask,
      completedTask: completedTask ?? this.completedTask,
    );
  }

  @override
  TaskColors lerp(ThemeExtension<TaskColors>? other, double t) {
    if (other is! TaskColors) return this;
    return TaskColors(
      uncompletedTask: Color.lerp(uncompletedTask, other.uncompletedTask, t)!,
      completedTask: Color.lerp(completedTask, other.completedTask, t)!,
    );
  }
}