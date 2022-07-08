import 'package:flutter/material.dart';
import 'package:lesson3/model/constant.dart';
import 'package:lesson3/viewscreen/addphotomemo_screen.dart';
import 'package:lesson3/viewscreen/detailedview_screen.dart';
import 'package:lesson3/viewscreen/error_screen.dart';
import 'package:lesson3/viewscreen/sharedwith_screen.dart';
import 'package:lesson3/viewscreen/signup_screen.dart';
import 'package:lesson3/viewscreen/start_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:lesson3/viewscreen/userhome_screen.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const Lesson3App());
}

class Lesson3App extends StatelessWidget {
  const Lesson3App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: Constant.devMode,
      initialRoute: StartScreen.routeName,
      routes: {
        StartScreen.routeName: ((context) => const StartScreen()),
        UserHomeScreen.routeName: (context) {
          Object? args = ModalRoute.of(context)?.settings.arguments;
          if (args == null) {
            return const ErrorScreen('args is null for UserHomeScreen');
          } else {
            var argument = args as Map;
            var user = argument[Argkey.user];
            var photoMemoList = argument[Argkey.photoMemoList];
            return UserHomeScreen(
              user: user,
              photoMemoList: photoMemoList,
            );
          }
        },
        AddPhotoMemoScreen.routeName: (context) {
          Object? args = ModalRoute.of(context)?.settings.arguments;
          if (args == null) {
            return const ErrorScreen('args is null for AddPhotoMemoScreen');
          } else {
            var argument = args as Map;
            var user = argument[Argkey.user];
            var photoMemoList = argument[Argkey.photoMemoList];
            return AddPhotoMemoScreen(
              user: user,
               photoMemoList: photoMemoList,
            );
            
          }
        },

        DetailedViewScreen.routeName: (context) {
         Object? args = ModalRoute.of(context)?.settings.arguments;
          if (args == null) {
            return const ErrorScreen('args is null for DetailedViewScreen');
          } else {
            var argument = args as Map;
            var user = argument[Argkey.user];
            var photoMemo = argument[Argkey.onePhotoMemo];
            return DetailedViewScreen(
              user: user,
              photoMemo: photoMemo,
            );
            
          }
        },
         SignUpScreen.routeName: (context) => const SignUpScreen(),
         SharedWithScreen.routeName: (context) {
          Object? args = ModalRoute.of(context)?.settings.arguments;
          if (args == null) {
            return const ErrorScreen('args is null for SharedWithScreen');
          } else {
            var argument = args as Map;
            var user = argument[Argkey.user];
            var photoMemoList = argument[Argkey.photoMemoList];
            return SharedWithScreen(
              user: user,
               photoMemoList: photoMemoList,
            );
            
          }
          },
      },
    );
  }
} 
