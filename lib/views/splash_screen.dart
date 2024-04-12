import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:music_app/consts/colors.dart';
import 'package:music_app/consts/text_style.dart';
import 'package:music_app/views/login.dart';

class Splash extends StatelessWidget {
  Splash({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgDarkColor,
      body: SizedBox(
        height: double.infinity,
        width: double.infinity,
        child: Center(
          child: Animate(
            effects: const [
              FlipEffect()
            ],
            delay: const Duration(seconds: 3),
            onComplete: (AnimationController controller){
              if(controller.isCompleted){
                Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (ctx) => const AuthScreen()), (route) => false);
              }
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.sort_rounded,
                  color: whiteColor,
                  size: 40,
                ),
                Text("Beats", style: ourStyle(size: 30),),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
