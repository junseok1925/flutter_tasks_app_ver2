import 'package:flutter/material.dart';
import 'package:flutter_tasks_app_ver2/theme.dart';
import 'package:flutter_tasks_app_ver2/viewmodels/todo_view_model.dart';
import 'package:provider/provider.dart';

class TodoDetailPage extends StatelessWidget {
  final String id;

  const TodoDetailPage({required this.id});

  @override
  Widget build(BuildContext context) {
    // TodoViewModel에서 id로 Todo 조회
    final todo = context.watch<TodoViewModel>().getTodoById(id);

    if (todo == null) {
      return Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // 제목은 왼쪽에서 공간을 최대한 차지
            Expanded(
              child: Text(
                todo.title,
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),

            // 오른쪽 아이콘 영역
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  onPressed: () async {
                    await context.read<TodoViewModel>().toggleTodo(todo);
                  },
                  icon: todo.isDone
                      ? Icon(
                          Icons.check_circle,
                          color: context.appColor.main,
                          size: 28,
                        )
                      : Icon(
                          Icons.check_circle_outline,
                          color: Colors.grey,
                          size: 28,
                        ),
                  // todo.isDone ? Icons.check_circle : Icons.check_circle_outline,
                  // color: todo.isDone ? context.appColor.main : Colors.grey,
                  // size: 28,
                ),
                IconButton(
                  padding: EdgeInsets.zero,
                  constraints: BoxConstraints(),
                  icon: Icon(Icons.delete, size: 22, color: Colors.red),
                  onPressed: () async {
                    await context.read<TodoViewModel>().deleteTodo(todo.id);
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 30),
            Text(
              todo.content,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.normal),
            ),
          ],
        ),
      ),
    );
  }
}
