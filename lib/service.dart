import 'package:graphql/client.dart';

import 'model/comment.dart';
import 'model/post.dart';

class GraphQLService {
  final GraphQLClient _client;

  GraphQLService(this._client);

  Future<Post> fetchPostById(String postId) async {
    final query = gql('''
      query FetchPostById(\$postId: ID!) {
        postById(id: \$postId) {
          id
          content
          comments {
            id
            content
            postId
          }
        }
      }
    ''');

    final variables = {'postId': postId};

    final result = await _client.query(
      QueryOptions(
        document: query,
        variables: variables,
      ),
    );

    if (result.hasException) {
      throw Exception(result.exception.toString());
    }

    final postJson = result.data?['postById'];
    return Post.fromJson(postJson);
  }

  Future<List<Post>> createPost(Post post) async {
    final mutation = gql('''
      mutation CreatePost(\$content: String!) {
        createPost(content: \$content) {
          id
          content
          comments {
            id
            content
            postId
          }
        }
      }
    ''');

    final variables = {'content': post.content};

    final result = await _client.mutate(
      MutationOptions(
        document: mutation,
        variables: variables,
      ),
    );

    if (result.hasException) {
      throw Exception(result.exception.toString());
    }

    var map = result.data?['createPost'];
    List<Post> list = [];
    map.forEach((value) => list.add(Post.fromJson(value)));
    return list;
  }

  Future<List<Comment>> createComment(Comment comment) async {
    final mutation = gql('''
      mutation CreateComment(\$content: String!, \$postId: String!) {
        createComment(content: \$content, postId: \$postId) {
          id
          content
          postId
        }
      }
    ''');

    final variables = {'content': comment.content, 'postId': comment.postId};

    final result = await _client.mutate(
      MutationOptions(
        document: mutation,
        variables: variables,
      ),
    );

    if (result.hasException) {
      throw Exception(result.exception.toString());
    }

    final commentJson = result.data?['createComment'];
    List<Comment> comments = [];
    commentJson.forEach((val) => comments.add(Comment.fromJson(val)));
    return comments;
  }
}
