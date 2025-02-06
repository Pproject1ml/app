class EnterLeaveModel {
  final String profileId;
  final String chatroomId;

  EnterLeaveModel({required this.chatroomId, required this.profileId});

  /// 객체 -> JSON
  Map<String, dynamic> toJson() {
    return {
      'chatroomId': chatroomId,
      'profileId': profileId,
    };
  }
}
