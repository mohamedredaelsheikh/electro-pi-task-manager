class ApiConstants {
  const ApiConstants._();

  static const String baseUrl = 'https://jsonplaceholder.typicode.com';

  static const String posts = '/posts';
  static const String todos = '/todos';
  static const String users = '/users';

  static String userPosts(int userId) => '/users/$userId/posts';
  static String userTodos(int userId) => '/users/$userId/todos';
  static String todo(int id) => '/todos/$id';
  static String post(int id) => '/posts/$id';
}
