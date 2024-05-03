class CountryMini {
  String name;
  String flag;
  List<String>? capital;
  String population;
  List<String> continents;
  String? backgroundImage;

  CountryMini(
      {required this.name,
      required this.flag,
      this.capital,
      required this.population,
      required this.continents,
      this.backgroundImage});
}
