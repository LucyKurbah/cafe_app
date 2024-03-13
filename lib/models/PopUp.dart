class PopUp{
    
  int? id;
  late String pop_up_name, image;


  PopUp({required this.pop_up_name, required this.image, required this.id});

  factory PopUp.fromJson(Map<String, dynamic> json){

    return PopUp(
      id : json['id'],
      pop_up_name : json['pop_up_name'],
      image : json['path_file'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'pop_up_name': pop_up_name,
      'image' :image,
    };
  }

}