class ProfileModel{
    
  int id;
  late String name, doc_image;
  late String email, phone_no;

  ProfileModel({required this.name, required this.doc_image, required this.email, required this.id, required this.phone_no});

  factory ProfileModel.fromJson(Map<String, dynamic> json){
    print(json);
    return ProfileModel(
      id : json['id'],
      name : json['name'].toString(),
      doc_image : json['path_file'].toString(),
      email : json['email'].toString(),
      phone_no: json['phone_no'].toString(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email' : email,
      'doc_image' : doc_image,
      'phone_no' : phone_no
    };
  }

}