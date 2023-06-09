import 'Table.dart';

class TableItem{

  late int quantity;
  late final TableModel table;

  TableItem({this.quantity = 1, required this.table});

  void increment(){
    quantity++;
  }

  Map<String, dynamic> toMap() {

    Map<String,dynamic> first = {
      'quantity': quantity,
    };

    Map<String,dynamic> second =table.toMap();

    return({...first, ...second});

    // var finalList = first.addAll(second);
    // return finalList;
  }
}