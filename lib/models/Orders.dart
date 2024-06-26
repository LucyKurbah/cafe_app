class Order {

  int id, user_id,  item_id, quantity; 
  double item_price, total;
  String image, item_name, order_date;
  String? table_date;
  String time_to, time_from, flag;


  Order({required this.item_name, required this.id, required this.user_id, required this.item_id, required this.quantity, required this.item_price, required this.total,
  required this.image, required this.order_date, required this.time_to, required this.time_from, required this.flag, this.table_date});

  factory Order.fromJson(Map<String, dynamic> json) {
    print(json);
    print( json['time_to']);
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
      table_date : json['table_date'],
      time_to :  json['time_to'],
      time_from : json['time_from'],
      flag : json['flag']
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
      'order_date' : order_date,
       'table_date' : table_date,
      'time_to' : time_to,
      'time_from': time_from,
      'flag' : flag
  };
}