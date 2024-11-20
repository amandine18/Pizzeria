import 'package:flutter/material.dart';
import 'package:pizzeria/services/pizzeria_service.dart';
import 'package:pizzeria/ui/pizza_details.dart';
import 'package:pizzeria/ui/share/buy_button_widget.dart';
import 'package:pizzeria/ui/share/pizzeria_style.dart';

import '../models/cart.dart';
import '../models/pizza.dart';
import '../models/pizza_data.dart';
import 'share/appbar_widget.dart';

class PizzaList extends StatefulWidget {
  final Cart _cart;
  const PizzaList(this._cart, {super.key});

  @override
  State<PizzaList> createState() => _PizzaListState();
}

class _PizzaListState extends State<PizzaList> {
  //!!Version avant TP5
  // List<Pizza> _pizzas = [];
  final String title = 'Nos Pizzas';

  late Future<List<Pizza>> _pizzas;
  final PizzeriaService _service = PizzeriaService();

  @override
  void initState() {
    super.initState();
    //!!Version avant TP5
    // _pizzas = PizzaData.buildList();
    _pizzas = _service.fetchPizzas();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppbarWidget(title, widget._cart),
      //!!Version avant TP5
      // body: ListView.builder(
      //   padding: const EdgeInsets.all(8.0),
      //   itemCount: _pizzas.length,
      //   itemBuilder: (context, index){
      //     return _buildRow(_pizzas[index]);
      //   }
      // ),
      body: FutureBuilder<List<Pizza>>(
        future: _pizzas, 
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return _buildListView(snapshot.data!);
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                'Impossible de récupérer les données : ${snapshot.error}',
                style : PizzeriaStyle.errorTextStyle,
              ),
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
  
  _buildRow(Pizza pizza) {
    return Card(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(10.0), top: Radius.circular(2.0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: (){
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PizzaDetails(pizza, widget._cart),
                ),
              );
            },
            child: _builPizzaDetails(pizza),
          ),
          BuyButtonWidget(pizza, widget._cart),
        ],
      ),
    );
  }

  _builPizzaDetails(Pizza pizza){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          title: Text(pizza.title),
          subtitle: Text(pizza.garniture),
          leading: const Icon(Icons.local_pizza),
        ),
        // Image.asset(
        //   'assets/images/pizzas/${pizza.image}',
        //   height: 120,
        //   width: MediaQuery.of(context).size.width,
        //   fit: BoxFit.fitWidth,
        // ),
        Image.network(
            Pizza.fixUrl(pizza.image),
            height: 120,
            width: MediaQuery.of(context).size.width,
            fit: BoxFit.fitWidth,
        ),
        Container(
          padding: const EdgeInsets.all(10.0),
          child: Text(pizza.garniture),
        ),
      ],
    );
  }

  _buildListView(List<Pizza> pizzas) {
    return ListView.builder(
      padding: const EdgeInsets.all(8.0),
      itemCount: pizzas.length,
      itemBuilder: (context, index){
        return _buildRow(pizzas[index]);
      }
    );
  }

}