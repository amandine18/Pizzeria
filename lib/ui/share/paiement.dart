import 'package:flutter/material.dart';
import 'package:pizzeria/ui/share/bottom_navigation_bar_widget.dart';
import 'package:provider/provider.dart';
import '../../models/share/cart.dart';

class Paiement extends StatefulWidget {
  const Paiement({super.key});

  @override
  _PaiementState createState() => _PaiementState();
}

class _PaiementState extends State<Paiement> {
  String _livraisonChoice = 'Sur place';
  String _paymentChoice = 'Carte de crédit';

  @override
  Widget build(BuildContext context) {
    var cart = context.watch<Cart>();
    double total = cart.totalPrice;
    double tva = 0.1 * total;
    double ht = total - tva;

    return Scaffold(
      appBar: AppBar(
        title: Text('Paiement'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Livraison',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Column(
              children: [
                RadioListTile<String>(
                  title: const Text('Sur place'),
                  value: 'Sur place',
                  groupValue: _livraisonChoice,
                  onChanged: (value) {
                    setState(() {
                      _livraisonChoice = value!;
                    });
                  },
                ),
                RadioListTile<String>(
                  title: const Text('A emporter'),
                  value: 'A emporter',
                  groupValue: _livraisonChoice,
                  onChanged: (value) {
                    setState(() {
                      _livraisonChoice = value!;
                    });
                  },
                ),
                RadioListTile<String>(
                  title: const Text('A domicile'),
                  value: 'A domicile',
                  groupValue: _livraisonChoice,
                  onChanged: (value) {
                    setState(() {
                      _livraisonChoice = value!;
                    });
                  },
                )
              ],
            ),
            const SizedBox(height: 15),

            const Text(
              'Moyen de paiement',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Column(
              children: [
                RadioListTile<String>(
                  title: const Text('Carte de crédit'),
                  value: 'Carte de crédit',
                  groupValue: _paymentChoice,
                  onChanged: (value) {
                    setState(() {
                      _paymentChoice = value!;
                    });
                  },
                ),
                RadioListTile<String>(
                  title: const Text('PayPal'),
                  value: 'PayPal',
                  groupValue: _paymentChoice,
                  onChanged: (value) {
                    setState(() {
                      _paymentChoice = value!;
                    });
                  },
                ),
                RadioListTile<String>(
                  title: const Text('Sur place'),
                  value: 'Sur place',
                  groupValue: _paymentChoice,
                  onChanged: (value) {
                    setState(() {
                      _paymentChoice = value!;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 15),

            Column(
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
                        'Valider et payer',
                        style:  TextStyle(color: Colors.white),
                      ),
                      onPressed: () {
                        cart.clearCart(); // Méthode à ajouter dans votre modèle de panier
                        Navigator.pushNamed(context, '/commandes');
                      },
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: const BottomNavigationBarWidget(1, pageNum: 1),
    );
  }
}