class VolunteerActivity {
  final int activityId;
  final String title;
  final String description;
  final String imageUrl;
  final String datetime;
  final int duration;
  final int targetAmount;
  final String type;
  final String locationName;
  final String orgId;
  final String orgName;

  VolunteerActivity({
    required this.activityId,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.datetime,
    required this.duration,
    required this.targetAmount,
    required this.type,
    required this.locationName,
    required this.orgId,
    required this.orgName,
  });

  factory VolunteerActivity.fromJson(Map<String, dynamic> json) {
    return VolunteerActivity(
      activityId: json['activity_id'] ?? 0,
      title: json['activity_title'] ?? '',
      description: json['activity_description'] ?? '',
      imageUrl: json['activity_img_url'] ?? '',
      datetime: json['activity_datetime'] ?? '',
      duration: json['activity_duration'] ?? 0,
      targetAmount: json['activity_target_amt'] ?? 0,
      type: json['activity_type'] ?? '',
      locationName: json['location_name'] ?? '',
      orgId: json['org_id'] ?? '',
      orgName: json['org_name'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'activity_id': activityId,
      'activity_title': title,
      'activity_description': description,
      'activity_img_url': imageUrl,
      'activity_datetime': datetime,
      'activity_duration': duration,
      'activity_target_amt': targetAmount,
      'activity_type': type,
      'org_id': orgId,
      'org_name': orgName,
    };
  }
}
