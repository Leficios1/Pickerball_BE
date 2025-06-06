enum Gender {
  male(1, "Male"),
  female(2, "Female"),
  other(3, "Other");

  final int value;
  final String label;

  const Gender(this.value, this.label);

  static Gender? fromValue(int value) {
    return Gender.values
        .firstWhere((e) => e.value == value, orElse: () => Gender.other);
  }
}

enum RoleUser {
  player(1, "Player"),
  admin(2, "Admin"),
  sponsor(3, "Sponsor"),
  referee(4, "Referee");

  final int value;
  final String label;

  const RoleUser(this.value, this.label);

  static RoleUser? fromValue(int value) {
    return RoleUser.values
        .firstWhere((e) => e.value == value, orElse: () => RoleUser.player);
  }
}

enum MatchStatus {
  scheduled(1, "Scheduled"),
  ongoing(2, "Ongoing"),
  completed(3, "Completed"),
  disabled(4, "Disabled");

  final int value;
  final String label;

  const MatchStatus(this.value, this.label);

  static MatchStatus? fromValue(int value) {
    return MatchStatus.values.firstWhere((e) => e.value == value,
        orElse: () => MatchStatus.disabled);
  }
}

enum MatchCategory {
  competitive(1, "Competitive"),
  custom(2, "Custom"),
  tournament(3, "Tournament");

  final int value;
  final String label;

  const MatchCategory(this.value, this.label);

  static MatchCategory? fromValue(int value) {
    return MatchCategory.values.firstWhere((e) => e.value == value,
        orElse: () => MatchCategory.competitive);
  }
}

enum TournamentFormant {
  single(1, "Singles", "Single"),
  doubles(2, "Doubles", "Doubles");

  final int value;
  final String label;
  final String subLabel;

  const TournamentFormant(this.value, this.label, this.subLabel);

  static TournamentFormant? fromValue(int value) {
    return TournamentFormant.values.firstWhere((e) => e.value == value,
        orElse: () => TournamentFormant.single);
  }
}

enum MatchFormat {
  singleMale(1, "SinglesMale", "Single Male"),
  singleFemale(2, "SinglesFemale", "Single Female"),
  doubleMale(3, "DoublesMale", "Doubles Male"),
  doubleFemale(4, "DoublesFemale", "Doubles Female"),
  doubleMix(5, "DoublesMix", "Doubles Mix");

  final int value;
  final String label;
  final String subLabel;

  const MatchFormat(this.value, this.label, this.subLabel);

  static MatchFormat? fromValue(int value) {
    return MatchFormat.values.firstWhere((e) => e.value == value,
        orElse: () => MatchFormat.singleMale);
  }

  static MatchFormat? fromString(String value) {
    return MatchFormat.values.firstWhere((e) => e.label == value,
        orElse: () => MatchFormat.singleMale);
  }
}

enum MatchWinScore {
  eleven(11, "11"),
  fifteen(15, "15"),
  twentyOne(21, "21");

  final int value;
  final String label;

  const MatchWinScore(this.value, this.label);

  static MatchWinScore? fromValue(int value) {
    return MatchWinScore.values.firstWhere((e) => e.value == value,
        orElse: () => MatchWinScore.eleven);
  }
}

enum MatchPrivate {
  public(1, "Public"),
  private(2, "Private");

  final int value;
  final String label;

  const MatchPrivate(this.value, this.label);

  static MatchPrivate? fromValue(int value) {
    return MatchPrivate.values
        .firstWhere((e) => e.value == value, orElse: () => MatchPrivate.public);
  }
}

enum RankLevel {
  level1(1, "Level 1", "Lv 1"),
  level2(2, "Level 2", "Lv 2"),
  level3(3, "Level 3", "Lv 3"),
  level4(4, "Level 4", "Lv 4"),
  level5(5, "Level 5", "Lv 5"),
  level6(6, "Level 6", "Lv 6"),
  level7(7, "Level 7", "Lv 7"),
  level8(8, "Level 8", "Lv 8"),
  level9(9, "Level 9", "Lv 9");

  final int value;
  final String label;
  final String subLabel;

  const RankLevel(this.value, this.label, this.subLabel);

  static RankLevel? fromValue(int value) {
    return RankLevel.values
        .firstWhere((e) => e.value == value, orElse: () => RankLevel.level1);
  }
  static RankLevel? fromString(String value) {
    return RankLevel.values.firstWhere((e) => e.label == value,
        orElse: () => RankLevel.level1);
  }
  static RankLevel? fromSubString(String value) {
    return RankLevel.values.firstWhere((e) => e.subLabel == value,
        orElse: () => RankLevel.level1);
  }
}

enum TournamentTeamStatus {
  pending(1, "Pending"), // Da accept tu partner cho payment
  approved(2, "Approved"), // Da payment
  rejected(3, "Rejected"), // Ko dong y cho tham gia giai dau
  waiting(4, "Waiting"), // Cho accept tu partner
  eliminated(5, "Eliminated"), // Bi loai
  waitingForInvitation(6,
      "Waiting for Invitation"); // Bạn nhận được lời mời tham gia tournament từ người chơi khác

  final int value;
  final String label;

  const TournamentTeamStatus(this.value, this.label);

  static TournamentTeamStatus? fromValue(int value) {
    return TournamentTeamStatus.values.firstWhere(
      (e) => e.value == value,
      orElse: () => TournamentTeamStatus.eliminated,
    );
  }
}

enum UserRole {
  player(1,
      "Player"), //Người dùng chưa join vào tournament, chưa có lời mời join tournament từ player khác
  playerParticipated(
      2, "Player Participated"), //Người dùng đã join vào tournament == approved
  playerPayment(3, "Player Payment"), //Người dùng chưa thanh toán == pending
  playerRejected(4,
      "Player Rejected"), //Người dùng đã từ chối lời mời tham gia tournament == rejected
  playerWaiting(5,
      "Player Waiting"), //Người dùng đã gửi lời mời tham gia tournament nhưng chưa có phản hồi từ người chơi khác == waiting
  playerEliminated(
      6, "Player Eliminated"), //Người dùng đã bị loại khỏi  == eliminated
  invitedPlayer(
      7, "Invited Player"), // Người chơi nhận được lời mời từ người khác
  waitingPayment(8,
      "Waiting Payment"), //Người dùng đã chấp nhận lời mời tham gia tournament nhưng chưa payment
  sponsor(9,
      "Sponsor"), //Người dùng là sponsor nhưng không phải là người tổ chức tournament
  sponsorOwner(10,
      "Sponsor Owner"); //Người dùng là sponsor và là người tổ chức tournament

  final int value;
  final String label;

  const UserRole(this.value, this.label);

  static UserRole? fromValue(int value) {
    return UserRole.values
        .firstWhere((e) => e.value == value, orElse: () => UserRole.player);
  }
}

enum NotificationType {
  friendRequest(1, "FriendRequest"),
  matchRequest(2, "MatchRequest"),
  tournamentRequest(3, "TournamentTeamRequest"),
  accpetTournamentTeamRequest (4, "AccpetTournamentTeamRequest"),
  acceptMatchRequest (5, "AcceptMatchRequest "),
  other(6, "Other");

  final int value;
  final String label;

  const NotificationType(this.value, this.label);

  static NotificationType? fromValue(int value) {
    return NotificationType.values.firstWhere(
        (e) => e.value == value,
        orElse: () => NotificationType.friendRequest);
  }

  static NotificationType? fromString(String value) {
    return NotificationType.values.firstWhere(
        (e) => e.label == value,
        orElse: () => NotificationType.friendRequest);
  }
}

enum PaymentMethod {
  vnpay,
  payos,
}
