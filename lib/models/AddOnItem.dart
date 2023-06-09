import 'AddOn.dart';

class AddOnItem{

  late int quantity;
  late final AddOn product;

  AddOnItem({this.quantity = 1, required this.product});

  void increment(){
    quantity++;
  }

  Map<String, dynamic> toMap() {

    Map<String,dynamic> first = {
      'quantity': quantity,
    };

    Map<String,dynamic> second =product.toMap();

    return({...first, ...second});
    return first;
    // var finalList = first.addAll(second);
    // return finalList;
  }
}