import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:todolist_with_riverpod/constants/colors.dart';
import 'package:todolist_with_riverpod/providers/task_provider.dart';
import 'package:todolist_with_riverpod/providers/task_state.dart';
import 'package:todolist_with_riverpod/utils/common_widgets.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}


class _SplashScreenState extends ConsumerState<SplashScreen> with SingleTickerProviderStateMixin{

  @override
  void initState() {
    super.initState();
    // Configuration de la couleur de la barre d'état
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: secondary, //
        statusBarIconBrightness: Brightness.dark, // Couleur des icônes de la barre d'état
      ),
    );  }


  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _initTasks();
  }

  void _initTasks()  {
    ref.read(taskProvider.notifier).getTasksCount();
  }
  @override
  Widget build(BuildContext context) {
    //On redirige selon la liste des taches
    ref.listen(taskProvider, (TaskState? previewState,TaskState state){
      if(state is TaskTotalList){
        if(state.total < 1){
          Future.delayed(Duration(seconds: 3),(){
            context.replace('/cta');
          });
        }else{
          Future.delayed(Duration(seconds: 3),(){
            context.replace('/home');
          });
        }
      }
    });

    return  Scaffold(
      body: Center(
        child: logo(),
      ),
      backgroundColor: secondary,
    );
  }



  @override
  void dispose() {
    super.dispose();
    ref.read(taskProvider.notifier).disposeResources();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,overlays: SystemUiOverlay.values);
  }

}
