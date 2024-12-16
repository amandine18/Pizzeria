import 'package:flutter/material.dart';
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
                    subtitle: Text(
                      'Total : ${order.fold(0.0, (double total, item) => total + item.pizza.total * item.quantity).toStringAsFixed(2)} €',
                      style: const TextStyle(color: Colors.blueAccent),
                    ),
                    children: order.map((cartItem) {
                      return ListTile(
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(cartItem.pizza.title),
                            Text(
                              '${(cartItem.pizza.total * cartItem.quantity).toStringAsFixed(2)} €',
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
                                  '${Pizza.tailles[cartItem.pizza.taille].name}',
                                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                                ),
                                Text(
                                  'Sauce ${Pizza.sauces[cartItem.pizza.sauce].name.split(' ').last}',
                                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                                ),
                                Text(
                                  'Pâte ${Pizza.pates[cartItem.pizza.pate].name.split(' ').last}',
                                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                                ),
                              ],
                            ),
                            Text('Quantité : ${cartItem.quantity}')
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                );
              },
            ),
      bottomNavigationBar: const BottomNavigationBarWidget(2),
    );
  }
}

