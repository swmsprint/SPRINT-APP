class MemberData {
  final int userId;
  final String nickname;
  final String profile;
  final int tierId;
  final double distance;
  final double seconds;


  const MemberData({
    required this.userId,
    required this.nickname,
    required this.profile,
    required this.tierId,
    required this.distance,
    required this.seconds,
  });

  MemberData.fromJson(Map<String, dynamic> json)
      : userId = json['id'],
        nickname = json['nickName'],
        profile = json['picture'],
        tierId = json['tierId'],
        distance = json['distance'],
        seconds = json['totalSeconds'];
}
