import 'dart:convert';

import 'package:pickleball_app/core/constants/app_global.dart';
import 'package:pickleball_app/core/services/friend/dto/friend_response.dart';
import 'package:pickleball_app/core/services/friend/endpoints/endpoints.dart';
import 'package:pickleball_app/core/services/friend/interface.dart';

class FriendService implements IFriendService {
  FriendService();

  @override
  Future<List<FriendResponse>> getFriendById(int uid) async {
    final response =
        await globalApiService.get('${Endpoints.getFriendById}/$uid');
    return (response['data'] as List)
        .map((json) => FriendResponse.fromJson(json))
        .toList();
  }

  @override
  Future<List<FriendResponse>> getFriendsRequest(int currentPlayerId) async {
    final response = await globalApiService.get(Endpoints.getFriendsRequest);
    return (response['data'] as List)
        .map((json) => FriendResponse.fromJson(json))
        .toList();
  }

  @override
  Future<FriendResponse> addFriend(int currentPlayerId, int friendId) async {
    final response = await globalApiService.post(
        Endpoints.addFriend, {'user1Id': currentPlayerId, 'user2Id': friendId});
    return FriendResponse.fromJson(response['data']);
  }

  @override
  Future<bool> acceptFriend(
      int currentPlayerId, int requestFriendId) async {
    final response = await globalApiService.post(Endpoints.acceptFriend,
        {'user1Id': currentPlayerId, 'user2Id': requestFriendId});
    return response['data'];
  }

  @override
  Future<FriendResponse> removeFriend(int currentPlayerId, int friendId) async {
    final response = await globalApiService.delete(
      Endpoints.removeFriend,
      jsonEncode({'user1Id': currentPlayerId, 'user2Id': friendId}),
    );
    return FriendResponse.fromJson(response['data']);
  }
}
