class GetTransactionsResponse {
  bool? status;
  String? message;
  List<TrasanctionData>? data;

  GetTransactionsResponse({this.status, this.message, this.data});

  GetTransactionsResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <TrasanctionData>[];
      json['data'].forEach((v) {
        data!.add(new TrasanctionData.fromJson(v));
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

class TrasanctionData {
  String? id;
  String? transactionId;
  String? transactionDetails;
  String? amount;
  String? discount;
  String? promoCode;
  String? userId;
  String? typeId;
  String? createdAt;
  String? planEnds;
  String? updatedAt;

  TrasanctionData(
      {this.id,
        this.transactionId,
        this.transactionDetails,
        this.amount,
        this.discount,
        this.promoCode,
        this.userId,
        this.typeId,
        this.createdAt,
        this.planEnds,
        this.updatedAt});

  TrasanctionData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    transactionId = json['transaction_id'];
    transactionDetails = json['transaction_details'];
    amount = json['amount'];
    discount = json['discount'];
    promoCode = json['promo_code'];
    userId = json['user_id'];
    typeId = json['type_id'];
    createdAt = json['created_at'];
    planEnds = json['plan_ends'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['transaction_id'] = this.transactionId;
    data['transaction_details'] = this.transactionDetails;
    data['amount'] = this.amount;
    data['discount'] = this.discount;
    data['promo_code'] = this.promoCode;
    data['user_id'] = this.userId;
    data['type_id'] = this.typeId;
    data['created_at'] = this.createdAt;
    data['plan_ends'] = this.planEnds;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
