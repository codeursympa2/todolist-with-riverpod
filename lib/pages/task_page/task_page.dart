import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TaskPage extends ConsumerWidget {
  final int id;
  const TaskPage(
      this.id, //paramètres non obligatoire
      {super.key}
      );

  @override
  Widget build(BuildContext context,WidgetRef ref) {
    return const Placeholder();
  }
}
