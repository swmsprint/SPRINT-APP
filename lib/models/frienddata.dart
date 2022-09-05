class FriendData {
  final int userId;
  final String nickname;
  final String email;
  final double height;
  final double weight;
  final int tierId;

  const FriendData({
    required this.userId,
    required this.nickname,
    required this.email,
    required this.height,
    required this.weight,
    required this.tierId,
  });

  FriendData.fromJson(Map<String, dynamic> json)
      : userId = json['userId'],
        nickname = json['nickname'],
        email = json['email'],
        height = json['height'],
        weight = json['weight'],
        tierId = json['tierId'];
}
