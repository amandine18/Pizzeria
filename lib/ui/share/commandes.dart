import 'package:flutter/material.dart';
import 'package:pizzeria/models/boissons/boisson.dart';
import 'package:pizzeria/models/pizzas/pizza.dart';
import 'package:pizzeria/models/share/date.dart';
import 'package:pizzeria/ui/share/bottom_navigation_bar_widget.dart';
import 'package:provider/provider.dart';
import '../../models/share/cart.dart';

class OrdersPage extends StatelessWidget {
  const OrdersPage({super.key});

  @override
  Widget build(BuildContext context) {
    var cart = context.watch<Cart>();
    var orders = cart.orders; // Liste contenant les commandes précédentes
    String today = getCurrentDate();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Historique des Commandes'),
        backgroundColor: Colors.blue,
      ),
      body: orders.isEmpty
          ? const Center(
              child: Text(
                'Aucune commande précédente',
                style: TextStyle(fontSize: 18, color: Colors.black54),
              ),
            )
          : ListView.builder(
              itemCount: orders.length,
              itemBuilder: (context, orderIndex) {
                var order = orders[orderIndex]; // Une commande complète (liste d'éléments)

                return Card(
                  margin: const EdgeInsets.all(8.0),
                  elevation: 3,
                  child: ExpansionTile(
                    title: Text(
                      'Commande ${orderIndex + 1} - $today',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          // 'Total : ${order.items.fold(0.0, (double total, item) => total + item.pizza.total * item.quantity).toStringAsFixed(2)} €',
                          'Total : ${order.items.fold(0.0, (double total, item) => total + _getItemTotal(item)).toStringAsFixed(2)} €',
                          style: const TextStyle(color: Colors.blueAccent),
                        ),
                        Text(order.deliveryType),
                        const SizedBox(width: 10),
                        Text(order.paymentMethod),
                      ],
                    ),
                    children: order.items.map((cartItem) {
                      return _buildOrderItem(cartItem);
                    }).toList(),
                  ),
                );
              },
            ),
      bottomNavigationBar: const BottomNavigationBarWidget(2),
    );
  }

  Widget _buildOrderItem(CartItem cartItem) {
    final product = cartItem.product;

    if (product is Pizza) {
      return ListTile(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Pizza ${product.title}'),
            Text(
              '${(product.total * cartItem.quantity).toStringAsFixed(2)} €',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  Pizza.tailles[product.taille].name,
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
                Text(
                  'Sauce ${Pizza.sauces[product.sauce].name.split(' ').last}',
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
                Text(
                  'Pâte ${Pizza.pates[product.pate].name.split(' ').last}',
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
            Text('Quantité : ${cartItem.quantity}')
          ],
        ),
      );
    } else if (product is Boisson) {
      return ListTile(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('${product.title} - ${Boisson.volumes[product.volume].name}'),
            Text(
              '${(product.total * cartItem.quantity).toStringAsFixed(2)} €',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
          ],
        ),
        subtitle:Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              product.hasGlacons? "Avec glaçons" : "Sans glaçons",
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
            Text('Quantité : ${cartItem.quantity}')
          ],
        ),
      );
    }
    return const SizedBox.shrink();
  }

  // Méthode pour calculer le total d'un item
  double _getItemTotal(CartItem cartItem) {
    final product = cartItem.product;
    if (product is Pizza) {
      return product.total * cartItem.quantity;
    } else if (product is Boisson) {
      return product.total * cartItem.quantity;
    }
    return 0.0; // Par défaut, si le produit est inconnu
  }
}

