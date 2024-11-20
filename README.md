# Pizzeria TD5

Le TD5 a la même base que le TD4 mais au lieu de récupérer les données des pizzas (id, nom, image et prix) dans le model "pizza_data.dart" et le dossier "assets/images", il passe par un serveur (ici Wamp) contenant un fichier JSON ayant les mêmes informations.

Les améliorations sont :
- ajout d'une fonction "fromJson" dans le model "pizza.dart"
    -> récupère les éléments du JSON du serveur et les affecte à des variables
- ajout du fichier "pizzeria_service.dart" dans un dossier "services"
    -> recupère l'url où se situe le JSON, étudie la réponse et ajoute les éléments à la fonction précédente
- remplacement de tous les éléments "Image.assets" par "Image.network"
    -> permet d'afficher les images non pas via le dossier "assets/images" mais via leur URL 