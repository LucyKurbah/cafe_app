

class TableCart {
  int user_id, table_id;
  double table_price;
  String image, table_name, flag;
  String date, timeFrom, timeTo;

  TableCart({
    required this.table_id,
    required this.flag,
    required this.user_id,
    required this.image,
    required this.date,
    required this.timeFrom,
    required this.timeTo, 
    required this.table_price,
    required this.table_name
  });

  @override
  String toString() {
    return 'TableCart: table_name: $table_name, table_id: $table_id,table_price: $table_price, user_id: $user_id, image: $image,flag: $flag,date: $date, timeFrom: $timeFrom,timeTo: $timeTo';
  }

  factory TableCart.fromJson(Map<String, dynamic> json) {

    return TableCart(
      table_id: json['table_id'] ?? 0,
      user_id: json['user_id'] ?? 0,
      table_price: double.parse(json['table_price'] ?? '0'),
      image: json['path_file'] ?? '',
      table_name: json['table_name'] ?? '',
      flag: json['flag'] ?? '',
      date: json['date'] ?? '',
      timeFrom: json['timeFrom'] ?? '',
      timeTo: json['timeTo'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'table_id': table_id,
      'user_id': user_id,
      'table_price': table_price,
      'image': image,
      'table_name': table_name,
      'flag': flag,
      'date': date,
      'timeFrom': timeFrom,
      'timeTo': timeTo,
    };
  }
}
