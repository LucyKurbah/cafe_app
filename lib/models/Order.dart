class OrderModel{
    
    int? table_id, user_id, order_status_id, payment_id;
    late String time_from, time_to, book_date;

    OrderModel({required this.table_id, required this.user_id, required this.order_status_id, required this.payment_id, required this.time_from, required this.time_to, required this.book_date});

factory OrderModel.fromJson(Map<String, dynamic> json){
    print("json");
    print(json[0]);
    return OrderModel(
      table_id : json['table_id'],
      user_id : json['user_id'],
      order_status_id : json['order_status_id'],
      payment_id : json['payment_id'],
      time_from :json['time_from'],
      time_to : json['time_to'],
      book_date :json['book_date'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'table_id': table_id,
      'user_id': user_id,
      'order_status_id': order_status_id,
      'time_to' : time_to,
      'time_from' : time_from,
      'payment_id' :payment_id,
      'book_date' : book_date
    };
  }

}