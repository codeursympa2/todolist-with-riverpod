import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
  Widget build(BuildContext context) {
    final state=ref.watch(taskProvider);
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: primary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(roundedCardTask)),
        icon: const Icon(Icons.add_to_photos, color: secondary),
        onPressed: () {
          // Action pour le bouton
        },
        label: Row(
          children: [
            Text("Nouvelle tâche", style: Theme.of(context).textTheme.labelLarge),
          ],
        ),
      ),
      backgroundColor: secondary,
      appBar: AppBar(
        backgroundColor: secondary,
        leading: logo(),
      ),
      body: contentHomePage(state),
    );
  }


}







