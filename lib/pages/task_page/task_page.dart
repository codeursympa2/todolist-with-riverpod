import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gif/gif.dart';
import 'package:go_router/go_router.dart';
import 'package:todolist_with_riverpod/constants/colors.dart';
import 'package:todolist_with_riverpod/constants/numbers.dart';
import 'package:todolist_with_riverpod/data/domain/task.dart';
import 'package:todolist_with_riverpod/providers/form/task_form_state.dart';
import 'package:todolist_with_riverpod/providers/form/task_form_provider.dart';
import 'package:todolist_with_riverpod/providers/task_provider.dart';
import 'package:todolist_with_riverpod/providers/task_state.dart';

import '../../utils/common_widgets.dart';

class TaskPage extends ConsumerStatefulWidget {
  final String? id;
  const TaskPage(
      {this.id, //paramètres non obligatoire
      super.key,}
      );

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _TaskState(this.id);

}

class _TaskState extends ConsumerState<TaskPage> with TickerProviderStateMixin{
  final String? id;
  _TaskState(this.id);

  late final GifController controller1;

  @override
  void initState() {
    this.controller1= GifController(vsync: this);
    super.initState();

  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    ref.read(taskProvider.notifier).disposeResources();
    controller1.dispose();
  }

  @override
  Widget build(BuildContext context) {

    //On écoute les changements d'etats de TaskState
    ref.listen<TaskState>(taskProvider, (TaskState? previousState,TaskState state) async {
      //Barre de progression
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
        //Affichage du message
        await toastMessage(context: context, message: state.message, color: primary);
        //on vide le formulaire
        ref.read(taskFormProvider.notifier).validForm(Task.withoutId("", ""));
        context.go("/home"); //retour sur home
        //Actualisation des données
        ref.read(taskProvider.notifier).getTasks();

      }
      if(state is TaskFailureState){
        toastMessage(context: context, message: state.error, color: danger);
      }

    });

    return  Scaffold(
      appBar: AppBar(
        title: Text(id != null ? "Mis à jour d'une tâche":"Création d'une tâche",style: Theme.of(context).textTheme.headlineLarge,),
        centerTitle: true,
        leading: IconButton(
          onPressed: (){
            back(context,ref);
          },
          icon: Icon(Icons.arrow_back),
        ),
        backgroundColor: secondary,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            getGif(controller1, gifSizeAddTask,"ToDoList"),
            SizedBox(height: 10,),
            _FormContent(id:this.id)
          ],),
      ),
      backgroundColor: secondary,
    );
  }


}

class _FormContent extends ConsumerStatefulWidget{
  final String? id;

  const _FormContent({this.id,Key? key}):super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _FormState(id:this.id);



}

class _FormState extends ConsumerState<_FormContent>{
  final String? id;
  _FormState({required this.id});

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  final FocusNode _nameFocusNode = FocusNode();
  final FocusNode _descFocusNode = FocusNode();

  late bool _nameFocusable;

  @override
  void initState() {
    super.initState();
    _nameController.text="";
    _descController.text="";

    if(this.id == null){
      _nameFocusable=true;
    }else{
      _nameFocusable=false;
    }
  }

  @override
  Widget build(BuildContext context) {

    //On écoute les changements d'etats de TaskState pour la mise à jour
    ref.listen<TaskState>(taskProvider, (TaskState? previousState,TaskState state) async {
      //
      if(state is TaskEditingState){
        //Validation du formulaire
        ref.read(taskFormProvider.notifier).validForm(state.task);
        setState(() {
          _nameController.text = state.task.name ?? ""; // Assure que la valeur n'est pas null
          _descController.text = state.task.desc ?? ""; // Assure que la valeur n'est pas null
        });
      }
      if(state is TaskFailureState){
        toastMessage(context: context, message: state.error, color: danger);
      }
    });

    return Padding(padding: EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            Consumer(builder: (context,ref,child){
              final state =ref.watch(taskFormProvider);
              return texEditingField(
                  context: context,
                  label: 'Nom',
                  focused: _nameFocusable,
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
                  context: context,
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
                      _logicToSave(ref,);
                    }
                  }
              );

            }),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Consumer(builder: (context,ref,child){
                  final state =ref.watch(taskFormProvider);
                  return elevatedButton(
                      label: "Valider",
                      icon: Icons.check,
                      iconColor: secondary,
                      background: primary,
                      colorText: secondary,
                      action: state is TaskFormValidated ? (){
                        if (_formKey.currentState != null && _formKey.currentState!.validate()) {
                          _logicToSave(ref);
                        }
                      }:
                        (){
                        toastMessage(context: context, message: "Formulaire invalide", color: danger);
                      }
                  );
                }),
                SizedBox(width: 16),
                elevatedButton(
                    action: () {
                      back(context,ref);
                    },
                    label: 'Annuler',
                    colorText: primary,
                    background: secondary,
                    borderColor: primary,
                    icon: Icons.cancel,
                    iconColor: primary
                ),
              ],
            ),
          ],),
      ),
    );
  }

  @override
  Future<void> didChangeDependencies() async {
    super.didChangeDependencies();
    if (widget.id != null) {
      final id = int.tryParse(widget.id!);
      if (id != null) {
        //Recuperation du task via l'id
        await ref.read(taskProvider.notifier).getTaskById(id);
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descController.dispose();
    ref.read(taskProvider.notifier).disposeResources();
    super.dispose();
  }


  Future<void> _logicToSave(WidgetRef ref) async {
    FocusScope.of(context).unfocus(); //Suppression du focus sur le champs fermeture du clavier
    late Task taskSave;
    if(this.id == null){
      taskSave=Task.withoutId(_nameController.text, _descController.text);
    }else{
      taskSave=Task.updateTask(int.tryParse(this.id!)!,_nameController.text, _descController.text);
    }
    //On sauvegarde
    await ref.read(taskProvider.notifier).saveTask(taskSave);

  }
}

