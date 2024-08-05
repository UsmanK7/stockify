import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:okra_distributer/bloc/UpdatedBloc/updateBloc.dart';
import 'package:okra_distributer/bloc/UpdatedBloc/updateEvent.dart';
import 'package:okra_distributer/bloc/UpdatedBloc/updateState.dart';

class UpdationScreen extends StatefulWidget {
  @override
  State<UpdationScreen> createState() => _UpdationScreenState();
}

class _UpdationScreenState extends State<UpdationScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => UpdationBloc()..add(UpdateData()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Updation Screen'),
        ),
        body: BlocBuilder<UpdationBloc, UpdationState>(
          builder: (context, state) {
            if (state is FirstState) {
              return const Center(child: Text("Initializing..."));
            } else if (state is LoadingState) {
              return Center(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(value: state.progres),
                      const SizedBox(height: 20),
                      Text(
                        "${(state.progres * 100).toStringAsFixed(0)}% Completed",
                        style: const TextStyle(fontSize: 18),
                      ),
                      ...state.taskStatuses.map((taskStatus) {
                        return ListTile(
                          title: Text(taskStatus.name),
                          subtitle: Text("Status: ${taskStatus.status}"),
                        );
                      }).toList(),
                    ],
                  ),
                ),
              );
            } else if (state is SucessfulState) {
              return const Center(
                  child: Text("All tasks completed successfully!"));
            } else if (state is FailedDState) {
              return Center(child: Text("Error: ${state.error}"));
            } else {
              return const Center(child: Text("Unexpected state"));
            }
          },
        ),
      ),
    );
  }
}

class TaskStatus {
  final String name;
  String status;

  TaskStatus({required this.name, required this.status});
}
