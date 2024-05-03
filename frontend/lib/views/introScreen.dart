import 'package:flutter/material.dart';

import '../utils/icons.dart';
import 'countryListScreen.dart';

class IntroScreen extends StatelessWidget {
  const IntroScreen({required this.continent});
  final String continent;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Image(
            image: AssetImage("assets/images/${continent.toLowerCase()}.jpg")),
        TextButton.icon(
          onPressed: () {
            if (continent == "Africa") {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        CountryList(continent: "Africa", colors: [
                      Colors.greenAccent[700],
                      Colors.redAccent[700],
                      Colors.yellowAccent[700],
                      Colors.blue[900]
                    ], continents: const [
                      "Americas",
                      "Asia",
                      "Europe"
                    ], continentIcons: const [
                      ContinentIcons.globe_americas,
                      ContinentIcons.globe_asia,
                      ContinentIcons.globe_europe
                    ]),
                  ));
            } else if (continent == "Americas") {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        CountryList(continent: "Americas", colors: [
                      Colors.redAccent[700],
                      Colors.greenAccent[700],
                      Colors.yellowAccent[700],
                      Colors.blue[900]
                    ], continents: const [
                      "Africa",
                      "Asia",
                      "Europe"
                    ], continentIcons: const [
                      ContinentIcons.globe_africa,
                      ContinentIcons.globe_asia,
                      ContinentIcons.globe_europe
                    ]),
                  ));
            } else if (continent == "Asia") {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        CountryList(continent: "Asia", colors: [
                      Colors.yellowAccent[700],
                      Colors.greenAccent[700],
                      Colors.redAccent[700],
                      Colors.blue[900]
                    ], continents: const [
                      "Africa",
                      "Americas",
                      "Europe"
                    ], continentIcons: const [
                      ContinentIcons.globe_africa,
                      ContinentIcons.globe_americas,
                      ContinentIcons.globe_europe
                    ]),
                  ));
            } else {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        CountryList(continent: "Europe", colors: [
                      Colors.blue[900],
                      Colors.greenAccent[700],
                      Colors.redAccent[700],
                      Colors.yellowAccent[700]
                    ], continents: const [
                      "Africa",
                      "Americas",
                      "Asia"
                    ], continentIcons: const [
                      ContinentIcons.globe_africa,
                      ContinentIcons.globe_americas,
                      ContinentIcons.globe_asia
                    ]),
                  ));
            }
          },
          icon: (continent == "Africa")
              ? Icon(
                  ContinentIcons.globe_africa,
                  color: Colors.greenAccent[700],
                  size: 30,
                )
              : ((continent == "Americas")
                  ? Icon(
                      ContinentIcons.globe_americas,
                      color: Colors.redAccent[700],
                      size: 30,
                    )
                  : ((continent == "Asia")
                      ? Icon(
                          ContinentIcons.globe_asia,
                          color: Colors.yellowAccent[700],
                          size: 30,
                        )
                      : Icon(
                          ContinentIcons.globe_europe,
                          color: Colors.blueAccent[700],
                          size: 30,
                        ))),
          label: Text(
            (continent == "Africa")
                ? "Africa"
                : ((continent == "Americas")
                    ? "Americas"
                    : ((continent == "Asia") ? "Asia & Oceania" : "Europe")),
            style: const TextStyle(color: Colors.black, fontSize: 20.5),
          ),
        )
      ],
    );
  }
}
