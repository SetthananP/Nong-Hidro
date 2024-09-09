import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:google_fonts/google_fonts.dart';

class IntroScreen extends StatelessWidget {
  const IntroScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IntroductionScreen(
        globalBackgroundColor: Colors.white,
        scrollPhysics: BouncingScrollPhysics(),
        pages: [
          PageViewModel(
            titleWidget: Text(
              "Welcome to Nong Hidro",
              style: GoogleFonts.poppins(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Color(0xFF013237),
              ),
            ),
            body:
                "Let's start your journey with Nong Hidro. Discover amazing features and functionalities that will enhance your experience.",
            image: Image.asset(
              "assets/onboardingScreen1.png",
              height: 400,
              width: 400,
            ),
          ),
          PageViewModel(
            titleWidget: Text(
              "Why Choose Nong Hidro?",
              style: GoogleFonts.poppins(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Color(0xFF013237),
              ),
            ),
            body:
                "Discover the benefits of using Nong Hidro. From saving time to enhancing productivity, we're here to make your life easier.",
            image: Image.asset(
              "assets/onboardingScreen2.png",
              height: 400,
              width: 400,
            ),
          ),
          PageViewModel(
            titleWidget: Text(
              "Let's Begin Now!",
              style: GoogleFonts.poppins(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Color(0xFF013237),
              ),
            ),
            body:
                "Join now and experience the magic of Nong Hidro firsthand. It only takes a few seconds to get started.",
            image: Image.asset(
              "assets/onboardingScreen3.png",
              height: 400,
              width: 400,
            ),
          ),
        ],
        onDone: () {
          Navigator.pushNamed(context, "choosePant");
        },
        onSkip: () {
          Navigator.pushNamed(context, "choosePant");
        },
        showSkipButton: true,
        skip: Text(
          "Skip",
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF013237),
          ),
        ),
        next: Icon(
          Icons.arrow_forward,
          color: Color(0xFF013237),
        ),
        done: Text(
          "Done",
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF013237),
          ),
        ),
        dotsDecorator: DotsDecorator(
            size: Size.square(10),
            activeSize: Size(20, 10),
            color: Colors.black26,
            activeColor: Color(0xFF013237),
            spacing: EdgeInsets.symmetric(horizontal: 3),
            activeShape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25),
            )),
      ),
    );
  }
}
