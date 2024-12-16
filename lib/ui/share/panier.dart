import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pizzeria/ui/share/bottom_navigation_bar_widget.dart';
import 'package:pizzeria/ui/share/pizzeria_style.dart';
import 'package:provider/provider.dart';
import '../../models/pizzas/pizza.dart';

import '../../models/share/cart.dart';

class Panier extends StatefulWidget {
  const Panier({super.key});

  @override
  State<Panier> createState() => _PanierState();
}

class _PanierState extends State<Panier> {
  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mon panier'),
      ),
      body: Column(
        children: [
          Expanded(
            child: _CartList(),
          ),
          _CartTotal(),
        ],
      ),
      bottomNavigationBar: const BottomNavigationBarWidget(1),
    );
  }
}

class _CartList extends StatelessWidget {
  final format = NumberFormat("###.00 €");

  @override
  Widget build(BuildContext context) {
    var cart = context.watch<Cart>();

    return ListView.builder(
      itemCount: cart.items.length,
      itemBuilder: (context, index) {
        return _buildItem(context, cart.items[index]);
      },
    );
  }

  Widget _buildItem(BuildContext context, CartItem cartItem) {
    final pizza = cartItem.pizza;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          //Image.network récupère les images via une URL récupérée en local
          Image.network(
            Pizza.fixUrl(pizza.image),
            height: 105,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                      pizza.title,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  SizedBox(
                    height: 30,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Prix initial : ${pizza.price} €'),
                        Row(
                          
                          children: [
                            IconButton(
                              icon: const Icon(Icons.remove),
                              padding: const EdgeInsets.only(bottom: 1.0),
                              onPressed: () {
                                print('Suppression de pizza');
                                context.read<Cart>().removeProduct(pizza);
                              },
                            ),
                            Text('${cartItem.quantity}'),
                            IconButton(
                              icon: const Icon(Icons.add),
                              padding: const EdgeInsets.only(bottom: 1.0),
                              onPressed: () {
                                print('Ajout de pizza');
                                context.read<Cart>().addProduct(pizza);
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  
                  Text('Prix actuel : ${pizza.total} €'),
                  //Ajout des lignes suivantes pour afficher les éléments
                  Container(
                    padding: const EdgeInsets.only(bottom: 5.0),
                    child: Table(
                      columnWidths: const <int, TableColumnWidth>{
                        0: FlexColumnWidth(95),
                        1: FlexColumnWidth(80),
                        2: FixedColumnWidth(105),
                      },
                      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                      children: <TableRow>[
                        TableRow(
                          children: <Widget>[
                            TableCell(
                              verticalAlignment: TableCellVerticalAlignment.middle,
                              child: Text(
                                '${Pizza.pates[pizza.pate].name}',
                                style: const TextStyle(color: Colors.grey),
                              )
                            ),
                            TableCell(
                              verticalAlignment: TableCellVerticalAlignment.middle,
                              child: Text(
                                '${Pizza.tailles[pizza.taille].name}',
                                style: const TextStyle(color: Colors.grey),
                              )
                            ),
                            TableCell(
                              verticalAlignment: TableCellVerticalAlignment.middle,
                              child: Text(
                                'Sauce ${Pizza.sauces[pizza.sauce].name.split(' ').last}',
                                style: const TextStyle(color: Colors.grey),
                              )
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Text(
                    'Sous-total : ${(pizza.total * cartItem.quantity).toStringAsFixed(2)} €',
                    style: const TextStyle(color: Color.fromARGB(255, 6, 105, 187), fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CartTotal extends StatelessWidget {
  final format = NumberFormat("###.00 €");

  @override
  Widget build(BuildContext context) {

    return Container(
      padding: const EdgeInsets.all(8.0),
      child: Consumer<Cart>(
        builder: (context, cart, child) {
          double total = cart.totalPrice;
          double tva = 0.1*total;
          double ht = total - tva;

          if (total == 0) {
            return Center(
              child: Text(
                'Aucun produit', 
                style: PizzeriaStyle.priceTotalTextStyle,
              ),
            );
          } else {
            return Column(
              children: [
                Table(
                  columnWidths: const <int, TableColumnWidth>{
                    0: FlexColumnWidth(),
                    1: FlexColumnWidth(),
                    2: FixedColumnWidth(65),
                  },
                  defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                  children: <TableRow>[
                    TableRow(
                      children: <Widget>[
                        Container(),
                        const TableCell(
                          verticalAlignment: TableCellVerticalAlignment.middle,
                          child: Text(
                            'TOTAL HT',
                            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
                          )
                        ),
                        TableCell(
                          verticalAlignment: TableCellVerticalAlignment.middle,
                          child: Text(
                            '${ht.toStringAsFixed(2)} €',
                            style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
                          )
                        ),
                      ],
                    ),
                    TableRow(
                      children: <Widget>[
                        Container(),
                        const TableCell(
                          verticalAlignment: TableCellVerticalAlignment.middle,
                          child: Text(
                            'TVA',
                            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
                          )
                        ),
                        TableCell(
                          verticalAlignment: TableCellVerticalAlignment.middle,
                          child: Text(
                            '${tva.toStringAsFixed(2)} €',
                            style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
                          )
                        ),
                      ],
                    ),
                    TableRow(
                      children: <Widget>[
                        Container(),
                        const TableCell(
                          verticalAlignment: TableCellVerticalAlignment.middle,
                          child: Text(
                            'TOTAL TTC',
                            style: TextStyle(fontWeight: FontWeight.bold, color: Color.fromARGB(255, 6, 105, 187)),
                          )
                        ),
                        TableCell(
                          verticalAlignment: TableCellVerticalAlignment.middle,
                          child: Text(
                            '${total.toStringAsFixed(2)} €',
                            style: const TextStyle(fontWeight: FontWeight.bold, color: Color.fromARGB(255, 6, 105, 187)),
                          )
                        ),
                      ],
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor: WidgetStateProperty.all<Color>(const Color.fromARGB(255, 194, 35, 35)),
                          ),
                          child: const Text(
                            'Valider le panier',
                            style:  TextStyle(color: Colors.white),
                          ),
                          onPressed: () {
                            print('Valider');
                            Navigator.pushNamed(context, '/paiement');
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ]
            );
          }
        },
      )
    );
  }
}