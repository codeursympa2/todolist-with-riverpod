import 'package:flutter/material.dart';
import 'package:todolist_with_riverpod/constants/colors.dart';
import 'package:todolist_with_riverpod/constants/numbers.dart';
import 'package:todolist_with_riverpod/constants/strings.dart';
import 'package:todolist_with_riverpod/providers/task_state.dart';

//Representation du logo
Widget logo(){
  return Container(
    decoration: const BoxDecoration(
      color: primary,
      borderRadius: BorderRadius.all(Radius.circular(40)),
    ),
    padding: const EdgeInsets.all(7),
    width: logoSize,
    height: logoSize,
    child: const Column(
      children: [
        Icon(
          Icons.task_alt,
          color: accent,
        ),
        Text(
          appName,
          style: TextStyle(color: secondary,fontSize: 10),
        )
      ],
    )
  );
}

Widget contentHomePage(state){
  if (state is TaskInitialState) {
    return Container();
  } else if (state is TaskLoadingState) {
    return Center(
      child: const CircularProgressIndicator(),
    );
  } else if (state is TaskEmptyState) {
    return Center(child: Text(state.error));
  } else if (state is TaskLoadedState) {
    // Utilisez l'état chargé pour afficher les tâches
    return ListView.builder(
      itemCount: state.todos.length,
      itemBuilder: (context, index) {
        final task = state.todos[index];
        return ListTile(
          title: Text(task.name),
        );
      },
    );
  } else {
    return Center(
      child: Text("Echec de connexion à la source de données"),
    );
  }
}