class NotificationResponse {
  bool? status;
  String? message;
  List<NotificationData>? data;

  NotificationResponse({this.status, this.message, this.data});

  NotificationResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <NotificationData>[];
      json['data'].forEach((v) {
        data!.add(new NotificationData.fromJson(v));
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

class NotificationData {
  String? idNotification;
  String? userSender;
  String? userRecipient;
  String? title;
  String? body;
  String? isRead;
  String? isSendEmail;
  String? isSendSms;
  String? sendEmailNotification;
  String? sendSmsNotification;
  String? token;
  String? createdAt;
  String? updatedAt;

  NotificationData(
      {this.idNotification,
        this.userSender,
        this.userRecipient,
        this.title,
        this.body,
        this.isRead,
        this.isSendEmail,
        this.isSendSms,
        this.sendEmailNotification,
        this.sendSmsNotification,
        this.token,
        this.createdAt,
        this.updatedAt});

  NotificationData.fromJson(Map<String, dynamic> json) {
    idNotification = json['id_notification'];
    userSender = json['user_sender'];
    userRecipient = json['user_recipient'];
    title = json['title'];
    body = json['body'];
    isRead = json['is_read'];
    isSendEmail = json['is_send_email'];
    isSendSms = json['is_send_sms'];
    sendEmailNotification = json['send_email_notification'];
    sendSmsNotification = json['send_sms_notification'];
    token = json['token'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id_notification'] = this.idNotification;
    data['user_sender'] = this.userSender;
    data['user_recipient'] = this.userRecipient;
    data['title'] = this.title;
    data['body'] = this.body;
    data['is_read'] = this.isRead;
    data['is_send_email'] = this.isSendEmail;
    data['is_send_sms'] = this.isSendSms;
    data['send_email_notification'] = this.sendEmailNotification;
    data['send_sms_notification'] = this.sendSmsNotification;
    data['token'] = this.token;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
