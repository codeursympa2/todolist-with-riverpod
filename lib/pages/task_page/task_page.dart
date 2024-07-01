import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:todolist_with_riverpod/constants/colors.dart';
import 'package:todolist_with_riverpod/data/domain/task.dart';
import 'package:todolist_with_riverpod/providers/form/task_form_state.dart';
import 'package:todolist_with_riverpod/providers/form/task_form_provider.dart';
import 'package:todolist_with_riverpod/providers/task_provider.dart';
import 'package:todolist_with_riverpod/providers/task_state.dart';

import '../../utils/common_widgets.dart';

class TaskPage extends ConsumerWidget {
  final String? id;
  const TaskPage(
      {this.id, //paramètres non obligatoire
      super.key,}
      );

  @override
  Widget build(BuildContext context,WidgetRef ref) {
    //On écoute les changements d'etats de TaskState
    ref.listen<TaskState>(taskProvider, (TaskState? previousState,TaskState state){
      if(state is TaskLoadingState){
        showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context){
              return Center(
                child: CircularProgressIndicator(backgroundColor: primary,color: secondary,),
              );
            }
        );
      }
      if (state is TaskSuccessState){
        context.go("/"); //retour sur home
        //Affichage du message
        toastMessage(context: context, message: state.message, color: primary);
      }

      if(state is TaskFailureState){
        toastMessage(context: context, message: state.error, color: danger);
      }




    });

    

    return  Scaffold(
      appBar: AppBar(
        title: Text(id != null ? "Mis à jour d'une tâche":"Création d'une tâche"),
      ),
      body: _FormContent(id:this.id),
    );
  }
}

class _FormContent extends ConsumerWidget{
  final String? id;
  _FormContent({this.id,Key? key}):super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final _formKey = GlobalKey<FormState>();
    final TextEditingController _nameController = TextEditingController();
    final TextEditingController _descController = TextEditingController();
    final FocusNode _nameFocusNode = FocusNode();
    final FocusNode _descFocusNode = FocusNode();

    if(id != null){
      //Apres recupération
    }else{
      _nameController.text="";
      _descController.text="";
    }
    return Padding(padding: EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Consumer(builder: (context,ref,child){
              final state =ref.watch(taskFormProvider);
              return texEditingField(
                  label: 'Nom',
                  focused: true,
                  textInputAction: TextInputAction.next,
                  focusNode: _nameFocusNode,
                  ctrl:_nameController,
                  maxLines: 1,
                  validator: (value){
                    //On check l'etat et on affiche le message d'erreur
                    if(state is TaskFormValidating){
                      if(state.formFieldsErrors!.nameFieldErrorMessage != ""){
                        return state.formFieldsErrors!.nameFieldErrorMessage;
                      }else{
                        return null;
                      }
                    }
                    return null;
                  },
                  onChanged:(value){
                    //Au changement on notifie et on envoie les data
                    ref.read(taskFormProvider.notifier).validForm(Task.withoutId(_nameController.text, _descController.text));
                  },
                  onFieldSubmitted: (value){}
              );

            }),
            SizedBox(height: 16),
            Consumer(builder: (context,ref,child){
              final state =ref.watch(taskFormProvider);
              return texEditingField(
                  label: 'Description',
                  focused: false,
                  textInputAction: TextInputAction.done,
                  focusNode: _descFocusNode,
                  ctrl:_descController,
                  maxLines: 5,
                  validator: (value){
                    //On check l'etat et on affiche le message d'erreur
                    if(state is TaskFormValidating){
                      if(state.formFieldsErrors!.descFieldErrorMessage != ""){
                        return state.formFieldsErrors!.descFieldErrorMessage;
                      }else{
                        return null;
                      }
                    }
                    return null;
                  },
                  onChanged:(value){
                    //Au changement on notifie et on envoie les data
                    ref.read(taskFormProvider.notifier).validForm(Task.withoutId(_nameController.text, _descController.text));
                  },
                  onFieldSubmitted: (value){
                    //Si le formulaire est valide
                    if(_formKey.currentState!.validate()){
                      Task t=Task.withoutId(_nameController.text, _descController.text);
                      FocusScope.of(context).unfocus(); //Suppression du focus sur le champs fermeture du claviier
                      ref.read(taskProvider.notifier).saveTask(t); //sauvegarde
                    }
                  }
              );

            }),

            SizedBox(height: 16),
            Row(
              children: [
                Consumer(builder: (context,ref,child){
                  final state =ref.watch(taskFormProvider);
                  return ElevatedButton(
                    onPressed:
                    state is TaskFormValidated ? (){
                      if (_formKey.currentState!.validate()) {
                        FocusScope.of(context).unfocus();
                        ref.read(taskProvider.notifier).saveTask(Task.withoutId(_nameController.text, _descController.text));
                      }
                    }:
                    null,
                    child: Text('Valider'),
                  );

                }),
                SizedBox(width: 16),
                ElevatedButton(
                  onPressed: () {
                    context.go('/'); // Annuler et retourner à la page précédente
                  },
                  child: Text('Annuler'),
                ),
              ],
            ),
          ],),
      ),
    );
  }

}
