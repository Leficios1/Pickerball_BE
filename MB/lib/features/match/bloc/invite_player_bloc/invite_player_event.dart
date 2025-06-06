abstract class InvitePlayerEvent {}

class LoadFriends extends InvitePlayerEvent {
  final String type;

  LoadFriends({required this.type});
}

class LoadAllPlayers extends InvitePlayerEvent {}

class AddPlayer extends InvitePlayerEvent {
  final int matchId;
  final int playerRecieveId;

  AddPlayer({required this.matchId, required this.playerRecieveId});
}
