import 'package:flutter_test/flutter_test.dart';
import 'package:graphql/client.dart';
import 'package:graphqlapp/model/comment.dart';
import 'package:graphqlapp/model/post.dart';
import 'package:graphqlapp/service2.dart';
import 'package:uuid/uuid.dart';

void main() async {
  const uuid = Uuid();
  String postId = '';

  final graphqlService = GraphQLService.getInstance();

  group('Testando mutations', () {
    test('Create Post', () async {
      var random = uuid.v4();
      String mutationName = 'createPost';
      Post post = Post(content: 'Teste de content $random');
      var result = await graphqlService.mutate(
        mutationName: mutationName,
        options: MutationOptions(
          document: gql('''
            mutation CreatePost(\$content: String!) {
              $mutationName(content: \$content) {
                id
                content
                comments {
                  id
                  content
                  postId
                }
              }
            }
          '''),
          variables: {'content': post.content},
        ),
      );
      expect(result, isNotNull);
      expect(result, isNotEmpty);
      List<Post> posts = [];
      result.forEach((json) => posts.add(Post.fromJson(json)));
      postId = posts.last.id!;
    });

    test('Create Comment', () async {
      var random = uuid.v4();
      String mutationName = 'createComment';
      Comment comment =
          Comment(content: 'Teste de comment $random', postId: postId);
      var result = await graphqlService.mutate(
          mutationName: mutationName,
          options: MutationOptions(
            document: gql('''
            mutation CreateComment(\$content: String!, \$postId: String!) {
              $mutationName(content: \$content, postId: \$postId) {
                id
                content
                postId
              }
            }
          '''),
            variables: {'content': comment.content, 'postId': postId},
          ));

      expect(result, isNotNull);
      expect(result, isNotEmpty);
    });
  });

  group('Testando Queries', () {
    test('findByPostId', () async {
      String queryName = 'postById';
      var result = await graphqlService.query(
          queryName: queryName,
          options: QueryOptions(
            document: gql('''
      query FetchPostById(\$postId: ID!) {
        $queryName(id: \$postId) {
          id
          content
          comments {
            id
            content
            postId
          }
        }
      }
    '''),
            variables: {'postId': postId},
          ));
      expect(result, isNotNull);
      expect(Post.fromJson(result).id, postId);
      expect(Post.fromJson(result).comments, isNotEmpty);
    });
  });
}
