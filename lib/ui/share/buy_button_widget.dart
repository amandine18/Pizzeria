import 'package:flutter/material.dart';
import 'package:pizzeria/models/boissons/boisson.dart';
import 'package:provider/provider.dart';

import '../../models/share/cart.dart';
import '../../models/pizzas/pizza.dart';

class BuyButtonWidget<T> extends StatelessWidget {
  // final Pizza _pizza;
  final T _item;
  const BuyButtonWidget(this._item, {super.key});

  @override
  Widget build(BuildContext context) {
    //Obtention de l'objet cart depuis le provider
    //Nous n'écoutons pas les notifications émises
    var cart = Provider.of<Cart>(context, listen:false);
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          margin: const EdgeInsets.all(10.0),
          child: ElevatedButton(
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.all<Color>(const Color.fromARGB(255, 222, 140, 176))),
            child: Row(
              children: [
                const Icon(Icons.shopping_cart),
                const SizedBox(width: 5),
                Container(
                  padding: const EdgeInsets.all(10.0),
                  child: const Text("Commander"),
                ),
              ],
            ),
            onPressed: (){
              // print('Commander une pizza');
              // // _cart.addProduct(_pizza);
              // //Ajout de la copie de la pizza que l'on va ensuite comparer dans cart.dart
              // Pizza pizzaCopy = _pizza.copyWith(
              //   pate: _pizza.pate,
              //   taille: _pizza.taille,
              //   sauce: _pizza.sauce,
              // );
              // cart.addProduct(pizzaCopy);
              if (_item is Pizza) {
                _handlePizza(cart);
              } else if (_item is Boisson) {
                _handleBoisson(cart);
              } else {
                throw Exception('Type non supporté pour Commander');
              }
            },
          ),
        ),
      ],
    );
  }

  void _handlePizza(Cart cart) {
    print('Commander une pizza');
    Pizza pizza = _item as Pizza;
    Pizza pizzaCopy = pizza.copyWith(
      pate: pizza.pate,
      taille: pizza.taille,
      sauce: pizza.sauce,
    );
    cart.addProduct(pizzaCopy);
  }

  void _handleBoisson(Cart cart) {
    print('Commander une boisson');
    Boisson boisson = _item as Boisson;
    Boisson boissonCopy = boisson.copyWith(volume: boisson.volume);
    cart.addProduct(boissonCopy);
  }
}