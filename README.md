# Pizzeria TD6

Le TD6 est la suite du TD5.

Les améliorations sont :
- ajout d'un provider lié à la classe Cart
    -> à chaque modification du panier, les différentes classes associées sont prévenues 
- ajout d'une barre de navigation en bas de l'écran avec les routes dans main.dart
    -> accessible sur toutes les pages, le nombre d'éléments dans le panier est affiché et sur une page (exemple panier), si je clique sur le bouton associé dans la bottomNavBar, je reste sur la même page (cela n'en ouvre pas une nouvelle, qui serait la même)
- ajout de la page profil
    -> possibilité de modifier les informations personnelles, qui resteront ensuite les mêmes
- ajout de la validation du panier
    -> lorsqu'on appuie sur "valider le panier", nous sommes redirigé vers une page de paiement avec des informations à renseigner. Une fois le paiement validé, le détail de la commande passée est ajouté à la liste des commandes dans la page associée. 