// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$HomeStore on HomeStoreBase, Store {
  Computed<List<Tasks>>? _$selectedTasksComputed;

  @override
  List<Tasks> get selectedTasks => (_$selectedTasksComputed ??=
          Computed<List<Tasks>>(() => super.selectedTasks,
              name: 'HomeStoreBase.selectedTasks'))
      .value;

  late final _$tasksAtom = Atom(name: 'HomeStoreBase.tasks', context: context);

  @override
  ObservableList<Tasks> get tasks {
    _$tasksAtom.reportRead();
    return super.tasks;
  }

  @override
  set tasks(ObservableList<Tasks> value) {
    _$tasksAtom.reportWrite(value, super.tasks, () {
      super.tasks = value;
    });
  }

  late final _$fetchTasksAsyncAction =
      AsyncAction('HomeStoreBase.fetchTasks', context: context);

  @override
  Future<void> fetchTasks() {
    return _$fetchTasksAsyncAction.run(() => super.fetchTasks());
  }

  late final _$HomeStoreBaseActionController =
      ActionController(name: 'HomeStoreBase', context: context);

  @override
  void addTask(Tasks task) {
    final _$actionInfo = _$HomeStoreBaseActionController.startAction(
        name: 'HomeStoreBase.addTask');
    try {
      return super.addTask(task);
    } finally {
      _$HomeStoreBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
tasks: ${tasks},
selectedTasks: ${selectedTasks}
    ''';
  }
}
