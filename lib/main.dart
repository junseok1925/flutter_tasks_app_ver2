import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tasks_app_ver2/firebase_options.dart';
import 'package:flutter_tasks_app_ver2/home_page.dart';

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
    return MaterialApp(
      // themeMode: ThemeMode.light,
      themeMode: ThemeMode.dark,

      // 기본 테마
      theme: ThemeData(
        brightness: Brightness.light,
        scaffoldBackgroundColor: Colors.blue[100], // Light 모드 배경
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blueAccent,
          brightness: Brightness.light,
          surface: Colors.white70, // 컨테이너 색
        ),
        dividerColor: Colors.black12,

        // 아이콘 테마
        iconTheme: IconThemeData(color: Colors.blue[200]),

        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: Colors.blue[200],
          foregroundColor: Colors.white,
          highlightElevation: 1, // 눌렀을 때 그림자 깊이 거의 없게
        ),
      ),

      // 다크 테마
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: Colors.black, // Dark 모드 배경
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blueAccent,
          brightness: Brightness.dark,
          surface: Colors.grey[900],
        ),
        dividerColor: Colors.white,

        //아이콘 테마
        iconTheme: IconThemeData(color: Colors.grey[700]),

        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: Colors.grey[700],
          foregroundColor: Colors.white,
        ),
      ),
      home: HomePage(),
    );
  }
}
