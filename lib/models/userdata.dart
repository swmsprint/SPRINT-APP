class UserData {
  final int userId;
  final String nickname;
  final String profile;
  final double height;
  final double weight;
  final int tierId;
  final String isFriend;

  const UserData({
    required this.userId,
    required this.nickname,
    required this.profile,
    required this.height,
    required this.weight,
    required this.tierId,
    required this.isFriend,
  });

  UserData.fromJson(Map<String, dynamic> json)
      : userId = json['userId'] ?? 0,
        nickname = json['nickname'] ?? '',
        profile = json['picture'] ?? '',
        height = json['height'] ?? 175,
        weight = json['weight'] ?? 70,
        tierId = json['tierId'] ?? 1,
        isFriend = json['isFriend'] ?? 'NOT_FRIEND';
}
