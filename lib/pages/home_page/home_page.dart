import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:todolist_with_riverpod/constants/colors.dart';
import 'package:todolist_with_riverpod/constants/numbers.dart';
import 'package:todolist_with_riverpod/providers/task_provider.dart';
import 'package:todolist_with_riverpod/providers/task_state.dart';
import 'package:todolist_with_riverpod/utils/common_widgets.dart';


class HomePage extends ConsumerStatefulWidget {

  const HomePage({
    super.key,
  });

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  late final AppLifecycleListener _listener;

  @override
  void initState() {
    super.initState();
    _listener=AppLifecycleListener(
      onStateChange: _onStateChanged,
    );
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(taskProvider, (TaskState? previewState,TaskState state){
      if(state is TaskSuccessState){
        toastMessage(context: context, message: state.message, color: primary);
      }
    });

    final state=ref.watch(taskProvider);
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: primary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(roundedCardTask)),
        icon: const Icon(Icons.add_to_photos, color: secondary),
        onPressed: () {
          return context.go('/task');
        },
        label: Row(
          children: [
            Text("Nouvelle tâche", style: Theme.of(context).textTheme.labelLarge),
          ],
        ),
      ),
      backgroundColor: secondary,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Center(child: Text("Liste des tâches",style: Theme.of(context).textTheme.headlineLarge,)),
              //Chip options
              const SizedBox(height: 10,),
              Expanded(
                child: contentHomePage(state,ref),
              )
            ],
          ),
        ),
      ),


    );
  }


  @override
  void dispose() {
    _listener.dispose();
    super.dispose();
  }

  void _onStateChanged(AppLifecycleState state) {
    if(state == AppLifecycleState.resumed){
      ref.read(taskProvider.notifier).getTasks();
    }
  }

}







