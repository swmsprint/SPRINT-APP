class GroupInfo {
  final int groupId;
  final String groupName;
  final String groupDescription;
  final int groupLeaderId;
  final int groupPersonnel;
  final String groupPicture;
  final String groupWeeklyStat;
  final String groupWeeklyUserData;

  const GroupInfo({
    required this.groupId,
    required this.groupName,
    required this.groupDescription,
    required this.groupLeaderId,
    required this.groupPersonnel,
    required this.groupPicture,
    required this.groupWeeklyStat,
    required this.groupWeeklyUserData,
  });

  GroupInfo.fromJson(Map<String, dynamic> json)
      : groupId = json['groupId'] ?? 0,
        groupName = json['groupName'] ?? '',
        groupDescription = json['groupDescription'] ?? '',
        groupLeaderId = json['groupLeaderId'] ?? 0,
        groupPersonnel = json['groupPersonnel'] ?? 0,
        groupPicture = json['groupPicture'] ?? '',
        groupWeeklyStat = json['groupWeeklyStat'] ?? '',
        groupWeeklyUserData = json['groupWeeklyUserData'] ?? '';
}
