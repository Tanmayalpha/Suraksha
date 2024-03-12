class CallLogsRsponse {
  bool? status;
  String? message;
  List<CallLogsData>? data;

  CallLogsRsponse({this.status, this.message, this.data});

  CallLogsRsponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <CallLogsData>[];
      json['data'].forEach((v) {
        data!.add(new CallLogsData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CallLogsData {
  String? id;
  String? channelId;
  String? callDialed;
  String? callStarts;
  String? callEnds;
  dynamic? callStatus;
  String? callerImage;
  String? createdAt;
  String? updatedAt;
  String? duration;
  String? message;

  CallLogsData(
      {this.id,
        this.channelId,
        this.callDialed,
        this.callStarts,
        this.callEnds,
        this.callStatus,
        this.callerImage,
        this.duration,
        this.createdAt,
        this.updatedAt});

  CallLogsData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    channelId = json['channel_id'];
    duration = json['duration'];
    callDialed = json['call_dialed'];
    callStarts = json['call_starts'];
    callEnds = json['call_ends'];
    callStatus = json['call_status'] !=null ? json['call_status'].toString() : '0';
    callerImage = json['caller_image'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['channel_id'] = this.channelId;
    data['call_dialed'] = this.callDialed;
    data['call_starts'] = this.callStarts;
    data['call_ends'] = this.callEnds;
    data['call_status'] = this.callStatus;
    data['caller_image'] = this.callerImage;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
