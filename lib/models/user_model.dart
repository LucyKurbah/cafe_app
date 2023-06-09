

class UserModel {
  int id;
  String name;
  String email;
  String? image;
  String token;

    UserModel({
    required this.id,
    required this.name,
    required this.image,
    required this.email,
    required this.token,
  });


  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: json['user']["id"],
        name: json['user']["name"],
        image: json['user']["image"]??'',
        email: json['user']["email"],
        token: json["token"]??'',
      );

//   Map<String, dynamic> toJson() => {
//         "id": id,
//         "name": name,
//         "image": image,
//         "email": email,
//         "token": token,
//       };
// }

// class Address {
//   Address({
//     required this.street,
//     required this.suite,
//     required this.city,
//     required this.zipcode,
//     required this.geo,
//   });

//   String street;
//   String suite;
//   String city;
//   String zipcode;
//   Geo geo;

//   factory Address.fromJson(Map<String, dynamic> json) => Address(
//         street: json["street"],
//         suite: json["suite"],
//         city: json["city"],
//         zipcode: json["zipcode"],
//         geo: Geo.fromJson(json["geo"]),
//       );

//   Map<String, dynamic> toJson() => {
//         "street": street,
//         "suite": suite,
//         "city": city,
//         "zipcode": zipcode,
//         "geo": geo.toJson(),
//       };
// }

// class Geo {
//   Geo({
//     required this.lat,
//     required this.lng,
//   });

//   String lat;
//   String lng;

//   factory Geo.fromJson(Map<String, dynamic> json) => Geo(
//         lat: json["lat"],
//         lng: json["lng"],
//       );

//   Map<String, dynamic> toJson() => {
//         "lat": lat,
//         "lng": lng,
//       };
// }

// class Company {
//   Company({
//     required this.name,
//     required this.catchPhrase,
//     required this.bs,
//   });

//   String name;
//   String catchPhrase;
//   String bs;

//   factory Company.fromJson(Map<String, dynamic> json) => Company(
//         name: json["name"],
//         catchPhrase: json["catchPhrase"],
//         bs: json["bs"],
//       );

//   Map<String, dynamic> toJson() => {
//         "name": name,
//         "catchPhrase": catchPhrase,
//         "bs": bs,
//       };
}