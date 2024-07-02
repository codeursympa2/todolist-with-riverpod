import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todolist_with_riverpod/data/domain/task.dart';
import 'package:todolist_with_riverpod/data/domain/task_fields_form_error.dart';
import 'package:todolist_with_riverpod/providers/form/task_form_state.dart';


final taskFormProvider=StateNotifierProvider<TaskFormNotifier,TaskFormState>(
    (ref)=> TaskFormNotifier()
);

class TaskFormNotifier extends StateNotifier<TaskFormState>{
  TaskFormNotifier():super(TaskFormValidating());

 void validForm(Task task){
   late String stateNameMessage;
   late String stateDescMessage;

   bool formInvalid=false;

   if(task.name==""){
     formInvalid=true;
     stateNameMessage="Veiller saisir un nom.";
   }else{
     stateNameMessage="";
   }

   if(task.desc== ""){
     formInvalid=true;
     stateDescMessage="Veiller saisir la description.";
   }else{
     stateDescMessage="";
   }

   if(formInvalid){
     var errors=TaskFieldsFormError(nameFieldErrorMessage: stateNameMessage, descFieldErrorMessage: stateDescMessage);
     state=TaskFormValidating(formFieldsErrors: errors);
   }else {
     state=TaskFormValidated();
   }


 }
}

