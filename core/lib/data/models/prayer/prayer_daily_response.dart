import 'package:core/data/models/prayer/prayer_daily_model.dart';
import 'package:core/domain/entities/prayer/prayer_daily_response_e.dart';
import 'package:equatable/equatable.dart';

class PrayerDailyResponse extends Equatable {
  PrayerDailyResponse({
    required this.status,
    this.data,
  });

  bool status;
  PrayerDailyModel? data;

  factory PrayerDailyResponse.fromJson(Map<String, dynamic> json) =>
      PrayerDailyResponse(
        status: json["status"],
        data: json["data"] == null
            ? null
            : PrayerDailyModel.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "data": data!.toJson(),
      };

  PrayerDailyResponseE toEntity() {
    return PrayerDailyResponseE(
        status: status, prayerDaily: data == null ? null : data!.toEntity());
  }

  @override
  List<Object?> get props => [status, data];
}