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
import 'package:todolist_with_riverpod/utils/refactoring.dart';

import '../../utils/common_widgets.dart';

class TaskPage extends ConsumerStatefulWidget {
  final String? id;
  const TaskPage({this.id, super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _TaskState(this.id);
}

class _TaskState extends ConsumerState<TaskPage> with TickerProviderStateMixin {
  final String? id;
  late final GifController controller1;

  _TaskState(this.id);

  @override
  void initState() {
    super.initState();
    controller1 = GifController(vsync: this);
  }

  @override
  void dispose() {
    controller1.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //On écoute les changements
    ref.listen<TaskState>(taskProvider, (TaskState? previousState, TaskState state) async {
      if (state is TaskLoadingState) {
        _showLoadingDialog(context);
      } else if (state is TaskSuccessState) {
        await _handleSuccessState(context, state, ref);
      } else if (state is TaskFailureState) {
        toastMessage(context: context, message: state.error, color: danger);
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: Text(id != null ? "Mise à jour d'une tâche" : "Ajout d'une tâche", style: Theme.of(context).textTheme.headlineLarge),
        centerTitle: true,
        leading: IconButton(
          onPressed: () => back(context, ref),
          icon: Icon(Icons.arrow_back),
        ),
        backgroundColor: secondary,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            getGif(controller1, gifSizeAddTask, "ToDoList"),
            SizedBox(height: 10),
            _FormContent(id: this.id)
          ],
        ),
      ),
      backgroundColor: secondary,
    );
  }

  //Affichae circular progress bar
  void _showLoadingDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Center(
        child: CircularProgressIndicator(backgroundColor: primary, color: secondary),
      ),
    );
  }
  //etat de success
  Future<void> _handleSuccessState(BuildContext context, TaskSuccessState state, WidgetRef ref) async {
    await toastMessage(context: context, message: state.message, color: primary);
    ref.read(taskFormProvider.notifier).validForm(Task.withoutId("", ""));
    context.go("/home");
    ref.read(taskProvider.notifier).getTasks();
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
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  final FocusNode _nameFocusNode = FocusNode();
  final FocusNode _descFocusNode = FocusNode();

  late bool _nameFocusable;

  _FormState({required this.id});

  @override
  void initState() {
    super.initState();
    _initForm();
  }

  @override
  Widget build(BuildContext context) {

    //On écoute les changements d'etats de TaskState pour la mise à jour
    ref.listen<TaskState>(taskProvider, (TaskState? previousState,TaskState state) async {
      //
      if(state is TaskEditingState){
        //Validation du formulaire
        ref.read(taskFormProvider.notifier).validForm(state.task);
        _fillForm(state.task);
      }
      if(state is TaskFailureState){
        toastMessage(context: context, message: state.error, color: danger);
      }
    });

    const double sizeBoxValue=16;
    return Padding(padding: EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            _builderNameField(),
            SizedBox(height: sizeBoxValue),
            _buildDescField(),
            SizedBox(height: sizeBoxValue),
            _buttonFormButtons()
          ],),
      ),
    );
  }

  @override
  Future<void> didChangeDependencies() async {
    super.didChangeDependencies();
    _loadTask();
  }

  @override
  void dispose() {
    _disposeTextEditing();
    super.dispose();
  }

  //REFACTORING

  Future<void> _logicToSave(WidgetRef ref) async {

    if (_formKey.currentState != null && _formKey.currentState!.validate()) {
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

  //Form

  void _initEditingTextController(){
    _nameController.text="";
    _descController.text="";
  }

  void _checkFocusableName(){
    this.id == null ? _nameFocusable=true: _nameFocusable=false;
  }

  void _initForm(){
    _checkFocusableName();
    _initEditingTextController();
  }

  Future<void> _loadTask() async {
    final taskId = int.tryParse(id!);
    if (taskId != null) {
      await ref.read(taskProvider.notifier).getTaskById(taskId);
    }
  }

  void _disposeTextEditing(){
    _nameController.dispose();
    _descController.dispose();
  }

  Widget _builderNameField(){
    return Consumer(builder: (context,ref,child){
      final state =ref.watch(taskFormProvider);
      return texEditingField(
          context: context,
          label: 'Titre',
          focused: _nameFocusable,
          textInputAction: TextInputAction.next,
          focusNode: _nameFocusNode,
          ctrl:_nameController,
          maxLines: 1,
          validator: (value) => _validateField(state, value, 'name'),
          onChanged:(value) => _onChangedTextEditingField(ref),
          onFieldSubmitted: (value){}
      );

    });
  }

  Widget _buildDescField(){
    return  Consumer(builder: (context,ref,child){
      final state =ref.watch(taskFormProvider);
      return texEditingField(
          context: context,
          label: 'Description',
          focused: false,
          textInputAction: TextInputAction.done,
          focusNode: _descFocusNode,
          ctrl:_descController,
          maxLines: 5,
          validator: (value)=> _validateField(state, value, 'desc'),
          onChanged:(value)=> _onChangedTextEditingField(ref),
          onFieldSubmitted: (value) => _logicToSave(ref)
      );

    });

  }

  Widget _buttonFormButtons(){
    return Row(
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
    );
  }

  void _onChangedTextEditingField(WidgetRef ref){
    //Au changement on notifie et on envoie les data
    ref.read(taskFormProvider.notifier).validForm(Task.withoutId(_nameController.text, _descController.text));
  }


  String? _validateField(TaskFormState state, String? value, String field) {
    if (state is TaskFormValidating) {
      if (field == 'name' && state.formFieldsErrors?.nameFieldErrorMessage != "") {
        return state.formFieldsErrors?.nameFieldErrorMessage;
      }
      if (field == 'desc' && state.formFieldsErrors?.descFieldErrorMessage != "") {
        return state.formFieldsErrors?.descFieldErrorMessage;
      }
    }
    return null;
  }

  //
  void _fillForm(Task task) {
    setState(() {
      _nameController.text = task.name ?? "";
      _descController.text = task.desc ?? "";
    });
  }
}