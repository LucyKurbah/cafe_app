

class Cart {
  int user_id, item_id, quantity;
  double item_price;
  String image, item_name, flag;
  int count;
  String? date, timeFrom,timeTo;

  Cart({
    required this.flag,
    required this.item_id,
    required this.user_id,
    required this.item_price,
    required this.quantity,
    required this.image,
    required this.item_name,
    required this.count,
    this.date,
    this.timeFrom,
    this.timeTo
  });

  @override
  String toString() {
    return 'Cart: item_name: $item_name, item_id: $item_id,item_price: $item_price, quantity: $quantity, user_id: $user_id, image: $image,flag: $flag,count: $count';
  }

  factory Cart.fromJson(Map<String, dynamic> json) {
    print(json);
    return Cart(
      item_id: json['item_id'] ?? 0,
      user_id: json['user_id'] ?? 0,
      item_price: double.parse(json['item_price'] ?? '0'),
      quantity: json['item_quantity'] ?? 0,
      image: json['path_file'] ?? '',
      item_name: json['item_name'] ?? '',
      flag: json['flag'] ?? '',
      count: json['item_quantity'] ?? 0,
       date: json['order_date'] ?? '',
      timeFrom: json['time_from'] ?? '',
      timeTo: json['time_to'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'item_id': item_id,
      'user_id': user_id,
      'item_price': item_price,
      'quantity': quantity,
      'image': image,
      'item_name': item_name,
      'flag': flag,
      'count': count,
       'date': date,
      'timeFrom': timeFrom,
      'timeTo': timeTo,
    };
  }
}
