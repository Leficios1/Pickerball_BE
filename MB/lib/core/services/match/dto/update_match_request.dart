class UpdateMatchRequest {
  final String? title;
  final String? description;
  final DateTime? matchDate;
  final int? venueId;
  final int? status;
  final int? matchCategory;
  final int? matchFormat;
  final int? winScore;
  final bool? isPublic;
  final int? refereeId;

  UpdateMatchRequest({
    this.title,
    this.description,
    this.matchDate,
    this.venueId,
    this.status,
    this.matchCategory,
    this.matchFormat,
    this.winScore,
    this.isPublic,
    this.refereeId,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (title != null) {
      data['title'] = title;
    }
    if (description != null) {
      data['description'] = description;
    }
    if (matchDate != null) {
      data['matchDate'] = matchDate!.toIso8601String();
    }
    if (venueId != null) {
      data['venueId'] = venueId;
    }
    if (status != null) {
      data['status'] = status;
    }
    if (matchCategory != null) {
      data['matchCategory'] = matchCategory;
    }
    if (matchFormat != null) {
      data['matchFormat'] = matchFormat;
    }
    if (winScore != null) {
      data['winScore'] = winScore;
    }
    if (isPublic != null) {
      data['isPublic'] = isPublic;
    }
    if (refereeId != null) {
      data['refereeId'] = refereeId;
    }
    return data;
  }
}
