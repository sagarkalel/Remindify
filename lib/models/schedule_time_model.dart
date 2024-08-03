class ScheduleTimeModel {
  final int daysBefore;
  final int id;

  /// time in 17:00 format
  final String time;

  const ScheduleTimeModel(
      {required this.daysBefore, required this.time, this.id = 0});

  factory ScheduleTimeModel.fromMap(Map<String, dynamic> map) {
    return ScheduleTimeModel(
      daysBefore: map['days_before'] ?? 0,
      id: map['scheduled_time_id'] ?? 0,
      time: map['time'] ?? '00:00',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'time': time,
      'days_before': daysBefore,
    };
  }
}
