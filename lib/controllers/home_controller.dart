
import 'package:cafe_app/models/AddOn.dart';
import 'package:cafe_app/models/Product.dart';
import 'package:cafe_app/models/ProductItem.dart';
import 'package:cafe_app/models/TableItem.dart';
import 'package:cafe_app/models/Table.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/AddOnItem.dart';


enum HomeState { normal, cart }

class HomeController extends ChangeNotifier {

  HomeState homeState = HomeState.normal;

  int _counter = 0;

  int get counter => _counter;

  double _totalPrice = 0.0;

  double get totalPrice => _totalPrice;

  List<ProductItem> cart = [];
  List<AddOnItem> cartAddOn = [];
  List<TableItem> cartTable = [];

  void changeHomeState(HomeState state) {
    homeState = state;
    notifyListeners();
  }

  void addProductToCart(Product product) {
   
    for (ProductItem item in cart) {
      if (item.product.title == product.title) {
        item.increment();
        notifyListeners();
        return;
      }
    }

    cart.add(ProductItem(product: product));
    notifyListeners();
  }

  void addAddOnToCart(AddOn product) {
   
    for (AddOnItem item in cartAddOn) {
      if (item.product.title == product.title) {
        item.increment();
        notifyListeners();
        return;
      }
    }

    cartAddOn.add(AddOnItem(product: product));
    notifyListeners();
  }

  void addTableToCart(TableModel table) {
    for (TableItem item in cartTable) {
      if (item.table.table_name == table.table_name) {
        item.increment();
        notifyListeners();
        return;
      }
    }

    cartTable.add(TableItem(table: table));
    notifyListeners();
  }

  int totalCartItems() => cart.fold(
      0, (previousValue, element) => previousValue + element.quantity);

  void _setPrefItems() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('cart_item', _counter);
    prefs.setDouble('total_price', _totalPrice);
    notifyListeners();
  }

  void _getPrefItems() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _counter = prefs.getInt('cart_item') ?? 0;
    _totalPrice = prefs.getDouble('total_price') ?? 0.0;
    notifyListeners();
  }

  void addCounter(){
    _counter++;
    _setPrefItems();
    notifyListeners();
  }

  void removeCounter(){
    _counter--;
    _setPrefItems();
    notifyListeners();
  }

  int getCounter(){
    _getPrefItems();
    return _counter;
  }

  void addTotalPrice(double productPrice){
    _totalPrice = _totalPrice+ productPrice;
    _setPrefItems();
    notifyListeners();
  }

  void removeTotalPrice(double productPrice){
     _totalPrice = _totalPrice - productPrice;
    _setPrefItems();
    notifyListeners();
  }

  double getTotalPrice(){
    _getPrefItems();
    return _totalPrice;
  }



}
