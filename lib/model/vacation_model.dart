
class VacationsModel{
  int id;
  String startDate;
  String endDate;
  String comments;
  String? startTime;
  String? endTime;

  VacationsModel({
    required this.id,
    required this.startDate,
    required this.endDate,
    required this.comments,
    this.startTime,
    this.endTime,
  });

factory VacationsModel.fromJson(Map<String, dynamic> json) {
  return VacationsModel(
      id: json['vacation_id'],
      startDate: json['start_date'],
      endDate: json['end_date'],
      comments: json['comments'] ?? "",
      startTime: json['startTime'] ?? "", 
      endTime: json['endTime'] ?? ""
    );
  }
}