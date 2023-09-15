import 'package:flutter_test/flutter_test.dart';
import 'package:graphql/client.dart';
import 'package:graphqlapp/model/comment.dart';
import 'package:graphqlapp/model/post.dart';
import 'package:graphqlapp/service.dart';
import 'package:uuid/uuid.dart';

void main() async {
  final HttpLink httpLink = HttpLink(
    'http://localhost:8080/graphql',
  );

  const uuid = Uuid();
  String postId = '';

  final GraphQLClient client = GraphQLClient(
    cache: GraphQLCache(),
    link: httpLink,
  );

  final graphqlService = GraphQLService(client);

  group('Testando mutations', () {
    test('Create Post', () async {
      var random = uuid.v4();
      Post post = Post(content: 'Teste de content $random');
      var result = await graphqlService.createPost(post);
      expect(result, isNotNull);
      expect(result, isNotEmpty);
      postId = result.last.id!;
    });

    test('Create Comment', () async {
      var random = uuid.v4();
      Comment comment =
          Comment(content: 'Teste de comment $random', postId: postId);
      var result = await graphqlService.createComment(comment);

      expect(result, isNotNull);
      expect(result.length, greaterThan(0));
    });
  });

  group('Testando Queries', () {
    test('findByPostId', () async {
      var result = await graphqlService.fetchPostById(postId);
      expect(result, isNotNull);
      expect(result.id, postId);
      expect(result.comments, isNotEmpty);
    });
  });
}
