import 'package:graphql/client.dart';

class GraphQLService {
  final GraphQLClient _client;

  GraphQLService._(this._client);

  static GraphQLService? _instance;

  factory GraphQLService.getInstance() {
    if (_instance == null) {
      final HttpLink httpLink = HttpLink(
        'http://localhost:8080/graphql',
      );

      final GraphQLClient client = GraphQLClient(
        cache: GraphQLCache(),
        link: httpLink,
      );

      _instance = GraphQLService._(client);
    }
    return _instance!;
  }

  Future<T> query<T>(
    {   required QueryOptions options,
        required String queryName,
      }) async {
    try {
      final result = await _client.query(options);
      if (result.hasException) {
        throw GraphQLException(result.exception.toString());
      }
      return result.data?[queryName];
    } catch (e) {
      throw GraphQLException('Erro durante a consulta GraphQL: $e');
    }
  }

  Future<T> mutate<T>(
      { required MutationOptions options,
        required String mutationName,
      }) async {
    try {
      final result = await _client.mutate(options);
      if (result.hasException) {
        throw GraphQLException(result.exception.toString());
      }
      print(result.data.toString());
      return result.data?[mutationName];
    } catch (e) {
      throw GraphQLException('Erro durante a mutação GraphQL: $e');
    }
  }
}

class GraphQLException implements Exception {
  final String message;

  GraphQLException(this.message);

  @override
  String toString() => 'GraphQLException: $message';
}