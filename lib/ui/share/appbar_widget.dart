import 'package:flutter/material.dart';
import 'package:pizzeria/ui/share/panier.dart';

import '../../models/share/cart.dart';

class AppbarWidget extends StatelessWidget implements PreferredSizeWidget{
  final String title;
  final Cart _cart;

  @override
  //TODO: implement preferredSize
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
  const AppbarWidget(this.title, this._cart, {super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title),
      actions: [
        IconButton(
          onPressed: (){
            Navigator.push(
              context, 
              MaterialPageRoute(
                builder: (context) => Panier(_cart),
              ),
            );
          }, 
          icon: const Icon(Icons.shopping_cart),
        )
      ],
    );
  }
}