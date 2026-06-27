class ApiConstants {
  const ApiConstants._();

  static const String baseUrl = 'https://dummyjson.com';

  static const String users = '/users';
  static const String todos = '/todos';
  static const String authLogin = '/auth/login';
  static String userTodos(int userId) => '/todos/user/$userId';
  static String todo(int id) => '/todos/$id';
  static const String addTodo = '/todos/add';
}
