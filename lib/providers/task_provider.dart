import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todolist_with_riverpod/data/domain/task.dart';
import 'package:todolist_with_riverpod/data/services/database_service.dart';
import 'package:todolist_with_riverpod/providers/task_state.dart';

final Provider<DatabaseService> databaseService = Provider((ref) => DatabaseService.instance);

final taskProvider = StateNotifierProvider<TaskNotifier, TaskState>(
      (ref) => TaskNotifier(ref),
);


class TaskNotifier extends StateNotifier<TaskState> {
  final Ref ref;
  final DatabaseService _service;
  late final int resultQuery;

  static const errorMessage = "Echec du traitement de la requête.";

  TaskNotifier(this.ref)
      : _service = ref.read(databaseService),
        super(TaskInitialState()){
    //à l'appel on charge les données
    getTasks();
  }

  Future<void> getTasks() async {
    state = TaskLoadingState();

    try {
      // Simulation de chargement de 2 secondes de la barre de progression
      await Future.delayed(const Duration(seconds: 2));

      // Traitement de la requête
      final taskList = await _service.getAllTasks();

      if (taskList.isEmpty) {
        state = TaskEmptyState("Pas de tâches disponibles.");
      } else {
        state = TaskLoadedState(todos: taskList);
      }
    } catch (e) {
      state = TaskFailureState(errorMessage);
    }
  }

  Future<void> saveTask(Task task) async {
    late final String typeOperation;
    try {
      if (task.id == null) {
        resultQuery = await _service.addTask(task);
        typeOperation="ajoutée";
      } else {
        resultQuery = await _service.updateTask(task);
        typeOperation="modifiée";
      }

      if (resultQuery == 1) state = TaskSuccessState("Tâche $typeOperation");
    } catch (e) {
      state = TaskFailureState(errorMessage);
      throw Exception();
    }
  }

  Future<void> deleteTask(Task task)async{
    try{
      resultQuery= await this._service.deleteTask(task);
      if(resultQuery == 1) state=TaskSuccessState("Tâche supprimée");
    }catch(e){
      state = TaskFailureState(errorMessage);
      throw Exception();
    }
  }

  void disposeResources() {
    // Logique pour libérer les ressources
    _service.closeConnexion();
  }
}
