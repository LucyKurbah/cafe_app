class Conference{
    
    int id;
    late String conference_name, image;
    late double price;

    Conference({required this.conference_name, required this.image, required this.price, required this.id});

  factory Conference.fromJson(Map<String, dynamic> json){
    return Conference(
      id : json['id'],
      conference_name : json['conference_name'],
      image : json['path_file'],
      price : double.parse(json['price']),
    
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'conference_name': conference_name,
      'price' : price,
      'image' :image
    };
  }

}