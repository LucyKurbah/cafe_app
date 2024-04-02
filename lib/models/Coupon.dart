class Coupon {
  final int id;
  final String coupon_name;
  final double amount;
  final String validity;
  final bool active;

  Coupon({
    required this.id,
    required this.coupon_name,
    required this.amount,
    required this.validity,
    required this.active,
  });

  factory Coupon.fromJson(Map<String, dynamic> json) {
    return Coupon(
      id: json['id'],
      coupon_name: json['coupon_name'] ?? '',
      amount: json['amount'] != null ? double.parse(json['amount'].toString()) : 0.0,
      validity: json['validity'] ?? '',
      active: json['active'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'coupon_name': coupon_name,
      'amount': amount,
      'validity': validity,
      'active': active.toString()
    };
  }
}