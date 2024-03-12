// To parse this JSON data, do
//
//     final signupResponse = signupResponseFromJson(jsonString);

import 'dart:convert';

SignupResponse signupResponseFromJson(String str) => SignupResponse.fromJson(json.decode(str));

String signupResponseToJson(SignupResponse data) => json.encode(data.toJson());

class SignupResponse {
  bool? error;
  String? message;
  SignupData? data;

  SignupResponse({
    this.error,
    this.message,
    this.data,
  });

  factory SignupResponse.fromJson(Map<String, dynamic> json) => SignupResponse(
    error: json["error"],
    message: json["message"],
    data: SignupData.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "error": error,
    "message": message,
    "data": data!.toJson(),
  };
}

class SignupData {
  String? token;
  String? fullName;
  dynamic dateBirth;
  String? email;
  String? mobile;
  String? picture;
  String? language;
  String? address;
  String? state;
  String? country;
  dynamic zipCode;
  String? status;
  String? plan_active;
  DateTime? createdAt;
  DateTime? updatedAt;

  SignupData({
    this.token,
    this.fullName,
    this.dateBirth,
    this.email,
    this.mobile,
    this.picture,
    this.language,
    this.address,
    this.state,
    this.country,
    this.zipCode,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.plan_active,
  });

  factory SignupData.fromJson(Map<String, dynamic> json) => SignupData(
    token: json["token"],
    plan_active: json["plan_active"],
    fullName: json["full_name"],
    dateBirth: json["date_birth"],
    email: json["email"],
    mobile: json["mobile"],
    picture: json["picture"],
    language: json["language"],
    address: json["address"],
    state: json["state"],
    country: json["country"],
    zipCode: json["zip_code"],
    status: json["status"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "token": token,
    "full_name": fullName,
    "date_birth": dateBirth,
    "email": email,
    "mobile": mobile,
    "picture": picture,
    "language": language,
    "address": address,
    "state": state,
    "country": country,
    "zip_code": zipCode,
    "status": status,
    "created_at": createdAt!.toIso8601String(),
    "updated_at": updatedAt!.toIso8601String(),
  };
}
