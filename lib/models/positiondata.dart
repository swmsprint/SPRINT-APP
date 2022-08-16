class PositionData {
  final double latitude;
  final double longitude;
  final double altitude;
  final double speed;
  final String timestamp;

  const PositionData({
    required this.latitude,
    required this.longitude,
    required this.altitude,
    required this.speed,
    required this.timestamp,
  });

  Map<String, dynamic> toJson() => {
        'latitude': latitude,
        'longitude': longitude,
        'altitude': altitude,
        'speed': speed,
        'timestamp': timestamp
      };
}
