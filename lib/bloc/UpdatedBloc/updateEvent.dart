import 'package:flutter/material.dart';

@immutable
abstract class UpdationEvent {}

class UpdateData extends UpdationEvent {}

class UpdatingProgress extends UpdationEvent {
  final int completedTasks;

  UpdatingProgress(this.completedTasks);
}

class UpdatingTaskStatus extends UpdationEvent {
  final int taskIndex;
  final String status;

  UpdatingTaskStatus(this.taskIndex, this.status);
}
