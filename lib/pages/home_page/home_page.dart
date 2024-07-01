import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:todolist_with_riverpod/constants/colors.dart';
import 'package:todolist_with_riverpod/constants/numbers.dart';
import 'package:todolist_with_riverpod/providers/task_provider.dart';
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
      body: contentHomePage(state),
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







