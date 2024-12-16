import 'package:flutter/material.dart';
import 'package:pizzeria/ui/share/badge_widget.dart';
import 'package:provider/provider.dart';
import '../../models/share/cart.dart';

class BottomNavigationBarWidget extends StatelessWidget {
  final int indexSelected;
  final int? pageNum;
  const BottomNavigationBarWidget(this.indexSelected, {super.key, this.pageNum});

  @override
  Widget build(BuildContext context) {
    var cart = context.watch<Cart>();
    var _totalItems = cart.totalItems();

    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: indexSelected,
      items: <BottomNavigationBarItem>[
        const BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Accueil',
        ),
        BottomNavigationBarItem(
          icon: _totalItems == 0
            ? const Icon(Icons.shopping_cart_outlined)
            : BadgeWidget(
              value: _totalItems,
              top: 0,
              right: 0, 
              color: null,
              child: const Icon(Icons.shopping_cart),
            ),
          label: 'Panier',
        ),
        const BottomNavigationBarItem(
          icon: Icon(Icons.add_shopping_cart_outlined),
          label: 'Commande',
        ),
        const BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Profil',
        ),
      ],
      onTap: (index) {
        if (indexSelected == index && (pageNum == null || pageNum == 0)) {
          return;
        } else {
          String page = '/';
          switch (index) {
            case 1:
              page = '/panier';
              break;
            case 2:
              page = '/commandes';
              break;
            case 3:
              page = '/profil';
              break;
          }
          Navigator.pushNamed(context, page);
        }
      },
    );
  }
}