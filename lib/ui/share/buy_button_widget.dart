import 'package:flutter/material.dart';

import '../../models/cart.dart';
import '../../models/pizza.dart';

class BuyButtonWidget extends StatelessWidget {
  final Pizza _pizza;
  final Cart _cart;
  const BuyButtonWidget(this._pizza, this._cart, {super.key});

  @override
  Widget build(BuildContext context) {
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
              print('Commander une pizza');
              // _cart.addProduct(_pizza);
              //Ajout de la copie de la pizza que l'on va ensuite comparer dans cart.dart
              Pizza pizzaCopy = _pizza.copyWith(
                pate: _pizza.pate,
                taille: _pizza.taille,
                sauce: _pizza.sauce,
              );
              _cart.addProduct(pizzaCopy);
            },
          ),
        ),
      ],
    );
  }
}