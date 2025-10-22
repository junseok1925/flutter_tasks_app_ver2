// onTap: () async {
//   // 1. firestore 인스턴스 가져오기 - 2. 컬렉션 참조 만들기 - 3.특정 ID의 문서참조 만들기 -> 4.데이터 업데이트하기
//   final firestore = FirebaseFirestore.instance; // 1.
//   final colRef = firestore.collection("todos"); // 2.
//   final docRef = colRef.doc(todo.id);
//   await docRef.update({
//   'isDone': !todo.isDone,
//   }); //!todo.isDone -> todo.isDone의 값의 반대값
//   loadTodos();
//   setState(() {
//     todo.isDone = !todo.isDone;
//   });
// },
