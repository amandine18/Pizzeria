import 'package:flutter/material.dart';
import '../models/pizza.dart';

import '../models/cart.dart';

class Panier extends StatefulWidget {
  final Cart _cart;
  const Panier(this._cart, {super.key});

  @override
  State<Panier> createState() => _PanierState();
}

class _PanierState extends State<Panier> {
  @override
  Widget build(BuildContext context) {

    double total = widget._cart.totalPrice;
    double tva = 0.1*total;
    double ht = total - tva;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mon panier'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: widget._cart.items.length,
              itemBuilder: (context, index) {
                return _buildItem(widget._cart.items[index]);
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8.0),
            child: Table(
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
                    },
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildItem(CartItem cartItem) {
    final pizza = cartItem.pizza;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          //Image.asset pour avant le TP5 (récupère les images dans le répertoire assets du projet)
          // Image.asset(
          //   'assets/images/pizzas/${pizza.image}',
          //   height: 105,
          // ),
          //Image.network pour le TP5 (récupère les images via une URL récupérée en local)
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
                                widget._cart.removeProduct(pizza);
                                setState(() {}); // Mettre à jour l'interface
                              },
                            ),
                            Text('${cartItem.quantity}'),
                            IconButton(
                              icon: const Icon(Icons.add),
                              padding: const EdgeInsets.only(bottom: 1.0),
                              onPressed: () {
                                print('Ajout de pizza');
                                widget._cart.addProduct(pizza);
                                setState(() {});
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

    // return ListTile(
    //   leading: const Icon(Icons.local_pizza),
    //   title: Text(pizza.title),
    //   subtitle: Column(
    //     crossAxisAlignment: CrossAxisAlignment.start,
    //     children: [
    //       Text('${pizza.price} €'),
    //       Text('${cartItem.quantity}'),
    //     ],
    //   ),
    //   trailing: Text(
    //     'Sous-total : ${(pizza.total * cartItem.quantity).toStringAsFixed(2)} €',
    //   ),
    // );

    // return Row(
    //   children: [
    //     const Text('Image'),
    //     Column(
    //       children: [
    //         Text(cartItem.pizza.title),
    //         const Text('Prix'),
    //         const Text('Sous-total'),
    //       ],
    //     )
    //   ],
    // );
  }
}
