class Country {
  String name;
  String officialName;
  String flag;
  String alpha3code;
  List<String>? capital;
  String population;
  List<String> gallery;
  List<String> timezones;

  Country(
      {required this.name,
      required this.officialName,
      required this.flag,
      required this.alpha3code,
      required this.capital,
      required this.population,
      required this.gallery,
      required this.timezones});
}
