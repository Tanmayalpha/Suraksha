class LoginResponse {
  bool? status;
  String? message;
  LoginData? data;

  LoginResponse({this.status, this.message, this.data});

  LoginResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? new LoginData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class LoginData {
  User? user;

  LoginData({this.user});

  LoginData.fromJson(Map<String, dynamic> json) {
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    return data;
  }
}

class User {
  String? idUser;
  String? wallet_balance;
  String? group;
  String? fullName;
  String? firstName;
  String? lastName;
  dynamic? dateBirth;
  String? address;
  String? parentId;
  dynamic? city;
  String? state;
  String? country;
  dynamic? zipCode;
  String? mobile;
  String? email;
  String? password;
  String? lastIp;
  String? lastAccess;
  String? picture;
  String? language;
  String? tfa;
  String? plan_starts;
  String? suraksha_code;
  String? plan_ends;
  String? tfaSecret;
  String? tfaCode;
  dynamic? blocked;
  String? emailConfirmed;
  String? plan_amount;
  String? smsConfirmed;
  String? token;
  String? status;
  String? planStatus;
  String? createdAt;
  String? updatedAt;
  String? qr_code;
  String? profile;

  User(
      {this.idUser,
        this.group,
        this.profile,
        this.plan_ends,
        this.wallet_balance,
        this.suraksha_code,
        this.plan_starts,
        this.plan_amount,
        this.fullName,
        this.firstName,
        this.lastName,
        this.dateBirth,
        this.address,
        this.parentId,
        this.city,
        this.state,
        this.country,
        this.zipCode,
        this.mobile,
        this.email,
        this.password,
        this.lastIp,
        this.lastAccess,
        this.picture,
        this.language,
        this.tfa,
        this.tfaSecret,
        this.tfaCode,
        this.blocked,
        this.emailConfirmed,
        this.smsConfirmed,
        this.token,
        this.status,
        this.qr_code,
        this.planStatus,
        this.createdAt,
        this.updatedAt});

  User.fromJson(Map<String, dynamic> json) {
    idUser = json['id_user'];
    wallet_balance = json['wallet_balance'];
    plan_amount = json['plan_amount'];
    profile = json['picture'];
    plan_starts = json['plan_starts'];
    plan_ends = json['plan_ends'];
    suraksha_code = json['suraksha_code'];
    qr_code = json['qr_code'];
    group = json['group'];
    fullName = json['full_name'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    dateBirth = json['date_birth'];
    address = json['address'];
    parentId = json['parent_id'];
    city = json['city'];
    state = json['state'];
    country = json['country'];
    zipCode = json['zip_code'];
    mobile = json['mobile'];
    email = json['email'];
    password = json['password'];
    lastIp = json['last_ip'];
    lastAccess = json['last_access'];
    picture = json['picture'];
    language = json['language'];
    tfa = json['tfa'];
    tfaSecret = json['tfa_secret'];
    tfaCode = json['tfa_code'];
    blocked = json['blocked'];
    emailConfirmed = json['email_confirmed'];
    smsConfirmed = json['sms_confirmed'];
    token = json['token'];
    status = json['status'];
    planStatus = json['plan_status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id_user'] = this.idUser;
    data['group'] = this.group;
    data['full_name'] = this.fullName;
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['date_birth'] = this.dateBirth;
    data['address'] = this.address;
    data['parent_id'] = this.parentId;
    data['city'] = this.city;
    data['state'] = this.state;
    data['country'] = this.country;
    data['zip_code'] = this.zipCode;
    data['mobile'] = this.mobile;
    data['email'] = this.email;
    data['password'] = this.password;
    data['last_ip'] = this.lastIp;
    data['last_access'] = this.lastAccess;
    data['picture'] = this.picture;
    data['language'] = this.language;
    data['tfa'] = this.tfa;
    data['tfa_secret'] = this.tfaSecret;
    data['tfa_code'] = this.tfaCode;
    data['blocked'] = this.blocked;
    data['email_confirmed'] = this.emailConfirmed;
    data['sms_confirmed'] = this.smsConfirmed;
    data['token'] = this.token;
    data['status'] = this.status;
    data['plan_status'] = this.planStatus;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
