import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:todolist_with_riverpod/constants/colors.dart';
import 'package:todolist_with_riverpod/constants/numbers.dart';
import 'package:todolist_with_riverpod/constants/strings.dart';
import 'package:todolist_with_riverpod/data/domain/task.dart';
import 'package:todolist_with_riverpod/providers/task_provider.dart';
import 'package:todolist_with_riverpod/providers/task_state.dart';

//Representation du logo
Widget logo(){
  return Container(
    decoration: const BoxDecoration(
      color: primary,
      borderRadius: BorderRadius.all(Radius.circular(radiusLogo)),
    ),
    padding: const EdgeInsets.all(paddingLogo),
    width: logoSize,
    height: logoSize,
    child: const Column(
      children: [
        Icon(
          Icons.task_alt,
          color: secondary,
        ),
        Text(
          appName,
          style: TextStyle(color: secondary,fontSize: 10),
        )
      ],
    )
  );
}

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
   
  } else {
    return Center(
      child: Text("Echec de connexion à la source de données"),
    );
  }
}

Widget texEditingField(
    {
      required BuildContext context,
      required  TextEditingController ctrl,
      required String label,
      required int maxLines,
      required FocusNode focusNode,
      required TextInputAction textInputAction,
      required void Function(String value) onChanged,
      required String? Function(String?) validator,
      required void Function(String) onFieldSubmitted,
      bool focused=false
    })
{
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(label,style: Theme.of(context).textTheme.headlineSmall,),
      TextFormField(
      controller: ctrl,
      maxLines: maxLines,
      autofocus: focused,
      cursorColor: primary,
      style: Theme.of(context).textTheme.bodyLarge,
      focusNode: focusNode,
      scrollPhysics: BouncingScrollPhysics(),
      textInputAction: textInputAction,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      decoration: InputDecoration(
        errorBorder: _inputBorder(borderColor: danger),
        enabledBorder: _inputBorder(borderColor: black),
        focusedBorder: _inputBorder(borderColor: primary),
        focusedErrorBorder: _inputBorder(borderColor: danger)),
      validator: validator,
      onChanged: onChanged,
      onFieldSubmitted: onFieldSubmitted)

  ],);

}

Future<void> toastMessage({required BuildContext context, required String message, required Color color}) async{

  await Flushbar(
      flushbarPosition: FlushbarPosition.TOP,
      duration: Duration(seconds: 3),
      margin: EdgeInsets.all(5),
      backgroundColor: color,
      borderRadius: BorderRadius.circular(8),
      mainButton: IconButton(
        onPressed: () {
          context.pop();
        },
        icon: Icon(Icons.close,color: secondary,),
      ),
      message: message,
  ).show(context);
}

ElevatedButton elevatedButton(
  {required String label,
    required VoidCallback? action,
    Color? background,
    required icon,
    required iconColor,
    required colorText,
    Color borderColor=primary
  }){
  return ElevatedButton.icon(
    style: ElevatedButton.styleFrom(
      backgroundColor: background,
      side: BorderSide(color: borderColor)
    ),
    icon: Icon(icon,color: iconColor,),
    onPressed: action,
    label: Text(label,style: TextStyle(color: colorText),),
  );
}


OutlineInputBorder _inputBorder({required Color borderColor}){
  return OutlineInputBorder(
    borderSide: BorderSide(
      width: borderSideTextInput,
      color: borderColor
    ),
    borderRadius: BorderRadius.all(Radius.circular(roundedTextInput)),
  );
}


Widget _taskItem(BuildContext context,Task task,VoidCallback actionIconButton){
  return Card(

    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(roundedCardTask),
    ),
    color: secondary,
    elevation: 5,
    child: ListTile(
      onTap: (){},
      contentPadding: const EdgeInsets.symmetric(vertical: 9,horizontal: 9),
      subtitle: Text(task.desc,
        overflow: TextOverflow.visible,
        maxLines: 2
        ,style: Theme.of(context).textTheme.bodyMedium,),
      leading: _leftVerticalBarTask(task),
      title:Text("${task.name}",style: Theme.of(context).textTheme.headlineMedium,),
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