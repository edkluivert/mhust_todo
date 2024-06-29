import 'package:flutter_test/flutter_test.dart';
import 'package:mhust_todo/feature/home/domain/entities/todo_entity.dart';


void main() {
  group('Todo entity', () {
    test('Todo should have a non-empty title', () {
      expect(() => const TodoEntity(id: 1, title: '', completed: false, userId: 23), throwsAssertionError);
    });

    test('Todo should have a non-null completed status', () {
      expect(() => const TodoEntity(id: 1, title: 'Task 1', completed: false, userId: 23), throwsAssertionError);
    });

    test('Todo should create successfully with valid parameters', () {
      const task = TodoEntity(id: 1, title: 'Todo 1', completed: false, userId: 23);
      expect(task.id, 1);
      expect(task.title, 'Todo 1');
      expect(task.completed, false);
    });
  });
}
