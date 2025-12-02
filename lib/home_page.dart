import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tasks_app_ver2/floatingActionBTN_widget.dart';
import 'package:flutter_tasks_app_ver2/todo.dart';
import 'package:flutter_tasks_app_ver2/todo_app_widget.dart';
import 'package:flutter_tasks_app_ver2/todo_widget.dart';
import 'package:flutter_tasks_app_ver2/viewmodels/todo_view_model.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

// 앱실행 시 가장 먼저 보이는 화면 구성
class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController contentController = TextEditingController();

  Future<void> _onCreate(BuildContext context) async {
    await context.read<TodoViewModel>().addTodo(
      titleController.text,
      contentController.text,
    );

    // 입력값 초기화
    titleController.clear();
    contentController.clear();
  }

  @override
  void dispose() {
    titleController.dispose();
    contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        resizeToAvoidBottomInset: false,
        appBar: AppBar(title: Text('준석`s Todo')),
        body: Consumer<TodoViewModel>(
          builder: (context, viewModel, _) {
            if (viewModel.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (viewModel.todos.isEmpty) {
              return AddTodoWidget(
                onCreate: () => _onCreate(context),
                titleController: titleController,
                contentController: contentController,
              );
            }

            return NotificationListener<ScrollNotification>(
              onNotification: (notification) {
                if (notification.metrics.pixels >=
                        notification.metrics.maxScrollExtent - 100 &&
                    viewModel.hasMore &&
                    !viewModel.isLoadingMore) {
                  viewModel.loadMore();
                }
                return false;
              },
              child: RefreshIndicator(
                onRefresh: () => context.read<TodoViewModel>().loadInitial(),
                child: ListView.separated(
                  padding: EdgeInsets.only(
                    top: 20,
                    left: 20,
                    right: 20,
                    bottom: 200,
                  ),
                  separatorBuilder: (context, index) => SizedBox(height: 20),
                  itemCount:
                      viewModel.todos.length +
                      (viewModel.isLoadingMore ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index >= viewModel.todos.length) {
                      return const Padding(
                        padding: EdgeInsets.symmetric(vertical: 16),
                        child: Center(child: CircularProgressIndicator()),
                      );
                    }

                    Todo todo = viewModel.todos[index];

                    return GestureDetector(
                      // 리스트 전체 클릭 → 상세 페이지 이동
                      onTap: () {
                        print('index: $index');
                        context.push('/todo/${todo.id}');
                      },

                      // 롱프레스 → 삭제
                      onLongPress: () async {
                        bool result = await showCupertinoDialog(
                          context: context,
                          barrierDismissible: true,
                          builder: (context) {
                            return CupertinoAlertDialog(
                              title: Text("일정을 삭제하시겠습니까?"),
                              actions: [
                                CupertinoDialogAction(
                                  onPressed: () {
                                    Navigator.pop(context, false);
                                  },
                                  child: Text(
                                    "취소",
                                    style: TextStyle(color: Colors.red),
                                  ),
                                ),
                                CupertinoDialogAction(
                                  onPressed: () {
                                    Navigator.pop(context, true);
                                  },
                                  child: Text(
                                    "삭제",
                                    style: TextStyle(color: Colors.blue),
                                  ),
                                ),
                              ],
                            );
                          },
                        );

                        if (result) {
                          await context.read<TodoViewModel>().deleteTodo(
                            todo.id,
                          );
                        }
                      },

                      // 실제 TodoWidget 삽입
                      child: TodoWidget(
                        content: todo.title,
                        isDone: todo.isDone,
                        // 체크박스만 터치하면 실행되는 콜백
                        onToggle: () async {
                          await context.read<TodoViewModel>().toggleTodo(todo);
                        },
                      ),
                    );
                  },
                ),
              ),
            );
          },
        ),

        floatingActionButton: FloatingActionBTNWidget(
          onCreate: () => _onCreate(context),
          titleController: titleController,
          contentController: contentController,
        ),
      ),
    );
  }
}
