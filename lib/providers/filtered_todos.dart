import 'package:equatable/equatable.dart';
import 'package:state_notifier/state_notifier.dart';

import '../models/todo_model.dart';
import 'providers.dart';

class FilteredTodosState extends Equatable {
  final List<Todo> filterdTodos;
  FilteredTodosState({
    required this.filterdTodos,
  });

  factory FilteredTodosState.initial() {
    return FilteredTodosState(filterdTodos: []);
  }

  @override
  List<Object> get props => [filterdTodos];

  @override
  bool get stringify => true;

  FilteredTodosState copyWith({
    List<Todo>? filterdTodos,
  }) {
    return FilteredTodosState(
      filterdTodos: filterdTodos ?? this.filterdTodos,
    );
  }
}

class FilteredTodos extends StateNotifier<FilteredTodosState>
    with LocatorMixin {
  FilteredTodos() : super(FilteredTodosState.initial());

  // FilteredTodosState get state {
  //   List<Todo> _filteredTodos;

  //   switch (todoFilter.state.filter) {
  //     case Filter.active:
  //       _filteredTodos =
  //           todoList.state.todos.where((Todo todo) => !todo.completed).toList();
  //       break;
  //     case Filter.completed:
  //       _filteredTodos =
  //           todoList.state.todos.where((Todo todo) => todo.completed).toList();
  //       break;
  //     case Filter.all:
  //     default:
  //       _filteredTodos = todoList.state.todos;
  //       break;
  //   }

  //   if (todoSearch.state.searchTerm.isNotEmpty) {
  //     _filteredTodos = _filteredTodos
  //         .where((Todo todo) =>
  //             todo.desc.toLowerCase().contains(todoSearch.state.searchTerm))
  //         .toList();
  //   }

  //   return FilteredTodosState(filterdTodos: _filteredTodos);
  // }
  @override
  void update(Locator watch) {
    final Filter filter = watch<TodoFilterState>().filter;
    final String searchTerm = watch<TodoSearchState>().searchTerm;
    final List<Todo> todos = watch<TodoListState>().todos;

    List<Todo> _filteredTodos;

    switch (filter) {
      case Filter.active:
        _filteredTodos = todos.where((Todo todo) => !todo.completed).toList();
        break;
      case Filter.completed:
        _filteredTodos = todos.where((Todo todo) => todo.completed).toList();
        break;
      case Filter.all:
      default:
        _filteredTodos = todos;
        break;
    }

    if (searchTerm.isNotEmpty) {
      _filteredTodos = _filteredTodos
          .where((Todo todo) => todo.desc.toLowerCase().contains(searchTerm))
          .toList();
    }

    state = state.copyWith(filterdTodos: _filteredTodos);
    super.update(watch);
  }
}
