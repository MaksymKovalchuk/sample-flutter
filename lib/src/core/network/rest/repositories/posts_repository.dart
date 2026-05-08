import 'package:sample/src/core/network/api_model.dart';
import 'package:sample/src/core/network/constants/api_methods.dart';
import 'package:sample/src/core/network/constants/api_router.dart';
import 'package:sample/src/core/network/rest_client.dart';
import 'package:sample/src/feature/home/model/post.dart';

class PostsRepository {
  PostsRepository(this._restClient);
  final RestClient _restClient;

  Future<List<Post>> fetchPosts({int limit = 20}) async {
    final resp = await _restClient.request<List<dynamic>>(
      bypassInitializer: true,
      apiModel: ApiModel(
        serviceType: ServiceType.main,
        method: Method.get,
        pathUrl: '/posts?_limit=$limit',
      ),
    );

    return resp
        .cast<Map<String, dynamic>>()
        .map(Post.fromJson)
        .toList(growable: false);
  }
}
