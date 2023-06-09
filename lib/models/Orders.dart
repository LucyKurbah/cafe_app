class Order {

  int id, user_id,  item_id, quantity; 
  double item_price, total;
  String image, item_name, order_date;

  Order({required this.item_name, required this.id, required this.user_id, required this.item_id, required this.quantity, required this.item_price, required this.total,
  required this.image, required this.order_date});

  factory Order.fromJson(Map<String, dynamic> json) {
    print(json);
    return Order(
      item_name :  json['item_name'],
      id: json['id'],
      image: json['path_file'],
      item_id: json['item_id'], 
      item_price: double.parse(json['item_price']), 
      quantity: json['item_quantity'], 
      user_id: json['user_id'],
      total: double.parse(json['price']),
      order_date : json['order_date'],
    );
  }

  Map<String, dynamic> toJson() => {
      'item_name' : item_name,
      'id': id,
      'image': image,        
      'item_id': item_id,
      'item_price': item_price, 
      'quantity': quantity, 
      'user_id': user_id,
      'total' : total,
      'order_date' : order_date
  };
}