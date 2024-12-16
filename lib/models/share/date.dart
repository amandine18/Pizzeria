String getCurrentDate() {
  final now = DateTime.now(); // Obtient la date et l'heure actuelles
  final formattedDate = "${now.day.toString().padLeft(2, '0')}/"
      "${now.month.toString().padLeft(2, '0')}/"
      "${now.year}";
  return formattedDate;
}