class ApplyCouponResponse {
  bool? status;
  String? message;
  ApplyPromoData? data;

  ApplyCouponResponse({this.status, this.message, this.data});

  ApplyCouponResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? new ApplyPromoData.fromJson(json['data']) : null;
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

class ApplyPromoData {
  int? updatedPrice;
  int? discountAmount;

  ApplyPromoData({this.updatedPrice, this.discountAmount});

  ApplyPromoData.fromJson(Map<String, dynamic> json) {
    updatedPrice = json['updated_price'];
    discountAmount = json['discount_amount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['updated_price'] = this.updatedPrice;
    data['discount_amount'] = this.discountAmount;
    return data;
  }
}
