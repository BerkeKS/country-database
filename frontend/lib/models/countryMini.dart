class CountryMini {
  String name;
  String flag;
  List<String>? capital;
  String population;
  List<String> continents;
  String? backgroundImage;
  String alpha;

  CountryMini(
      {required this.name,
      required this.flag,
      this.capital,
      required this.population,
      required this.continents,
      this.backgroundImage,
      required this.alpha});
}
