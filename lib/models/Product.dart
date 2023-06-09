class Product{
    
    int? id;
    late String title, image, desc;
    late double price;
    int? quantity;

    Product({required this.quantity, required this.title, required this.image, required this.price, required this.id, required this.desc});

  factory Product.fromJson(Map<String, dynamic> json){
    print(json);
    return Product(
      id : json['id'],
      title : json['food_name'],
      image : json['path_file'],
      price : double.parse(json['price']),
      desc : json['description'],
      quantity : json['quantity'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'desc' : desc,
      'price' : price,
      'image' :image,
      'quantity' :quantity
    };
  }

}
