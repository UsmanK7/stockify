import 'package:flutter/material.dart';

@immutable
abstract class CompletionEvent {}

class FetchData extends CompletionEvent {}

class UpdateProgress extends CompletionEvent {
  final int completedTasks;

  UpdateProgress(this.completedTasks);
}

class UpdateTaskStatus extends CompletionEvent {
  final int taskIndex;
  final String status;

  UpdateTaskStatus(this.taskIndex, this.status);
}
