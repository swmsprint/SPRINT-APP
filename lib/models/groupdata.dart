class GroupData {
  final int groupId;
  final String groupName;
  final String groupDescription;
  final int groupPersonnel;
  final int groupMaxPersonnel;
  final String isMember;

  const GroupData({
    required this.groupId,
    required this.groupName,
    required this.groupDescription,
    required this.groupPersonnel,
    required this.groupMaxPersonnel,
    required this.isMember,
  });

  GroupData.fromJson(Map<String, dynamic> json)
      : groupId = json['groupId'] ?? 0,
        groupName = json['groupName'] ?? '',
        groupDescription = json['groupDescription'] ?? '',
        groupPersonnel = json['groupPersonnel'] ?? 0,
        groupMaxPersonnel = json['groupMaxPersonnel'] ?? 0,
        isMember = json['isMember'] ?? 'NOT_MEMBER';
}
