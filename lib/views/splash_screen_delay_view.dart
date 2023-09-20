import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:contatos/views/home_contatos_view.dart';
import 'package:flutter/material.dart';

class SplashScreenDelayView extends StatefulWidget {
  const SplashScreenDelayView({super.key});

  @override
  State<SplashScreenDelayView> createState() => _SplashScreenDelayViewState();
}

class _SplashScreenDelayViewState extends State<SplashScreenDelayView> {
  toHomeContaosView() {
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => const HomeContatosView()));
    });
  }

  @override
  Widget build(BuildContext context) {
    toHomeContaosView();
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
              Colors.blue,
              Colors.purple,
            ],
                stops: [
              0.3,
              0.7
            ])),
        child: Center(
          child: AnimatedTextKit(
            animatedTexts: [
              TypewriterAnimatedText(
                'Meus Contatos',
                textStyle: const TextStyle(
                  fontSize: 32.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                speed: const Duration(milliseconds: 100),
              ),
            ],
            totalRepeatCount: 4,
            pause: const Duration(milliseconds: 50),
            displayFullTextOnTap: true,
            stopPauseOnTap: true,
          ),
        ),
      ),
    );
  }
}
