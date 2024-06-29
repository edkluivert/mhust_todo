import 'package:mhust_todo/feature/home/data/models/todo_model.dart';
import 'package:mhust_todo/feature/home/domain/entities/todo_entity.dart';

TodoEntity todoModelToEntity(TodoModel model) {
  return TodoEntity(
    id: model.id,
    title: model.title,
    completed: model.completed,
    userId: model.userId,
  );
}

TodoModel todoEntityToModel(TodoEntity entity) {
  return TodoModel(
    id: entity.id,
    title: entity.title,
    completed: entity.completed,
    userId: entity.userId,
  );
}
extension TodoModelExtension on TodoModel {
  TodoEntity toEntity() {
    return TodoEntity(
      id: id,
      title: title,
      completed: completed,
      userId: userId,
    );
  }
}


extension TodoEntityExtension on TodoEntity {
  TodoModel toModel() {
    return TodoModel(
      id: id,
      title: title,
      completed: completed,
      userId: userId,
    );
  }
}
