import 'package:flutter_tasks_app_ver2/home_page.dart';
import 'package:flutter_tasks_app_ver2/pages/error_page.dart';
import 'package:flutter_tasks_app_ver2/todo_detail_page.dart';
import 'package:go_router/go_router.dart';

final router = GoRouter(
  initialLocation: '/',
  routes: [
    // HOME
    GoRoute(
      path: '/',
      builder: (context, state) => HomePage(),

      routes: [
        // TODO DETAIL — ex) /todo/ABCD1234
        GoRoute(
          path: 'todo/:id',
          builder: (context, state) {
            // pathParameters에서 id를 String으로 가져온다
            final id = state.pathParameters['id'];
            if (id == null) {
              return ErrorPage();
            }

            return TodoDetailPage(id: id);
          },
        ),
      ],
    ),
  ],
);
