import 'package:flutter/material.dart';
import 'package:okra_distributer/payment/views/apicheckingScreen.dart';

@immutable
abstract class UpdationState {}

class FirstState extends UpdationState {}

class LoadingState extends UpdationState {
  final double progres;
  final List<TaskStatus> taskStatuses;

  LoadingState(this.progres, this.taskStatuses);
}

class SucessfulState extends UpdationState {}

class FailedDState extends UpdationState {
  final String error;

  FailedDState(this.error);
}
