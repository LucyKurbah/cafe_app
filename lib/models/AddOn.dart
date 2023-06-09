class AddOn{
    
    int? id, quantity;
    late String title, image, desc;
    late double price;


    AddOn({this.quantity,required this.title, required this.image, required this.price, required this.id, required this.desc});

  factory AddOn.fromJson(Map<String, dynamic> json){

    return AddOn(
      id : json['id'],
      title : json['item_name'],
      image : json['path_file'],
      price : double.parse(json['price']),
      desc : json['description'],
      quantity : json['item_quantity'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'desc' : desc,
      'price' : price,
      'image' :image,
      'quantity': quantity
    };
  }

}