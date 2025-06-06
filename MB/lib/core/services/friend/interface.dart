import 'package:pickleball_app/core/services/friend/dto/friend_response.dart';

abstract class IFriendService {
  Future<List<FriendResponse>> getFriendById(int uid);

  Future<List<FriendResponse>> getFriendsRequest(int currentPlayerId);

  Future<FriendResponse> addFriend(int currentPlayerId, int friendId);

  Future<bool> acceptFriend(int currentPlayerId, int requestFriendId);

  Future<FriendResponse> removeFriend(int currentPlayerId, int friendId);

}
