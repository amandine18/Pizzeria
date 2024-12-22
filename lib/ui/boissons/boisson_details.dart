import 'package:flutter/material.dart';
import 'package:pizzeria/models/boissons/boisson.dart';
import 'package:pizzeria/ui/share/bottom_navigation_bar_widget.dart';
import 'package:pizzeria/ui/share/buy_button_widget.dart';
import 'package:pizzeria/ui/share/pizzeria_style.dart';
import 'package:pizzeria/ui/share/total_widget.dart';

class BoissonDetails extends StatefulWidget {
  final Boisson boisson;

  BoissonDetails({required this.boisson});

  @override
  _BoissonDetailsState createState() => _BoissonDetailsState();
}

class _BoissonDetailsState extends State<BoissonDetails> {
  double _sucre = 0;
  late bool _hasGlacons;
  int _volume = 33;

  @override
  void initState() {
    super.initState();
    _sucre = widget.boisson.sucre;
    _hasGlacons = widget.boisson.hasGlacons;
    _volume = widget.boisson.volume;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.boisson.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.boisson.title,
              style: PizzeriaStyle.pageTitleTextStyle,
            ),
            // Image de la boisson
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10.0),
                child: Image.network(
                  Boisson.fixUrl(widget.boisson.image),
                  height: 150,
                  width: 150,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            // Teneur en sucre
            Text('Teneur en sucre', style: PizzeriaStyle.headerTextStyle),
            Slider(
              value: _sucre,
              min: 0,
              max: 50,
              divisions: 50,
              activeColor: _getSliderColor(_sucre),
              onChanged: (double value) {},
            ),
            // Glaçons - SwitchListTile
            Text('Ingrédients choisis', style: PizzeriaStyle.headerTextStyle),
            SwitchListTile(
              title: Text('Glaçons'),
              value: _hasGlacons,
              onChanged: (bool value) {
                setState(() {
                  _hasGlacons = value;
                  widget.boisson.hasGlacons = _hasGlacons; // Mise à jour de la variable du modèle
                });
              },
            ),
            // Choix de la quantité
            Text('Volume', style: PizzeriaStyle.headerTextStyle),
            Row(
              mainAxisAlignment: MainAxisAlignment.start, // Aligner les éléments à gauche
              children: Boisson.volumes.map((volumeOption) {
                return Expanded(  // Utilisation de Expanded pour que chaque Radio ait une taille définie
                  child: Row(
                    children: [
                      Radio<int>(
                        value: volumeOption.value,
                        groupValue: _volume,
                        onChanged: (int? value) {
                          setState(() {
                            _volume = value!;
                            widget.boisson.volume = _volume;
                          });
                        },
                      ),
                      Text(volumeOption.name),
                    ],
                  ),
                );
              }).toList(),
            ),
            // Total et bouton de commande
            TotalWidget(widget.boisson.total),
            BuyButtonWidget<Boisson>(widget.boisson)
          ],
        ),
      ),
      bottomNavigationBar: const BottomNavigationBarWidget(0, pageNum: 2),
    );
  }

  Color _getSliderColor(double sucreValue) {
    if (sucreValue < 15) {
      return Colors.green;
    } else if (sucreValue < 30) {
      return Colors.orange;
    } else {
      return Colors.red;
    }
  }
}