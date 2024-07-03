import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todolist_with_riverpod/constants/strings.dart';
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
  int resultQuery=0;

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
      await Future.delayed(const Duration(seconds: 1));
      //Recupération des données
      this._getDataWithChangeState();

    } catch (e) {
      state = TaskFailureState(errorMessage);
    }
  }

  Future<void> saveTask(Task task) async {
    late final String typeOperation;
    state=TaskLoadingState();
    try {
      if (task.id == null) {
        await _service.addTask(task);
        typeOperation="ajoutée";
      } else {
        await _service.updateTask(task.id!,task.toJsonUpdate());
        typeOperation="modifiée";
      }
      //On patiente 3 secondes pour pouvoir afficher la barre de progression
      await Future.delayed(Duration(seconds: 1),
              () => state = TaskSuccessState("Tâche $typeOperation."));

    } catch (e) {
      print(e);
      state = TaskFailureState(errorMessage);
      throw Exception();
    }
  }

  Future<void> deleteTask(Task task)async{
    try{
      await this._service.deleteTask(task);
      //On recharge les données
      _getDataWithChangeState();
      //Message
      state=TaskSuccessState("Tâche supprimée");
    }catch(e){
      state = TaskFailureState(errorMessage);
      throw Exception();
    }
  }

  void disposeResources() {
    // Logique pour libérer les ressources
    _service.closeConnexion();
  }

  //Valider/Invalider une tâche
  Future<void> updateTaskIsCompleted(Task task) async{
    //On fait la mise à jour en cliquant sur le bouton
    await _service.updateTask(task.id!,task.toJsonUpdateIsCompleted());
    //Rechargement des données
    await _getDataWithChangeState();
  }


  //Recuperation d'une tache
  Future<void> getTaskById(int id) async{
    final Task? task=await this._service.getTask(id);
    if(task != null){
      state=TaskEditingState(task: task);
    }else{
      state=TaskFailureState(errorGetTask);
    }
  }

  Future<void> _getDataWithChangeState() async{
    //On recupère la liste
    final taskList = await _service.getAllTasks();
    if(taskList.isNotEmpty){
      //On change l'etat
      state=TaskLoadedState(todos: taskList);
    }else{
      state=TaskEmptyState(noData);
    }
  }
}
