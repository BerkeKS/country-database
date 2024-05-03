import 'package:country_data/database.dart';

import '../models/countryMini.dart';
import '../utils/service.dart';
import '../views/countryPage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../main.dart';
import '../utils/icons.dart';
import '../utils/images.dart';

class CountryList extends StatelessWidget {
  const CountryList(
      {required this.continent,
      required this.colors,
      required this.continents,
      required this.continentIcons});
  final String continent;
  final List<Color?> colors;
  final List<String> continents;
  final List<IconData> continentIcons;

  List<IconData> iconGenerator(String continent) {
    switch (continent) {
      case "Africa":
        return [
          ContinentIcons.globe_americas,
          ContinentIcons.globe_asia,
          ContinentIcons.globe_europe
        ];
      case "Americas":
        return [
          ContinentIcons.globe_africa,
          ContinentIcons.globe_asia,
          ContinentIcons.globe_europe
        ];
      case "Asia":
        return [
          ContinentIcons.globe_africa,
          ContinentIcons.globe_americas,
          ContinentIcons.globe_europe
        ];
      case "Europe":
        return [
          ContinentIcons.globe_africa,
          ContinentIcons.globe_americas,
          ContinentIcons.globe_asia
        ];
      default:
        throw "Wrong String!";
    }
  }

  List<String> continentGenerator(String continent) {
    switch (continent) {
      case "Africa":
        return ["Americas", "Asia", "Europe"];
      case "Americas":
        return ["Africa", "Asia", "Europe"];
      case "Asia":
        return ["Africa", "Americas", "Europe"];
      case "Europe":
        return ["Africa", "Americas", "Asia"];
      default:
        throw "Wrong String!";
    }
  }

  List<Color?> colorGenerator(String continent) {
    switch (continent) {
      case "Africa":
        return [
          Colors.greenAccent[700],
          Colors.redAccent[700],
          Colors.yellowAccent[700],
          Colors.blue[900]
        ];
      case "Americas":
        return [
          Colors.redAccent[700],
          Colors.greenAccent[700],
          Colors.yellowAccent[700],
          Colors.blue[900]
        ];
      case "Asia":
        return [
          Colors.yellowAccent[700],
          Colors.greenAccent[700],
          Colors.redAccent[700],
          Colors.blue[900]
        ];
      case "Europe":
        return [
          Colors.blue[900],
          Colors.greenAccent[700],
          Colors.redAccent[700],
          Colors.yellowAccent[700]
        ];
      default:
        throw "Wrong String!";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width / 25,
                child: Divider(color: colorGenerator(continent)[0]),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 1),
                child: Text(
                    (continent == "Asia") ? "Asia & Oceania" : continent,
                    style: GoogleFonts.comfortaa(
                        color: colorGenerator(continent)[0], fontSize: 18.5)),
              ),
              Expanded(
                child: Divider(color: colorGenerator(continent)[0]),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width / 1.85,
                child: Row(
                  children: [
                    IconButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => IntroSlides()));
                        },
                        icon: const Icon(
                          Icons.home_filled,
                          size: 20,
                        )),
                    IconButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CountryList(
                                    continent: continentGenerator(continent)[0],
                                    colors: colorGenerator(
                                        continentGenerator(continent)[0]),
                                    continents: continentGenerator(
                                        continentGenerator(continent)[0]),
                                    continentIcons: iconGenerator(continent)),
                              ));
                        },
                        icon: Icon(
                          iconGenerator(continent)[0],
                          size: 20,
                        )),
                    IconButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CountryList(
                                  continent: continentGenerator(continent)[1],
                                  colors: colorGenerator(
                                      continentGenerator(continent)[1]),
                                  continents: continentGenerator(
                                      continentGenerator(continent)[1]),
                                  continentIcons: iconGenerator(continent)),
                            ));
                      },
                      icon: Icon(
                        iconGenerator(continent)[1],
                        size: 20,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CountryList(
                                  continent: continentGenerator(continent)[2],
                                  colors: colorGenerator(
                                      continentGenerator(continent)[2]),
                                  continents: continentGenerator(
                                      continentGenerator(continent)[2]),
                                  continentIcons: iconGenerator(continent)),
                            ));
                      },
                      icon: Icon(
                        iconGenerator(continent)[2],
                        size: 20,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
          Expanded(
              child: Padding(
            padding: const EdgeInsets.only(top: 2),
            child: FutureBuilder<List<CountryMini>>(
              future: getBasicInfo(continent.toLowerCase()),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Text("Loading Country Data...");
                } else {
                  if (snapshot.hasError) {
                    return Text(snapshot.error.toString());
                  } else {
                    return ListView.builder(
                      itemCount: snapshot.data!.length,
                      scrollDirection: Axis.vertical,
                      itemBuilder: (context, index) => Padding(
                        padding: EdgeInsets.only(
                            bottom: MediaQuery.of(context).size.height / 150),
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(10)),
                              image: DecorationImage(
                                  image: NetworkImage(imagesData[
                                      snapshot.data![index].name]![0]),
                                  fit: BoxFit.cover)),
                          height: MediaQuery.of(context).size.height / 4,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: ListTile(
                                  leading: Container(
                                    height: MediaQuery.of(context).size.height /
                                        3.5,
                                    width:
                                        MediaQuery.of(context).size.width / 9,
                                    decoration: BoxDecoration(
                                        image: DecorationImage(
                                            image: NetworkImage(
                                                snapshot.data![index].flag),
                                            fit: BoxFit.contain)),
                                  ),
                                  title: Text(
                                    snapshot.data![index].name,
                                    style: GoogleFonts.karla(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20),
                                  ),
                                  trailing: IconButton(
                                      onPressed: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => CountryPage(
                                                  country: (countryConverter
                                                          .containsKey(snapshot
                                                              .data![index]
                                                              .name))
                                                      ? countryConverter[
                                                          snapshot.data![index]
                                                              .name]!
                                                      : snapshot
                                                          .data![index].name),
                                            ));
                                      },
                                      icon: const Icon(
                                        Icons.search,
                                        color: Colors.white,
                                        size: 25,
                                      )),
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(30, 20, 0, 0),
                                child: RichText(
                                    text: TextSpan(
                                        style: const TextStyle(
                                            fontSize: 18.5,
                                            color: Colors.white),
                                        children: [
                                      const TextSpan(
                                          text: "Continent(s): ",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold)),
                                      TextSpan(
                                          text:
                                              "${snapshot.data![index].continents[0]}\n"),
                                      const TextSpan(
                                          text: "Capital(s): ",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold)),
                                      TextSpan(
                                          text:
                                              ("${snapshot.data![index].capital![0]}\n")),
                                      const TextSpan(
                                          text: "Population: ",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold)),
                                      TextSpan(
                                          text: snapshot.data![index].population
                                              .toString()),
                                    ])),
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  }
                }
              },
            ),
          ))
        ],
      ),
    );
  }
}
