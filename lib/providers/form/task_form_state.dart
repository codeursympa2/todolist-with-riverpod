import 'package:todolist_with_riverpod/data/domain/task_fields_form_error.dart';

abstract class TaskFormState{
  const TaskFormState();
}

class TaskFormValidating extends TaskFormState{
  final TaskFieldsFormError? formFieldsErrors;

  TaskFormValidating({
    this.formFieldsErrors,
  });
}

class TaskFormValidated extends TaskFormState{
    const TaskFormValidated();
}