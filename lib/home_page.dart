import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tasks_app_ver2/floatingActionBTN_widget.dart';
import 'package:flutter_tasks_app_ver2/todo.dart';
import 'package:flutter_tasks_app_ver2/todo_app_widget.dart';
import 'package:flutter_tasks_app_ver2/todo_widget.dart';
import 'package:flutter_tasks_app_ver2/viewmodels/todo_view_model.dart';
import 'package:provider/provider.dart';

// 앱실행 시 가장 먼저 보이는 화면 구성
class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController controller = TextEditingController();

  Future<void> _onCreate(BuildContext context) async {
    await context.read<TodoViewModel>().addTodo(controller.text);
    controller.clear();
  }

  @override
  void dispose() {
    controller.dispose();
    // 이 위젯이 사라질때 메모리 누수 방지
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // 키보드가 올라왔을 때 빈공간을 터치하면 키보드가 내려가도록 GestureDetector 위젯으로 감싼 후 onTap 함수 작성
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        // 키보드 올라와도 FloatingActionButton 고정 true면 미세하게 키보드와 함께 올라옴
        resizeToAvoidBottomInset: false,
        appBar: AppBar(title: Text('준석`s Todo')),
        // 할 일 목록 리스트 생성 ( 만약 할 일 목록(todoList)이 비었다면 AddTodoWidget 위젯 보여주기)
        body: Consumer<TodoViewModel>(
          builder: (context, viewModel, _) {
            if (viewModel.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (viewModel.todos.isEmpty) {
              return AddTodoWidget(
                onCreate: () => _onCreate(context),
                controller: controller,
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
                  separatorBuilder: (context, index) =>
                      SizedBox(height: 20), // 각 리스트 아이템 사이사이에 들어가게 되서 공간 띄어줌
                  itemCount:
                      viewModel.todos.length + (viewModel.isLoadingMore ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index >= viewModel.todos.length) {
                      return const Padding(
                        padding: EdgeInsets.symmetric(vertical: 16),
                        child: Center(child: CircularProgressIndicator()),
                      );
                    }
                    Todo todo = viewModel.todos[index];
                    return GestureDetector(
                      // 체크박스 탭
                      onTap: () async {
                        await context.read<TodoViewModel>().toggleTodo(todo);
                      },
                      onLongPress: () async {
                        print("꾸욱~");
                        bool result = await showCupertinoDialog(
                          context: context,
                          barrierDismissible: true, // 팝업창 외 화면 터치하면 팝업창 닫힘
                          builder: (context) {
                            return CupertinoAlertDialog(
                              title: Text("일정을 삭제하시겠습니까?"),
                              actions: [
                                // ios스타일 취소/확인 alert 팝업
                                CupertinoDialogAction(
                                  onPressed: () {
                                    Navigator.pop(context, false);
                                  },
                                  child: Text(
                                    "취소",
                                    style: TextStyle(color: Colors.red),
                                  ),
                                ),
                                // CupertinoDialogAction는 ios스타일 취소/확인 alert 팝업
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

                        print(result);
                        if (result) {
                          await context.read<TodoViewModel>().deleteTodo(todo.id);
                        }
                      },
                      child: TodoWidget(content: todo.title, isDone: todo.isDone),
                    );
                  },
                ),
              ),
            );
          },
        ),

        floatingActionButton: FloatingActionBTNWidget(
          onCreate: () => _onCreate(context),
          controller: controller,
        ),

        // bottomSheet: Container(
        //   color: Colors.white,
        //   padding: EdgeInsets.only(top: 20, right: 20, left: 20, bottom: 40),
        //   child: TextField(
        //     controller: controller,
        //     maxLines: 1,
        //     onSubmitted: (value) {
        //       // Enter로 텍스트 추가
        //       print(controller.text);
        //       // 아무런 텍스트를 입력하지 않으면 생성 ㄴㄴ
        //       if (controller.text != "") {
        //         onCreate();
        //       } else {
        //         print("아무것도 없잖슴~");
        //       }
        //     },

        //     decoration: InputDecoration(
        //       hintText: "적어",
        //       border: InputBorder.none,
        //       fillColor: Colors.blue.withValues(alpha: 0.1),
        //       filled: true,
        //       suffixIcon: GestureDetector(
        //         onTap: () {
        //           print(controller.text);
        //           // 아무런 텍스트를 입력하지 않으면 생성 ㄴㄴ
        //           if (controller.text != "") {
        //             onCreate();
        //           } else {
        //             print("아무것도 없잖슴~");
        //           }
        //         },
        //         child: Container(
        //           margin: EdgeInsets.all(10),
        //           decoration: BoxDecoration(
        //             color: Colors.blue,
        //             shape: BoxShape.circle,
        //           ),
        //           child: Icon(Icons.add, color: Colors.white),
        //         ),
        //       ),
        //       suffixIconConstraints: BoxConstraints(),
        //     ),
        //   ),
        // ),
      ),
    );
  }
}
