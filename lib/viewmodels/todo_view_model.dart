import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

import '../data/todo_repository.dart';
import '../todo.dart';

class TodoViewModel extends ChangeNotifier {
  TodoViewModel({required TodoRepository repository})
    : _repository = repository;

  final TodoRepository _repository;
  final int _pageSize = 8;

  List<Todo> todos = [];
  bool isLoading = false;
  bool isLoadingMore = false;
  bool hasMore = true;
  String? errorMessage;
  DocumentSnapshot? _lastDoc;

  Future<void> loadInitial() async {
    if (isLoading) return;
    isLoading = true;
    isLoadingMore = false;
    hasMore = true;
    _lastDoc = null;
    todos = [];
    notifyListeners();
    await _loadPage(reset: true);
    isLoading = false;
    notifyListeners();
  }

  Future<void> loadMore() async {
    if (isLoading || isLoadingMore || !hasMore) return;
    isLoadingMore = true;
    notifyListeners();
    // 데이터 불러오는 시간을 좀 더 느리게 해서 로딩 중인 상태를 체감 할 수 있도록 함
    await Future.delayed(const Duration(milliseconds: 1500));
    await _loadPage(reset: false);
    isLoadingMore = false;
    notifyListeners();
  }

  Future<void> _loadPage({required bool reset}) async {
    try {
      final page = await _repository.fetchTodosPage(
        startAfter: reset ? null : _lastDoc,
        limit: _pageSize,
      );
      errorMessage = null;
      if (reset) {
        todos = page.todos;
      } else {
        todos.addAll(page.todos);
      }
      _lastDoc = page.lastDoc;
      hasMore = page.todos.length == _pageSize;
    } catch (e) {
      errorMessage = '할 일을 불러오지 못했습니다';
    }
  }

  Future<void> addTodo(String title) async {
    final newTitle = title.trim();
    if (newTitle.isEmpty) return;
    await _repository.addTodo(newTitle);
    await loadInitial();
  }

  Future<void> toggleTodo(Todo todo) async {
    await _repository.updateCompletion(todo);
    await loadInitial();
  }

  Future<void> deleteTodo(String id) async {
    await _repository.deleteTodo(id);
    await loadInitial();
  }
}
