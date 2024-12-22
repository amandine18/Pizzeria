import 'package:flutter/material.dart';
import 'package:pizzeria/ui/boissons/boisson_list.dart';
import 'package:pizzeria/ui/share/commandes.dart';
import 'package:pizzeria/ui/share/paiement.dart';
import 'package:pizzeria/ui/share/panier.dart';
import 'package:pizzeria/ui/pizzas/pizza_list.dart';
import 'package:pizzeria/ui/share/profil.dart';
import 'package:provider/provider.dart';
import 'models/share/cart.dart';
import 'models/share/menu.dart';
import 'ui/share/bottom_navigation_bar_widget.dart';
import 'ui/share/appbar_widget.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => Cart(),
      child: const MyApp(),
    ),
  );
}

//casser l'appli

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pizzéria',
      theme: ThemeData(
        // primarySwatch: Colors.blue,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
        appBarTheme: const AppBarTheme(  
          backgroundColor: Colors.blue,
        ),
      ),
      home: MyHomePage(title: 'Notre pizzéria'),
      //Start the app witj the "/" named route. In this case the app starts on the FirstScreen Widget
      routes: {
        '/profil': (context) => UserProfilPage(),
        '/panier': (context) => Panier(),
        '/paiement': (context) => Paiement(),
        '/commandes': (context) => OrdersPage(),
      },
    );
  }
}

class MyHomePage extends StatelessWidget {
  final String title;
  final Cart _cart;

  MyHomePage({required this.title, super.key}) :
    _cart = Cart();

  final List<Menu> _menus = [
    Menu(1, 'Entrées', 'entree.png', Colors.lightGreen),
    Menu(2, 'Pizzas', 'pizza.png', Colors.redAccent),
    Menu(3, 'Desserts', 'dessert.png', Colors.brown),
    Menu(4, 'Boissons', 'boisson.png', Colors.lightBlue),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppbarWidget(title),
      body: Center(
        child: ListView.builder(
          itemCount: _menus.length,
          itemBuilder: (context, index) => InkWell(
            onTap: (){
              switch (_menus[index].type){
                case 2: //Pizza
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => PizzaList(_cart)),
                  );
                  break;
                case 4:
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => BoissonList(_cart)),
                  );
                  break;
              }
            },
            child: _buildRow(_menus[index]),
          ),
          itemExtent: 180,
        ),
      ),
      backgroundColor: Colors.white,
      bottomNavigationBar: const BottomNavigationBarWidget(0, pageNum: 0,),
    );
  }

  _buildRow(Menu menu){
    return Container(
      height: 180,
      decoration: BoxDecoration(
        color: menu.color,
        borderRadius: const BorderRadius.all(Radius.circular(20.0)),
      ),
      margin: const EdgeInsets.all(4.0),
      child: Column(
        children: <Widget>[
          Expanded(
            child: Image.asset(
              'assets/images/menus/${menu.image}',
              fit: BoxFit.fitWidth,
            ),
          ),
          SizedBox(
            height: 50,
            child: Center(
              child: Text(
                menu.title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Roboto',
                  fontSize: 28,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}