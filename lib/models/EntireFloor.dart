class EntireFloor{
    
    int id;
    late String floor_name, image;
    late double price;

    EntireFloor({required this.id,
    required this.floor_name, required this.image, required this.price, 
    });

  factory EntireFloor.fromJson(Map<String, dynamic> json){
    print(json);
    return EntireFloor(
      id : (json['id']),
      floor_name : json['floor_name'],
      image : json['path_file'],
      price : double.parse(json['price']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'floor_name': floor_name,
      'price' : price,
      'image' :image
    };
  }

}