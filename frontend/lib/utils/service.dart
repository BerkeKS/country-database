import 'dart:convert';
import 'package:country_data/models/attraction.dart';
import 'package:country_data/models/holiday.dart';
import 'package:country_data/utils/time.dart';

import '../database.dart';
import '../models/news.dart';
import '../models/soccerMatch.dart';
import '../models/country.dart';
import '../models/countryMini.dart';
import '../models/latlong.dart';
import '../models/weather.dart';
import '../utils/images.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

String thousandDigit(String num) {
  String numNewVersion = "";
  int count = 1;
  int index = num.length - 1;
  while (index >= 0) {
    if (count % 3 == 0) {
      if (index == 0) {
        numNewVersion = "$numNewVersion${num[index]}";
      } else {
        numNewVersion = "$numNewVersion${num[index]},";
      }
    } else {
      numNewVersion = "$numNewVersion${num[index]}";
    }
    count++;
    index--;
  }
  numNewVersion = numNewVersion.split('').reversed.join('');
  return numNewVersion;
}

Future<List<CountryMini>> getBasicInfo(String continent) async {
  List<CountryMini> countries = [];
  var response = await http.get(
      Uri.parse("https://restcountries.com/v3.1/region/$continent"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      });
  if (response.statusCode == 200) {
    var jsonResponse = jsonDecode(utf8.decode(response.bodyBytes));
    for (var c in jsonResponse) {
      CountryMini mini = CountryMini(
          name: c['name']['common'],
          flag: c['flags']['png'],
          capital: (c['capital'] != null)
              ? (c['capital'] as List<dynamic>).cast<String>()
              : ["None"],
          population: thousandDigit(c["population"].toString()),
          continents: (c["continents"] as List<dynamic>).cast<String>(),
          alpha: c["cca2"]);
      countries.add(mini);
    }
    if (continent == "asia") {
      var secondResponse = await http.get(
        Uri.parse("https://restcountries.com/v3.1/region/oceania"),
      );
      var secondJSONResponse =
          jsonDecode(utf8.decode(secondResponse.bodyBytes));
      for (var c in secondJSONResponse) {
        CountryMini mini = CountryMini(
            name: c['name']['common'],
            flag: c['flags']['png'],
            capital: (c['capital'] != null)
                ? (c['capital'] as List<dynamic>).cast<String>()
                : ["None"],
            population: thousandDigit(c["population"].toString()),
            continents: (c["continents"] as List<dynamic>).cast<String>(),
            alpha: c["cca2"]);
        countries.add(mini);
      }
      countries.sort((a, b) => a.name.compareTo(b.name));
      return countries;
    } else {
      countries.sort((a, b) => a.name.compareTo(b.name));
      return countries;
    }
  } else {
    throw Exception(response.toString());
  }
}

Future<List<String>> getSubregions(String continent) async {
  List<String> subregions = [];
  var response = await http
      .get(Uri.parse("https://restcountries.com/v3.1/region/$continent"));
  if (response.statusCode == 200) {
    var jsonResponse = jsonDecode(utf8.decode(response.bodyBytes));
    for (var c in jsonResponse) {
      if (!subregions.contains(c["subregion"])) {
        subregions.add(c["subregion"]);
      }
    }
    if (continent == "Asia") {
      var secondResponse = await http
          .get(Uri.parse("https://restcountries.com/v3.1/region/oceania"));
      var secondJSONResponse =
          jsonDecode(utf8.decode(secondResponse.bodyBytes));
      for (var c in secondJSONResponse) {
        if (!subregions.contains(c["subregion"])) {
          subregions.add(c["subregion"]);
        }
      }
      subregions.sort((a, b) => a.compareTo(b));
      return subregions;
    } else {
      subregions.sort((a, b) => a.compareTo(b));
      return subregions;
    }
  } else {
    throw Exception(response.toString());
  }
}

Future<List<LatLong>> getLocation(BuildContext context) async {
  var response =
      await http.get(Uri.parse("https://restcountries.com/v3.1/all"));
  if (response.statusCode == 200) {
    List<LatLong> locationList = [];
    var jsonResponse = jsonDecode(utf8.decode(response.bodyBytes));
    for (var c in jsonResponse) {
      LatLong location = LatLong(
          country: c["name"]["common"],
          flag: c['flags']['png'],
          latitude: (c["latlng"] as List<dynamic>).cast<double>()[0],
          longitude: (c["latlng"] as List<dynamic>).cast<double>()[1]);
      locationList.add(location);
    }
    return locationList;
  } else {
    throw ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(response.body)));
  }
}

Future<Country> getCountry(BuildContext context, String countryName) async {
  var response = await http
      .get(Uri.parse("https://restcountries.com/v3.1/name/${countryName}"));
  if (response.statusCode == 200) {
    var jsonResponse = jsonDecode(utf8.decode(response.bodyBytes));
    late Country country;
    for (var c in jsonResponse) {
      country = Country(
          name: c["name"]["common"],
          officialName: c["name"]["official"],
          flag: c['flags']['png'],
          alpha3code: c["cca3"],
          capital: (c['capital'] != null)
              ? (c['capital'] as List<dynamic>).cast<String>()
              : ["None"],
          population: thousandDigit(c["population"].toString()),
          gallery: imagesData[(c["name"]["common"])]!,
          timezones: (c['timezones'] as List<dynamic>).cast<String>());
    }
    return country;
  } else {
    throw ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(response.body)));
  }
}

Future<Weather> getWeather(String country) async {
  var response = await http.get(
      Uri.parse("http://api.weatherapi.com/v1/current.json?q=${country}"),
      headers: {"key": dotenv.env['WEATHER_KEY']!});
  if (response.statusCode == 200) {
    var jsonResponse = jsonDecode(response.body);
    String local = jsonResponse["location"]["localtime"];
    Weather weather = Weather(
        text: jsonResponse["current"]["condition"]["text"],
        icon: jsonResponse["current"]["condition"]["icon"],
        localTime: local.split(" "));
    return weather;
  } else {
    throw const Text("No Data");
  }
}

Stream<Weather> streamWeather(String country) =>
    Stream.periodic(const Duration(seconds: 1))
        .asyncMap((_) => getWeather(country));

Future<List<String>> getLocalTime(String area) async {
  var response =
      await http.get(Uri.parse("http://worldtimeapi.org/api/timezone/$area"));
  if (response.statusCode == 200) {
    var jsonResponse = jsonDecode(response.body);
    var local = jsonResponse["datetime"].toString().split("T");
    String localDate = local[0];
    String localTime = local[1].substring(0, 5);
    return [localDate, localTime];
  } else {
    throw const Text("No Data");
  }
}

Stream<List<String>> streamLocalTime(String area) =>
    Stream.periodic(const Duration(seconds: 1))
        .asyncMap((_) => getLocalTime(area));

void openWikipedia(BuildContext context, String country) async {
  var response =
      await http.get(Uri.parse("https://restcountries.com/v3.1/name/$country"));
  if (response.statusCode == 200) {
    var jsonResponse = jsonDecode(utf8.decode(response.bodyBytes));
    String countryName = "";
    for (var c in jsonResponse) {
      countryName = c["name"]["common"];
    }
    final Uri url = Uri.parse("https://en.wikipedia.org/wiki/$countryName");
    if (!await launchUrl(url)) {
      throw ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Could not launch $url')));
    }
  } else {
    throw ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(response.body)));
  }
}

void getMap(BuildContext context, String country) async {
  var response =
      await http.get(Uri.parse("https://restcountries.com/v3.1/name/$country"));
  if (response.statusCode == 200) {
    var jsonResponse = jsonDecode(utf8.decode(response.bodyBytes));
    String mapLink = "";
    for (var c in jsonResponse) {
      mapLink = c["maps"]["openStreetMaps"];
    }
    final Uri mapURL = Uri.parse(mapLink);
    if (!await launchUrl(mapURL)) {
      throw ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Could not launch $mapURL')));
    } else {
      throw ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(response.body)));
    }
  }
}

Future<List<News>> getNews(BuildContext context, String country) async {
  //Store API key in a more secure way
  var response = await http.get(Uri.parse(
      "https://api.worldnewsapi.com/search-news?api-key=${dotenv.env['NEWS_KEY']}&source-countries=$country&number=50"));
  if (response.statusCode == 200) {
    List<News> newsList = [];
    var jsonResponse = jsonDecode(utf8.decode(response.bodyBytes))["news"];
    for (var n in jsonResponse) {
      News news = News(
        title: n["title"],
        content: (n["text"] == null) ? "No Content" : n["text"],
        link: n["url"],
        image: (n["image"] == null) ? Icons.newspaper : n["image"],
        date: n["publish_date"].toString().split(" ")[0],
        time: n["publish_date"].toString().split(" ")[1],
      );
      newsList.add(news);
    }
    return newsList;
  } else {
    throw response.body;
  }
}

Future<List<Attraction>> getTourismAttractions(String country) async {
  var response = await http.get(
      Uri.parse(
          "https://travel-info-api.p.rapidapi.com/country?country=$country"),
      headers: {
        'X-RapidAPI-Key': dotenv.env['TRAVEL_KEY']!,
        'X-RapidAPI-Host': dotenv.env['TRAVEL_HOST']!
      });
  if (response.statusCode == 200) {
    List<Attraction> tourismAttractions = [];
    var jsonResponse = jsonDecode(response.body)["data"]["country_images"];
    for (var a in jsonResponse) {
      Attraction attraction =
          Attraction(name: a["title"], image: a["imageUrl"]);
      tourismAttractions.add(attraction);
    }
    return tourismAttractions;
  } else {
    throw Text(response.body);
  }
}

Future<List<Holiday>> getHoliday(String country) async {
  DateTime now = DateTime.now();
  String today = now.toString().split(" ")[0];
  String currentYear = today.split("-")[0];
  var res = await http.get(Uri.parse(
      "https://date.nager.at/api/v3/PublicHolidays/${currentYear}/$country"));
  if (res.statusCode == 200) {
    List<Holiday> holidays = [];
    var jsonResponse = jsonDecode(utf8.decode(res.bodyBytes));
    for (var h in jsonResponse) {
      Holiday holiday = Holiday(
        name: h["name"],
        localName: h["localName"],
        date: h["date"],
      );
      holidays.add(holiday);
    }
    return holidays;
  } else {
    throw res.body;
  }
}

Future<List<SoccerMatch>> getSoccerMatch(
    BuildContext context, String country) async {
  DateTime current = DateTime.now();
  String today = current.toString().split(' ')[0];
  String currentYear = today.split('-')[0];
  String currentMonth = today.split('-')[1];
  int currentDay = int.parse(today.split('-')[2]);
  int weekdayNum = weekdayInt();

  List leagues = soccerLeagueData[country]!;
  List<SoccerMatch> soccerMatches = [];
  for (var league in leagues) {
    var response = await http.get(
        Uri.parse(
            "https://v3.football.api-sports.io/fixtures?league=$league&from=$currentYear-${numFix(int.parse(currentMonth))}-${numFix(currentDay - weekdayNum)}&to=$currentYear-${numFix(int.parse(currentMonth))}-${numFix(currentDay + (6 - weekdayNum))}&season=$currentYear"),
        headers: {
          "x-rapidapi-host": dotenv.env['FOOTBALL_HOST']!,
          "x-rapidapi-key": dotenv.env['FOOTBALL_KEY']!
        });
    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body)["response"];
      for (var m in jsonResponse) {
        SoccerMatch match = SoccerMatch(
            league:
                League(image: m["league"]["logo"], name: m["league"]["name"]),
            home: Team(
                image: m["teams"]["home"]["logo"],
                name: m["teams"]["home"]["name"],
                goal: (m["goals"]["home"] == null)
                    ? ""
                    : m["goals"]["home"].toString()),
            away: Team(
                image: m["teams"]["away"]["logo"],
                name: m["teams"]["away"]["name"],
                goal: (m["goals"]["away"] == null)
                    ? ""
                    : m["goals"]["away"].toString()));
        soccerMatches.add(match);
      }
    }
  }
  if (soccerMatches.isEmpty) {
    throw Padding(
        padding: EdgeInsets.all(MediaQuery.of(context).size.width / 500),
        child: const Text(
            "There is a problem with accessing match data.\nThere is not any match to display or there is a technical error."));
  } else {
    return soccerMatches;
  }
}

Stream<List<SoccerMatch>> streamSoccerMatch(
        BuildContext context, String country) =>
    Stream.periodic(const Duration(seconds: 20))
        .asyncMap((_) => getSoccerMatch(context, country));
