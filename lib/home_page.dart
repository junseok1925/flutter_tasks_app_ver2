import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tasks_app_ver2/floatingActionBTN_widget.dart';
import 'package:flutter_tasks_app_ver2/todo.dart';
import 'package:flutter_tasks_app_ver2/todo_app_widget.dart';
import 'package:flutter_tasks_app_ver2/todo_widget.dart';

// 앱실행 시 가장 먼저 보이는 화면 구성
class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController controller = TextEditingController();

  List<Todo> todoList = []; // textField에서 입력 받은 텍스트를 저장하는 리스트

  @override
  void initState() {
    super.initState();
    loadTodos();
  }

  // 데이터 Firestore에서 가져오는 함수
  // READ
  void loadTodos() async {
    // 켜기 - 폴더 열기 - 전체 선택해서 실행
    //firestore 인스턴스 가져오기- 컬렉션 참조 만들기 - 데이터 가져오기

    // firestore 인스턴스 가져오기
    final firestore = FirebaseFirestore.instance;
    // "todos"라는 이름의 컬렉션 참조 가져오기
    final colRef = firestore.collection("todos");
    // 해당 컬렉션에 있는 모든 문서 가져오기 (비동기, await 필요)
    // 내림차순서대로 가져오기
    final query = colRef.orderBy('createdAt', descending: true);
    final querySnapsot = await query.get();

    // 가져온 결과에서 문서들만 리스트로 추출
    final documents = querySnapsot.docs;

    List<Todo> newTodoList = [];

    // 가져온 문서 리스트를 반복문으로 todoList 리스트 변수에 넣기
    for (var i = 0; i < documents.length; i++) {
      final data = documents[i];
      print(data.data());
      final map = data.data();
      // firebase 데이터베이스에서 가져온 데이터를 todoList로 가져와야함
      Todo newTodo = Todo(
        id: data.id,
        title: map['title'],
        isDone: map['isDone'],
      );
      newTodoList.add(newTodo); // db에서 가져온 데이터를 todoList에 넣기
      // 상태 갱신 -> 화면 다시 그리기
    }
    setState(() {
      todoList = newTodoList;
    });
  }

  void onCreate() async {
    // firetore에 입력된 todo create
    // 1. firestore 인스턴스 가져오기 - 2. 컬렉션 참조 만들기 - 3.문서 참조 만들기(id 새로만들기) -> 4.저장
    // 1.
    final firestore = FirebaseFirestore.instance;
    // 2.
    final colRef = firestore.collection("todos");
    // 3.
    final docRef = colRef.doc(); //.doc() : 비워두면 자동으로 유니크한 id로 문서 생성
    Map<String, dynamic> map = {
      'title': controller.text,
      'isDone': false,
      'createdAt': DateTime.now().toIso8601String(),
    };
    await docRef.set(map);
    loadTodos();
    setState(() {
      controller.clear(); //textField 입력창 클리어
    });
  }

  @override
  void dispose() {
    // 이 위젯이 사라질때 메모리 누수 방지
    super.dispose();
    controller.dispose();
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

        // resizeToAvoidBottomInset:
        //     false, // 키보드 올라와도 FloatingActionButton 고정 true면 미세하게 키보드와 함께 올라옴
        appBar: AppBar(title: Text('준석`s Todo')),
        // 할 일 목록 리스트 생성 ( 만약 할 일 목록(todoList)이 비었다면 addTodoWidget 위젯 보여주기)
        body: todoList.isEmpty
            ? addTodoWidget(onCreate: onCreate, controller: controller)
            : ListView.separated(
                //ListView.builde 반복적으로 리스트 생성
                padding: EdgeInsets.only(
                  top: 20,
                  left: 20,
                  right: 20,
                  bottom: 200,
                ),
                separatorBuilder: (context, index) =>
                    SizedBox(height: 20), // 각 리스트 아이템 사이사이에 들어가게 되서 공간 띄어줌
                itemCount: todoList.length, // 1. 입력되어 보내진 텍스트의 인덱스 갯수가
                itemBuilder: (context, index) {
                  // 2. 여기 인덱스로 0,1,2...로 들어감
                  Todo todo = todoList[index];
                  return GestureDetector(
                    // 체크박스 탭
                    onTap: () async {
                      // 1. firestore 인스턴스 가져오기 - 2. 컬렉션 참조 만들기 - 3.특정 ID의 문서참조 만들기 -> 4.데이터 업데이트하기(할 일 가져오기)
                      final firestore = FirebaseFirestore.instance; // 1.
                      final colRef = firestore.collection("todos"); // 2.
                      final docRef = colRef.doc(todo.id);
                      await docRef.update({
                        'isDone': !todo.isDone,
                      }); //!todo.isDone -> todo.isDone의 값의 반대값 완료,미완료 업뎃하기
                      loadTodos();
                      setState(() {
                        todo.isDone = !todo.isDone;
                      });
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
                        // 삭제버튼을 누른다면
                        // todoeList 리스트 안에 있는 index 요소 삭제
                        print('$index번쪠 todoList요소 삭제함');

                        // firestore에서 해당 id 문서를 삭제
                        // 1. firestore 인스턴스 가져오기 - 2. 컬렉션 참조 만들기 - 3.삭제할 id를 가진 문서 참조  -> 4.삭제
                        final firestore = FirebaseFirestore.instance; // 1.
                        final colRef = firestore.collection("todos"); // 2.
                        final docRef = colRef.doc(todo.id); // 3.
                        await docRef.delete(); // 4.
                        loadTodos(); //loadTodos() 함수 안에 이미 setStat()를 실행하므로 setState()생략
                      }
                    },
                    child: TodoWidget(content: todo.title, isDone: todo.isDone),
                  );
                },
              ),

        floatingActionButton: FloatingActionBTNWidget(
          onCreate: onCreate,
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
