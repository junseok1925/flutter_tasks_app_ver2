import 'package:cloud_firestore/cloud_firestore.dart';

import '../todo.dart';

/// Repository responsible for CRUD operations on todos.
class TodoRepository {
  TodoRepository({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> get _collection =>
      _firestore.collection('todos');

  /// 페이지네이션을 위한 조회. [startAfter] 이후 데이터부터 [limit]만큼 가져온다.
  Future<({List<Todo> todos, DocumentSnapshot? lastDoc})> fetchTodosPage({
    DocumentSnapshot? startAfter,
    int limit = 20,
  }) async {
    Query<Map<String, dynamic>> query = _collection
        .orderBy('createdAt', descending: true)
        .limit(limit);

    if (startAfter != null) {
      query = query.startAfterDocument(startAfter);
    }

    final snapshot = await query.get();
    final docs = snapshot.docs;
    return (
      todos: docs.map((doc) => Todo.fromMap(doc.id, doc.data())).toList(),
      lastDoc: docs.isNotEmpty ? docs.last : startAfter,
    );
  }

  Future<void> addTodo(String title) async {
    await _collection.add({
      'title': title,
      'isDone': false,
      'createdAt': DateTime.now().toIso8601String(),
    });
  }

  Future<void> updateCompletion(Todo todo) async {
    await _collection.doc(todo.id).update({'isDone': !todo.isDone});
  }

  Future<void> deleteTodo(String id) async {
    await _collection.doc(id).delete();
  }
}
