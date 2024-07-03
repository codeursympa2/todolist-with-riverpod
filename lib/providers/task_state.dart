import 'package:todolist_with_riverpod/data/domain/task.dart';

abstract class TaskState {
  const TaskState();
}

// Etat initial
class TaskInitialState extends TaskState {
  const TaskInitialState();
}

// En chargement récupération des tasks
class TaskLoadingState extends TaskState {
  const TaskLoadingState();
}

// Fin récupération de la liste
class TaskLoadedState extends TaskState {
  final List<Task> todos;

  const TaskLoadedState({required this.todos});
}

// Pas de taches
class TaskEmptyState extends TaskState {
  final String error;

  const TaskEmptyState(this.error);
}

// Etat de succès après une opération
class TaskSuccessState extends TaskState {
  final String message;
  const TaskSuccessState(this.message);
}

// Etat d'échec avec un message d'erreur
class TaskFailureState extends TaskState {
  final String error;

  const TaskFailureState(this.error);
}

//Etat edition task
class TaskEditingState extends TaskState{
  final Task task;
  const TaskEditingState({required this.task});
}
