import 'package:country_data/models/news.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class NewsScreen extends StatelessWidget {
  const NewsScreen({required this.country, required this.news});
  final String country;
  final News news;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Builder(
          builder: (context) => SingleChildScrollView(
                  child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width / 20),
                child: Column(children: [
                  SizedBox(height: MediaQuery.of(context).size.height / 50),
                  Text(
                    news.title,
                    style: GoogleFonts.noticiaText(fontSize: 25),
                  ),
                  SizedBox(width: MediaQuery.of(context).size.width / 55),
                  Row(
                    children: [
                      Text(
                        news.date,
                      ),
                      SizedBox(width: MediaQuery.of(context).size.width / 55),
                      Text(news.time)
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: MediaQuery.of(context).size.height / 100),
                    child: Image.network(news.image),
                  ),
                  Text(
                    news.content,
                    style: GoogleFonts.noticiaText(),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: MediaQuery.of(context).size.height / 1000),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Source"),
                        ElevatedButton.icon(
                          onPressed: () => launchUrl(Uri.parse(news.link)),
                          icon: const Icon(Icons.newspaper_sharp),
                          label: const Text("Open in Website"),
                          style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  const Color.fromARGB(255, 97, 96, 96)),
                        )
                      ],
                    ),
                  )
                ]),
              ))),
    );
  }
}
