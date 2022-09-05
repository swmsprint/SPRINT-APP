class UserData {
  final int userId;
  final String nickname;
  final String email;
  final double height;
  final double weight;
  final int tierId;
  final String isFriend;

  const UserData({
    required this.userId,
    required this.nickname,
    required this.email,
    required this.height,
    required this.weight,
    required this.tierId,
    required this.isFriend,
  });

  UserData.fromJson(Map<String, dynamic> json)
      : userId = json['userId'],
        nickname = json['nickname'],
        email = json['email'],
        height = json['height'],
        weight = json['weight'],
        tierId = json['tierId'],
        isFriend = json['isFriend'];
}
