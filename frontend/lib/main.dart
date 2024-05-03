import 'package:country_data/views/introScreen.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:flutter/material.dart';

Future main() async {
  await dotenv.load(fileName: "lib/.env");
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Database of Countries",
      home: IntroSlides(),
    );
  }
}

class IntroSlides extends StatefulWidget {
  const IntroSlides({super.key});

  @override
  State<IntroSlides> createState() => _IntroSlidesState();
}

class _IntroSlidesState extends State<IntroSlides> {
  final PageController _controller = PageController();
  bool onLastPage = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        PageView(
          controller: _controller,
          onPageChanged: (pageIndex) {
            setState(() {
              onLastPage = (pageIndex == 3);
            });
          },
          children: const [
            IntroScreen(continent: "Africa"),
            IntroScreen(continent: "Americas"),
            IntroScreen(continent: "Asia"),
            IntroScreen(continent: "Europe"),
          ],
        ),
        Container(
          alignment: const Alignment(0, 0.9),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                  onPressed: () {
                    if (_controller.page == 0) {
                      _controller.animateToPage(3,
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.easeIn);
                    } else {
                      _controller.previousPage(
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.easeIn);
                    }
                  },
                  icon: const Icon(Icons.arrow_back)),
              SmoothPageIndicator(controller: _controller, count: 4),
              IconButton(
                  onPressed: () {
                    if (onLastPage) {
                      _controller.animateToPage(0,
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.easeIn);
                    } else {
                      _controller.nextPage(
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.easeIn);
                    }
                  },
                  icon: const Icon(Icons.arrow_forward)),
            ],
          ),
        )
      ],
    ));
  }
}
