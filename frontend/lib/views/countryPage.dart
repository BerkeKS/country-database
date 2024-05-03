import 'package:country_data/database.dart';
import 'package:country_data/main.dart';
import 'package:country_data/models/news.dart';
import 'package:country_data/models/soccerMatch.dart';
import 'package:country_data/views/newsScreen.dart';
import '../models/country.dart';
import '../utils/icons.dart';
import '../utils/service.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models/weather.dart';

class CountryPage extends StatefulWidget {
  const CountryPage({required this.country});
  static int activeNewsIndex = 0;
  static int activePlaceIndex = 0;
  static int activeHolidayIndex = 0;
  static int activeMatchIndex = 0;
  final String country;
  @override
  State<CountryPage> createState() => _CountryPageState();
}

class _CountryPageState extends State<CountryPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Builder(
          builder: (context) => SingleChildScrollView(
                child: Column(
                  children: [
                    Column(
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height / 3.5,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              FutureBuilder<Country>(
                                future: getCountry(context, widget.country),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return const LinearProgressIndicator();
                                  }
                                  return Container(
                                    decoration: BoxDecoration(
                                        image: DecorationImage(
                                            image: NetworkImage(
                                                snapshot.data!.gallery[0]),
                                            fit: BoxFit.cover)),
                                  );
                                },
                              ),
                              Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Align(
                                    alignment: Alignment.topLeft,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 10),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Container(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height /
                                                16,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                3 /
                                                4,
                                            decoration: BoxDecoration(
                                                color: const Color.fromARGB(
                                                        255, 255, 255, 255)
                                                    .withOpacity(0.5)),
                                            child: Padding(
                                              padding: const EdgeInsets.all(10),
                                              child: StreamBuilder<Weather>(
                                                stream: streamWeather(
                                                    (countryWeatherConverter
                                                            .containsKey(
                                                                widget.country)
                                                        ? countryWeatherConverter[
                                                            widget.country]!
                                                        : widget.country)),
                                                builder:
                                                    (context, weatherSnapshot) {
                                                  if (weatherSnapshot
                                                          .connectionState ==
                                                      ConnectionState.waiting) {
                                                    return const Center(
                                                      child: Text("Loading..."),
                                                    );
                                                  }
                                                  if (weatherSnapshot
                                                      .hasError) {
                                                    return const Center(
                                                      child: Text("No Data"),
                                                    );
                                                  }
                                                  return Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: [
                                                      //Add weather icon here
                                                      Image.network(
                                                        "https:${weatherSnapshot.data!.icon}",
                                                        height: 60,
                                                      ),
                                                      const SizedBox(
                                                        width: 15,
                                                      ),
                                                      Text(weatherSnapshot
                                                          .data!.text),
                                                    ],
                                                  );
                                                },
                                              ),
                                            ),
                                          ),
                                          const SizedBox(height: 8.5),
                                          Container(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height /
                                                16,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                3 /
                                                4,
                                            decoration: BoxDecoration(
                                                color: const Color.fromARGB(
                                                        255, 253, 253, 253)
                                                    .withOpacity(0.5)),
                                            child: Padding(
                                                padding:
                                                    const EdgeInsets.all(10),
                                                child:
                                                    StreamBuilder<List<String>>(
                                                  stream: streamLocalTime(timezoneData[
                                                          countryTimezoneConverter
                                                                  .containsKey(
                                                                      widget
                                                                          .country)
                                                              ? countryTimezoneConverter[
                                                                  widget
                                                                      .country]
                                                              : widget.country]
                                                      .toString()),
                                                  builder:
                                                      (context, timeSnapshot) {
                                                    if (timeSnapshot
                                                            .connectionState ==
                                                        ConnectionState
                                                            .waiting) {
                                                      return const Center(
                                                        child:
                                                            Text("Loading..."),
                                                      );
                                                    }
                                                    if (timeSnapshot.hasError) {
                                                      return const Center(
                                                        child: Text("No data."),
                                                      );
                                                    }
                                                    return Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceAround,
                                                      children: [
                                                        const Text(
                                                          "Local Time: ",
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                        Text(timeSnapshot
                                                            .data![0]),
                                                        Text(timeSnapshot
                                                            .data![1])
                                                      ],
                                                    );
                                                  },
                                                )),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  FutureBuilder(
                                    future: getCountry(context, widget.country),
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return const LinearProgressIndicator();
                                      }
                                      return ListTile(
                                        leading: Container(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height /
                                              7,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              12.5,
                                          decoration: BoxDecoration(
                                              image: DecorationImage(
                                                  image: NetworkImage(
                                                      snapshot.data!.flag),
                                                  fit: BoxFit.contain)),
                                        ),
                                        title: Text(
                                          snapshot.data!.name,
                                          style: GoogleFonts.karla(
                                              color: const Color.fromARGB(
                                                  255, 164, 164, 164),
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20.5),
                                        ),
                                        subtitle: Text(
                                          snapshot.data!.officialName,
                                          style: GoogleFonts.karla(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 11),
                                        ),
                                        trailing: SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              2.50,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: <Widget>[
                                              IconButton(
                                                onPressed: () {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              const IntroSlides()));
                                                },
                                                icon: const Icon(
                                                  Icons.home_filled,
                                                  color: Colors.white,
                                                  size: 17.7,
                                                ),
                                              ),
                                              IconButton(
                                                onPressed: () {
                                                  openWikipedia(
                                                      context, widget.country);
                                                },
                                                icon: const Icon(
                                                  CountryIcons.wikipedia_w,
                                                  color: Colors.white,
                                                  size: 17.7,
                                                ),
                                              ),
                                              IconButton(
                                                onPressed: () {
                                                  getMap(
                                                      context, widget.country);
                                                },
                                                icon: const Icon(
                                                  CountryIcons.map_marked_alt,
                                                  color: Colors.white,
                                                  size: 17.7,
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                        FutureBuilder(
                          future: getCountry(context, widget.country),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const LinearProgressIndicator();
                            }
                            return Container(
                                height: MediaQuery.of(context).size.height / 30,
                                decoration: const BoxDecoration(
                                    color: Color.fromARGB(255, 215, 215, 215)),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Text(
                                      "Capital: ${snapshot.data!.capital![0]}",
                                      style: const TextStyle(fontSize: 15),
                                    ),
                                    Text(
                                      "Population: ${snapshot.data!.population.toString()}",
                                      style: const TextStyle(fontSize: 15),
                                    )
                                  ],
                                ));
                          },
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height / 90,
                        ),
                        (countryNewsConverter.containsKey(widget.country))
                            ? NewsSection(country: widget.country)
                            : const SizedBox(),
                        SizedBox(
                          height: MediaQuery.of(context).size.height / 90,
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height / 3,
                          child: (countryHolidayConverter
                                  .containsKey(widget.country))
                              ? Row(
                                  children: [
                                    Expanded(
                                        child: TravelSection(
                                      country: widget.country,
                                    )),
                                    SizedBox(
                                      width:
                                          MediaQuery.of(context).size.height /
                                              150,
                                    ),
                                    Expanded(
                                        child: HolidaySection(
                                      country: widget.country,
                                    ))
                                  ],
                                )
                              : (!countryTravelConverter
                                      .containsKey(widget.country))
                                  ? Expanded(
                                      child: TravelSection(
                                      country: widget.country,
                                    ))
                                  : const SizedBox(),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height / 90,
                        ),
                        (soccerLeagueData.containsKey(widget.country))
                            ? SoccerSection(country: widget.country)
                            : const SizedBox()
                      ],
                    )
                  ],
                ),
              )),
    );
  }
}

class NewsSection extends StatefulWidget {
  const NewsSection({super.key, required this.country});

  final String country;

  @override
  State<NewsSection> createState() => _NewsSectionState();
}

class _NewsSectionState extends State<NewsSection> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<News>>(
      future: getNews(
          context,
          (countryNewsConverter.containsKey(widget.country)
              ? countryNewsConverter[widget.country].toString()
              : widget.country)),
      builder: (context, newsSnapshot) => Container(
        decoration: const BoxDecoration(
            color: Color.fromARGB(255, 223, 223, 223),
            borderRadius: BorderRadius.all(Radius.circular(15))),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(12.5),
              child: Row(
                children: [
                  const Icon(Icons.newspaper),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 7.5),
                    child: Text(
                      "News",
                      style: GoogleFonts.zillaSlab(fontSize: 20),
                    ),
                  )
                ],
              ),
            ),
            (newsSnapshot.hasError)
                ? Text(newsSnapshot.error.toString())
                : ((newsSnapshot.connectionState == ConnectionState.waiting)
                    ? const Text("Loading...")
                    : (newsSnapshot.data!.isEmpty)
                        ? const Text("No news to display.")
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              IconButton(
                                  onPressed: () {
                                    if (CountryPage.activeNewsIndex < 2) {
                                      setState(() {
                                        CountryPage.activeNewsIndex = 0;
                                      });
                                    } else {
                                      setState(() {
                                        CountryPage.activeNewsIndex =
                                            CountryPage.activeNewsIndex - 2;
                                      });
                                    }
                                  },
                                  icon: const Icon(
                                    Icons.arrow_back,
                                    color: Color.fromARGB(255, 66, 66, 66),
                                  )),
                              SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width / 175),
                              GestureDetector(
                                onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => NewsScreen(
                                          country: widget.country,
                                          news: newsSnapshot.data![
                                              CountryPage.activeNewsIndex]),
                                    )),
                                child: SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width / 2.95,
                                  child: NewsDisplayer(
                                      imageLink: newsSnapshot
                                          .data![CountryPage.activeNewsIndex]
                                          .image,
                                      newsTitle: newsSnapshot
                                          .data![CountryPage.activeNewsIndex]
                                          .title),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal:
                                        MediaQuery.of(context).size.width /
                                            100),
                                child: GestureDetector(
                                  onTap: () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => NewsScreen(
                                              country: widget.country,
                                              news: newsSnapshot.data![
                                                  CountryPage.activeNewsIndex +
                                                      1]))),
                                  child: SizedBox(
                                    width: MediaQuery.of(context).size.width /
                                        2.95,
                                    child: NewsDisplayer(
                                        imageLink: newsSnapshot
                                            .data![
                                                CountryPage.activeNewsIndex + 1]
                                            .image,
                                        newsTitle: newsSnapshot
                                            .data![
                                                CountryPage.activeNewsIndex + 1]
                                            .title),
                                  ),
                                ),
                              ),
                              SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width / 175),
                              IconButton(
                                  onPressed: () {
                                    if ((newsSnapshot.data!.length - 1) -
                                            CountryPage.activeNewsIndex <
                                        2) {
                                      setState(() {
                                        CountryPage.activeNewsIndex =
                                            newsSnapshot.data!.length - 2;
                                      });
                                    } else {
                                      setState(() {
                                        CountryPage.activeNewsIndex =
                                            CountryPage.activeNewsIndex + 2;
                                      });
                                    }
                                  },
                                  icon: const Icon(
                                    Icons.arrow_forward,
                                    color: Color.fromARGB(255, 66, 66, 66),
                                  )),
                            ],
                          ))
          ],
        ),
      ),
    );
  }
}

class NewsDisplayer extends StatelessWidget {
  const NewsDisplayer(
      {super.key, required this.imageLink, required this.newsTitle});

  final imageLink;
  final String newsTitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height / 7,
          child: (imageLink is String)
              ? Image.network(imageLink)
              : Icon(imageLink),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height / 6,
          child: Text(
            newsTitle,
            overflow: TextOverflow.clip,
          ),
        )
      ],
    );
  }
}

class TravelSection extends StatefulWidget {
  const TravelSection({super.key, required this.country});

  final String country;

  @override
  State<TravelSection> createState() => _TravelSectionState();
}

class _TravelSectionState extends State<TravelSection> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getTourismAttractions(
          countryTravelConverter.containsKey(widget.country)
              ? countryTravelConverter[widget.country].toString()
              : widget.country),
      builder: (context, tourismSnapshot) {
        return Container(
          decoration: const BoxDecoration(
              color: Color.fromARGB(255, 152, 205, 248),
              borderRadius: BorderRadius.all(Radius.circular(15))),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(12.5),
                child: Row(
                  children: [
                    const Icon(Icons.airplane_ticket),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 7.5),
                      child: Text(
                        "TRAVEL",
                        style: GoogleFonts.bebasNeue(fontSize: 20),
                      ),
                    )
                  ],
                ),
              ),
              (tourismSnapshot.connectionState == ConnectionState.waiting)
                  ? const Center(child: Text("Loading..."))
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        IconButton(
                            onPressed: () {
                              if (CountryPage.activePlaceIndex == 0) {
                                setState(() {
                                  CountryPage.activePlaceIndex =
                                      tourismSnapshot.data!.length - 1;
                                });
                              } else {
                                setState(() {
                                  CountryPage.activePlaceIndex =
                                      CountryPage.activePlaceIndex - 1;
                                });
                              }
                            },
                            icon: const Icon(Icons.arrow_back,
                                color: Color.fromARGB(255, 58, 94, 213))),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal:
                                  MediaQuery.of(context).size.width / 100),
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width / 2.95,
                            child: Poster(
                                imageLink: tourismSnapshot
                                    .data![CountryPage.activePlaceIndex].image,
                                placeName: tourismSnapshot
                                    .data![CountryPage.activePlaceIndex].name),
                          ),
                        ),
                        IconButton(
                            onPressed: () {
                              if (CountryPage.activePlaceIndex ==
                                  tourismSnapshot.data!.length - 1) {
                                setState(() {
                                  CountryPage.activePlaceIndex = 0;
                                });
                              } else {
                                setState(() {
                                  CountryPage.activePlaceIndex =
                                      CountryPage.activePlaceIndex + 1;
                                });
                              }
                            },
                            icon: const Icon(Icons.arrow_forward,
                                color: Color.fromARGB(255, 58, 94, 213))),
                      ],
                    )
            ],
          ),
        );
      },
    );
  }
}

class Poster extends StatelessWidget {
  const Poster({super.key, required this.imageLink, required this.placeName});

  final String imageLink;
  final String placeName;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height / 7,
          child: Image.network(imageLink),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height / 10,
          child: Text(
            placeName,
            overflow: TextOverflow.clip,
          ),
        )
      ],
    );
  }
}

class HolidaySection extends StatefulWidget {
  const HolidaySection({super.key, required this.country});

  final String country;

  @override
  State<HolidaySection> createState() => _HolidaySectionState();
}

class _HolidaySectionState extends State<HolidaySection> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getHoliday(countryHolidayConverter[widget.country]!),
      builder: (context, holidaySnapshot) {
        if (holidaySnapshot.hasError) {
          return Text(holidaySnapshot.error.toString());
        } else {
          return Container(
            decoration: const BoxDecoration(
                color: Color.fromARGB(255, 198, 247, 255),
                borderRadius: BorderRadius.all(Radius.circular(15))),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(12.5),
                  child: Row(
                    children: [
                      const Icon(Icons.calendar_month_rounded),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 7.5),
                        child: Text(
                          "NATIONAL HOLIDAYS",
                          style: GoogleFonts.indieFlower(fontSize: 20),
                        ),
                      )
                    ],
                  ),
                ),
                Expanded(
                    child: (holidaySnapshot.connectionState ==
                            ConnectionState.waiting)
                        ? const Center(child: Text("Loading..."))
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              IconButton(
                                  onPressed: () {
                                    if (CountryPage.activeHolidayIndex == 0) {
                                      setState(() {
                                        CountryPage.activeHolidayIndex =
                                            holidaySnapshot.data!.length - 1;
                                      });
                                    } else {
                                      setState(() {
                                        CountryPage.activeHolidayIndex =
                                            CountryPage.activeHolidayIndex - 1;
                                      });
                                    }
                                  },
                                  icon: const Icon(Icons.arrow_back,
                                      color: Color.fromARGB(255, 58, 94, 213))),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal:
                                        MediaQuery.of(context).size.width /
                                            100),
                                child: SizedBox(
                                    width: MediaQuery.of(context).size.width /
                                        2.95,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        Column(
                                          children: [
                                            Text(
                                              holidaySnapshot
                                                  .data![CountryPage
                                                      .activeHolidayIndex]
                                                  .localName,
                                              textAlign: TextAlign.center,
                                              style: GoogleFonts.karla(
                                                fontSize: MediaQuery.of(context)
                                                        .size
                                                        .height /
                                                    20,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Text(
                                              holidaySnapshot
                                                  .data![CountryPage
                                                      .activeHolidayIndex]
                                                  .name,
                                              textAlign: TextAlign.center,
                                              style: GoogleFonts.karla(
                                                  fontSize:
                                                      MediaQuery.of(context)
                                                              .size
                                                              .height /
                                                          30,
                                                  fontWeight: FontWeight.bold,
                                                  fontStyle: FontStyle.italic),
                                            )
                                          ],
                                        ),
                                        Text(
                                          holidaySnapshot
                                              .data![CountryPage
                                                  .activeHolidayIndex]
                                              .date,
                                          style: TextStyle(
                                              fontSize: MediaQuery.of(context)
                                                      .size
                                                      .height /
                                                  40),
                                        )
                                      ],
                                    )),
                              ),
                              IconButton(
                                  onPressed: () {
                                    if (CountryPage.activeHolidayIndex ==
                                        holidaySnapshot.data!.length - 1) {
                                      setState(() {
                                        CountryPage.activeHolidayIndex = 0;
                                      });
                                    } else {
                                      setState(() {
                                        CountryPage.activeHolidayIndex =
                                            CountryPage.activeHolidayIndex + 1;
                                      });
                                    }
                                  },
                                  icon: const Icon(Icons.arrow_forward,
                                      color: Color.fromARGB(255, 58, 94, 213))),
                            ],
                          ))
              ],
            ),
          );
        }
      },
    );
  }
}

class SoccerSection extends StatefulWidget {
  const SoccerSection({super.key, required this.country});

  final String country;

  @override
  State<SoccerSection> createState() => _SoccerSectionState();
}

class _SoccerSectionState extends State<SoccerSection> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<SoccerMatch>>(
      future: getSoccerMatch(context, widget.country),
      builder: (context, matchSnapshot) => Container(
        decoration: const BoxDecoration(
            color: Color.fromARGB(255, 145, 233, 153),
            borderRadius: BorderRadius.all(Radius.circular(15))),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(12.5),
              child: Row(
                children: [
                  const Icon(Icons.sports),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 7.5),
                    child: Text(
                      "Sport",
                      style: GoogleFonts.jost(fontSize: 20),
                    ),
                  )
                ],
              ),
            ),
            (matchSnapshot.hasError)
                ? const Text(
                    "There is a problem with accessing match data.\nThere is not any match to display or there is a technical error.")
                : ((matchSnapshot.connectionState == ConnectionState.waiting)
                    ? const Text("Loading...")
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          IconButton(
                              onPressed: () {
                                if (CountryPage.activeMatchIndex == 0) {
                                  setState(() {
                                    CountryPage.activeMatchIndex =
                                        matchSnapshot.data!.length - 1;
                                  });
                                } else {
                                  setState(() {
                                    CountryPage.activeMatchIndex--;
                                  });
                                }
                              },
                              icon: const Icon(
                                Icons.arrow_back,
                                color: Color.fromARGB(255, 86, 137, 90),
                              )),
                          Padding(
                            padding: EdgeInsets.only(
                                bottom:
                                    MediaQuery.of(context).size.height / 200),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.network(
                                      matchSnapshot
                                          .data![CountryPage.activeMatchIndex]
                                          .league
                                          .image,
                                      height:
                                          MediaQuery.of(context).size.height /
                                              45,
                                    ),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width /
                                          50,
                                    ),
                                    Text(matchSnapshot
                                        .data![CountryPage.activeMatchIndex]
                                        .league
                                        .name)
                                  ],
                                ),
                                SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height / 40,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.network(
                                      matchSnapshot
                                          .data![CountryPage.activeMatchIndex]
                                          .home
                                          .image,
                                      height:
                                          MediaQuery.of(context).size.width /
                                              10,
                                    ),
                                    SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width /
                                                5.5,
                                        child: Center(
                                          child: Text(
                                            matchSnapshot
                                                .data![CountryPage
                                                    .activeMatchIndex]
                                                .home
                                                .name,
                                            style: TextStyle(
                                                fontSize: MediaQuery.of(context)
                                                        .size
                                                        .height /
                                                    75),
                                          ),
                                        )),
                                    Text(
                                      " - ",
                                      style: TextStyle(
                                          fontSize: MediaQuery.of(context)
                                                  .size
                                                  .height /
                                              20),
                                    ),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width /
                                          5.5,
                                      child: Center(
                                        child: Text(
                                          matchSnapshot
                                              .data![
                                                  CountryPage.activeMatchIndex]
                                              .away
                                              .name,
                                          textAlign: TextAlign.end,
                                          style: TextStyle(
                                              fontSize: MediaQuery.of(context)
                                                      .size
                                                      .height /
                                                  75),
                                        ),
                                      ),
                                    ),
                                    Image.network(
                                      matchSnapshot
                                          .data![CountryPage.activeMatchIndex]
                                          .away
                                          .image,
                                      height:
                                          MediaQuery.of(context).size.width /
                                              10,
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
                          IconButton(
                              onPressed: () {
                                if (CountryPage.activeMatchIndex ==
                                    (matchSnapshot.data!.length - 1)) {
                                  setState(() {
                                    CountryPage.activeMatchIndex = 0;
                                  });
                                } else {
                                  setState(() {
                                    CountryPage.activeMatchIndex++;
                                  });
                                }
                              },
                              icon: const Icon(
                                Icons.arrow_forward,
                                color: Color.fromARGB(255, 86, 137, 90),
                              )),
                        ],
                      ))
          ],
        ),
      ),
    );
  }
}
