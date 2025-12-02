import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tasks_app_ver2/firebase_options.dart';
import 'package:flutter_tasks_app_ver2/home_page.dart';
import 'package:flutter_tasks_app_ver2/theme.dart';
import 'package:flutter_tasks_app_ver2/viewmodels/todo_view_model.dart';
import 'package:provider/provider.dart';

import 'data/todo_repository.dart';

void main() async {
  // 비동기 처리를 안전하게 할 수 있도록 준비하는 코드
  // runApp 전에 비동기 작업을 하려면 필수
  WidgetsFlutterBinding.ensureInitialized();
  // 현재 플랫폼(Android/iOS 등)에 맞는 Firebase 설정을 로드하고 앱에 초기화
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => TodoViewModel(repository: TodoRepository())..loadInitial(),
      child: MaterialApp(
        themeMode: ThemeMode.light,
        theme: lightTheme,
        darkTheme: darkTheme,
        home: HomePage(),
      ),
    );
  }
}
