class GroupWeeklyStat {
  final double time;
  final double distance;

  const GroupWeeklyStat({
    required this.time,
    required this.distance,
  });

  GroupWeeklyStat.fromJson(Map<String, dynamic> json)
      : time = json['totalTime'] ?? 0,
        distance = json['totalDistance'] ?? 0;
}
