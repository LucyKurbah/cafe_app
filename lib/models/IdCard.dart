class IdCard{
    
    int id;
    late String document_name;

    IdCard({required this.id,
    required this.document_name
    });

  factory IdCard.fromJson(Map<String, dynamic> json){
    print("ID CARD JSON_________________________________");
    print(json);
    return IdCard(
      id : (json['id']),
      document_name : json['document_name'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'document_name': document_name,
    };
  }

}