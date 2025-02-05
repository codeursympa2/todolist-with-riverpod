import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:todolist_with_riverpod/constants/colors.dart';
import 'package:todolist_with_riverpod/constants/numbers.dart';
import 'package:todolist_with_riverpod/data/domain/task.dart';
import 'package:todolist_with_riverpod/providers/task_provider.dart';
import 'package:todolist_with_riverpod/providers/task_state.dart';
import 'package:todolist_with_riverpod/utils/refactoring.dart';

Widget contentHomePage(TaskState state,WidgetRef ref){
  if (state is TaskInitialState) {
    return Container();
  } else if (state is TaskLoadingState) {
    return Center(
      child: const CircularProgressIndicator(),
    );
  } else if (state is TaskEmptyState) {
    return Center(child: Text(state.error));
  } else if (state is TaskLoadedState) {
    return ListView.builder(
      itemCount: state.todos.length,
      itemBuilder: (context, index) {
        // Utilisez l'état chargé pour afficher les tâches
        var task=state.todos[index];
        return Dismissible(
            key: Key(task.id.toString()),
            direction: DismissDirection.startToEnd,
            onDismissed: (direction) async {
              //suppression
              ref.read(taskProvider.notifier).deleteTask(task);
            },
            background: Container(
              color: danger,
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: Icon(
                Icons.delete_forever,
                color: Colors.white,
                size: 30.0,
              ),
            ),
            child: _taskItem(context, task,(){
              //Mise à jour état de la tâche
              task.isCompleted= task.isCompleted == 1 ? 0 :1 ;
              ref.read(taskProvider.notifier).updateTaskIsCompleted(task);
            }));
      },
    );

  } else{
    return Center(
      child: const CircularProgressIndicator(),
    );
  }
}

Widget _taskItem(BuildContext context,Task task,VoidCallback actionIconButton){
  return Card(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(roundedCardTask),
    ),
    color: secondary,
    elevation: 5,
    child: ListTile(
      onTap: (){
        context.goNamed('update', pathParameters: {'id': task.id.toString()});
      },
      contentPadding: const EdgeInsets.symmetric(vertical: 9,horizontal: 9),
      subtitle: Text(truncateString(task.desc, 60),
        overflow: TextOverflow.visible,
        maxLines: 2
        ,style: Theme.of(context).textTheme.bodyMedium,),
      leading: _leftVerticalBarTask(task),
      title:Text("${truncateString(task.name, 25)}",style: Theme.of(context).textTheme.headlineMedium,),
      trailing: _iconTaskCardTransition(task,actionIconButton ),
    ),
  );
}

Widget _iconTaskCardTransition(Task task,VoidCallback action){
  if(task.isCompleted == 1){
    return _iconButton(action, primary);
  }else{
    return _iconButton(action, shadow);
  }
}

Widget _iconButton(VoidCallback action,Color color){
  return IconButton(
    onPressed: action,
    icon: Icon(Icons.check_circle,color: color,size: iconTaskItem,),
  );
}

Widget _leftVerticalBarTask(Task task){
  return Container(
    width: 5,
    decoration: BoxDecoration(
        borderRadius: BorderRadius.all(
            Radius.circular(roundedCardTask)
        ),
        color: task.isCompleted == 1 ? primary : shadow
    ),
  );
}