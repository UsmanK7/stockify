import 'package:flutter/material.dart';
import 'package:okra_distributer/payment/views/apicheckingScreen.dart';

@immutable
abstract class CompletionState {}

class InitialState extends CompletionState {}

class LoadingState extends CompletionState {
  final double progress;
  final List<TaskStatus> taskStatuses;

  LoadingState(this.progress, this.taskStatuses);
}

class SuccessState extends CompletionState {}

class FailureState extends CompletionState {
  final String error;

  FailureState(this.error);
}
