import 'package:flutter/material.dart';
import 'package:pizzeria/models/boissons/boisson.dart';
import 'package:pizzeria/models/share/order.dart';
import '../pizzas/pizza.dart';

class CartItem {
  // final Pizza pizza;
  // final Boisson? boisson;
  final dynamic product;
  int quantity;

  CartItem(this.product, [this.quantity = 1]);
  // CartItem({this.pizza, this.quantity = 1}, {this.boisson, this.quantity = 1});
  // CartItem({this.pizza, this.boisson, this.quantity = 1});
  // CartItem(boisson: myboisson)

  double get total {
    if (product is Pizza) {
      return (product as Pizza).total * quantity;
    } else if (product is Boisson) {
      return (product as Boisson).total * quantity;
    }
    return 0.0;
  }
}

class Cart extends ChangeNotifier{
  final List<CartItem> _items = [];
  // final List<List<CartItem>> _orders = [];
  final List<Order> _orders = [];

  List<CartItem> get items => _items;
  List<Order> get orders => _orders;

  // int totalItems() { return _items.length; }
  //Au lieu de récupérer la taille de la liste contenant les items du panier (_items.length), on initie une valeur total à 0 et avec la fonction fold et on y ajoute pour chaque item du panier sa quantité
  int totalItems() {
    return items.fold(0, (total, item) => total + item.quantity);
  }
  CartItem getCartItem(int index) {
    return _items[index];
  }

  void addProduct(dynamic product) {
    int index = findCartItemIndex(product);
    if (index == -1) {
      // Ajout
      _items.add(CartItem(product));
    } else {
      // Incrémente la quantité
      CartItem item = _items[index];
      item.quantity++;
    }
    notifyListeners();
  }

  void removeProduct(dynamic product) {
    int index = findCartItemIndex(product);
    if (index != -1) {
      CartItem item = _items[index];
      if (item.quantity > 1) {
        item.quantity--; // Décrémente la quantité si plus d'une unité
      } else {
        _items.removeAt(index); // Supprime l'élément si quantité = 1
      }
      notifyListeners();
    }
  }

  //comparer pizza et non id 
  // int findCartItemIndex(int id) {
  //   return _items.indexWhere((element) => element.pizza.id == id);
  // }

  //Recherche d'un CartItem par l'instance complète de Pizza (et non juste de l'id comme au dessus)
  // int findCartItemIndex(Pizza pizza) {
  //   return _items.indexWhere((item) =>
  //       item.pizza.id == pizza.id &&
  //       item.pizza.pate == pizza.pate &&
  //       item.pizza.taille == pizza.taille &&
  //       item.pizza.sauce == pizza.sauce);
  // }

  int findCartItemIndex(dynamic product) {
    return _items.indexWhere((item) {
      if (product is Pizza && item.product is Pizza) {
        // Comparaison des pizzas par leurs caractéristiques
        return item.product.id == product.id &&
            item.product.pate == product.pate &&
            item.product.taille == product.taille &&
            item.product.sauce == product.sauce;
      } else if (product is Boisson && item.product is Boisson) {
        // Comparaison des boissons par leurs caractéristiques
        return item.product.id == product.id &&
            item.product.volume == product.volume &&
            item.product.hasGlacons == product.hasGlacons;
      }
      return false;
    });
  }

  // Retourne le prix total du panier
  double get totalPrice {
    // return _items.fold(0, (total, cartItem) => total + cartItem.pizza.total * cartItem.quantity);
    return _items.fold(0, (total, cartItem) => total + cartItem.total);
  }

  // Vide le panier
  void clearCart() {
    if (_items.isNotEmpty) {
      _items.clear();
      notifyListeners();
    }
  }

  void addOrder(String deliveryType, String paymentMethod) {
    _orders.add(Order(
      items: List.from(_items), // Copie des éléments actuels du panier
      deliveryType: deliveryType,
      paymentMethod: paymentMethod,
    ));
    clearCart(); // Vide le panier après avoir ajouté la commande
    notifyListeners();
  }

  // List<List<CartItem>> get orders => _orders;
}