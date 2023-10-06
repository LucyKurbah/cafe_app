class ProfileModel {
  int id;
  late String name;
  late String email, phone_no, doc_image;
  final Document? document;

  ProfileModel(
      {required this.document,
      required this.doc_image,
      required this.name,
      required this.email,
      required this.id,
      required this.phone_no});

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    print("JSON PROFILE DATA___________________________________");
    print(json);

    return ProfileModel(
      id: json['id'],
      name: json['name'].toString(),
      // doc_image : json['path_file'].toString(),
      doc_image: json['path_file'] != null ? json['path_file'].toString() : '',
      email: json['email'].toString(),
      phone_no: json['phone_no'].toString(),
      document: json['document'] != null
          ? Document(
              id: json['document']['id'] ?? '0',
              document_name: json['document']['document_name'] ?? '',
            )
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'doc_image': doc_image,
      'phone_no': phone_no
    };
  }
}

class Document {
  final int id;
  final String document_name;

  Document({
    required this.id,
    required this.document_name,
  });
}
