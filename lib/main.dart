import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todolist_with_riverpod/constants/colors.dart';
import 'package:todolist_with_riverpod/constants/strings.dart';
import 'package:go_router/go_router.dart';
import 'package:todolist_with_riverpod/pages/cta_page/cta_page.dart';
import 'package:todolist_with_riverpod/pages/home_page/home_page.dart';
import 'package:todolist_with_riverpod/pages/splash_screen/splash_screen.dart';
import 'package:todolist_with_riverpod/pages/task_page/task_page.dart';


final _router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const SplashScreen(),
      routes: [
        GoRoute(
          name: 'update',
          path: 'task/:id',
          builder: (context, state) {
            final idString = state.pathParameters['id'];
            return TaskPage(id: idString);
          },
        ),
        GoRoute(
          name: "create",
          path: 'task',
          builder: (context, state) {
            return TaskPage();
          },
        ),
        GoRoute(
          path: 'home',
          builder: (context, state) {
            // Une fois sur 'home', supprimer toutes les routes empilées jusqu'à '/'
            //context. ('/');
            return const HomePage();
          },
        ),
        GoRoute(
          path:'cta',
          builder: (context,state){
            return CtaPage();
          }
        )
      ],
    ),
  ],
);


void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(ProviderScope(child:MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    const gothicA1= 'GothicA1';
    const ptSerif='PTSerif';

    return MaterialApp.router(
      title: appNameComplete,
      
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        //Configuration des polices à partir de figma
        textTheme: const TextTheme(
          // Century Gothic Bold 20
          headlineLarge: TextStyle(
            fontFamily: gothicA1,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
          // PT Serif Regular 15
          bodyLarge: TextStyle(
            fontFamily: ptSerif,
            fontWeight: FontWeight.normal,
            fontSize: 15,
          ),
          // Century Gothic Bold 14
          headlineMedium: TextStyle(
            fontFamily: gothicA1,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
          // PT Serif Regular 12
          bodyMedium: TextStyle(
            fontFamily: ptSerif,
            fontWeight: FontWeight.normal,
            fontSize: 12,
          ),
          // PT Serif Bold 15
          headlineSmall: TextStyle(
            fontFamily: ptSerif,
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
          //Exeption
          labelLarge: TextStyle(
            fontFamily: ptSerif,
            fontWeight: FontWeight.normal,
            fontSize: 15,
            color: secondary
          ),
        ),

        colorScheme: ColorScheme.fromSeed(seedColor: primary),
        useMaterial3: true,
      ),
      routerConfig: _router,
    );
  }


}

