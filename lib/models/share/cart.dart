import 'package:flutter/material.dart';
import '../pizzas/pizza.dart';

class CartItem {
  final Pizza pizza;
  // final Boisson? boisson;
  int quantity;

  CartItem(this.pizza, [this.quantity = 1]);
  // CartItem({this.pizza, this.quantity = 1}, {this.boisson, this.quantity = 1});
  // CartItem({this.pizza, this.boisson, this.quantity = 1});
  // CartItem(boisson: myboisson)
}

class Cart extends ChangeNotifier{
  final List<CartItem> _items = [];

  List<CartItem> get items => _items;

  // int totalItems() { return _items.length; }
  //Au lieu de récupérer la taille de la liste contenant les items du panier (_items.length), on initie une valeur total à 0 et avec la fonction fold et on y ajoute pour chaque item du panier sa quantité
  int totalItems() {
    return items.fold(0, (total, item) => total + item.quantity);
  }
  CartItem getCartItem(int index) {
    return _items[index];
  }

  void addProduct(Pizza pizza) {
    //Recherche du produit
    //enlever .id pour comparer les pizza entières
    int index = findCartItemIndex(pizza);
    if (index == -1) {
      //Ajout
      _items.add(CartItem(pizza));
    } else {
      //Incrémente la quantité
      CartItem item = _items[index];
      item.quantity++;
    }
    //Emmission d'une notification de changement
    notifyListeners();
  }

  void removeProduct(Pizza pizza) {
    //Recherche du produit
    int index = findCartItemIndex(pizza);
    if (index != -1) {
      CartItem item = _items[index];
      if (item.quantity > 1) {
        item.quantity--; // Décrémente la quantité si plus d'une unité
      } else {
        _items.removeAt(index); // Supprime l'élément si quantité = 1
      }
      //Emmission d'une notification de changement
      notifyListeners();
    }
  }

  //comparer pizza et non id 
  // int findCartItemIndex(int id) {
  //   return _items.indexWhere((element) => element.pizza.id == id);
  // }

  //Recherche d'un CartItem par l'instance complète de Pizza (et non juste de l'id comme au dessus)
  int findCartItemIndex(Pizza pizza) {
    return _items.indexWhere((item) =>
        item.pizza.id == pizza.id &&
        item.pizza.pate == pizza.pate &&
        item.pizza.taille == pizza.taille &&
        item.pizza.sauce == pizza.sauce);
  }

  // Retourne le prix total du panier
  double get totalPrice {
    return _items.fold(0, (total, cartItem) => total + cartItem.pizza.total * cartItem.quantity);
  }

  // Vide le panier
  void clearCart() {
    _items.clear();
  }
}