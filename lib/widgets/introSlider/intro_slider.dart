import 'package:flutter/material.dart';
import 'package:intro_slider/intro_slider.dart';

class IntroScreen extends StatefulWidget {
  final void Function()? onDonePressed;
  const IntroScreen({super.key, this.onDonePressed});

  @override
  IntroScreenState createState() => IntroScreenState();
}

class IntroScreenState extends State<IntroScreen> {
  List<ContentConfig> slides = [];

  @override
  void initState() {
    super.initState();

    slides.add(
      ContentConfig(
        title: "Suchen und Downloaden",
        maxLineTitle: 2,
        marginTitle: EdgeInsets.only(top: 20.0, bottom: 20.0),
        description: "Durchsuchen von öffentlich-rechtlichen Mediatheken.",
        centerWidget: Container(
            padding: EdgeInsets.only(left: 20.0, right: 20.0),
            child: Image(image: AssetImage("assets/intro/intro_slider_1.png"))),
        backgroundColor: Color(0xfff5a623),
      ),
    );
    slides.add(
      ContentConfig(
        title: "Filtern",
        description: "Filtern nach Thema, Titel, Länge und Fernsehsender",
        centerWidget: Container(
            padding: EdgeInsets.only(left: 20.0, right: 20.0),
            child: Image(image: AssetImage("assets/intro/intro_slider_2.png"))),
        backgroundColor: Color(0xff203152),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return IntroSlider(
      listContentConfig: slides,
      onDonePress: widget.onDonePressed,
    );
  }
}
