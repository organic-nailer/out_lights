import 'package:flutter/material.dart';
import 'package:out_lights/front_page.dart';
import 'package:out_lights/modal_overlay.dart';
import 'package:out_lights/stroke_button.dart';
import 'package:out_lights/try_endress_page.dart';

class GameOverDialog {
  BuildContext context;
  GameOverDialog(this.context) : super();

  /*
   * 表示
   */
  void showCustomDialog(int step, int score) {
    Navigator.push(
      context,
      ModalOverlay(
        Center(
            child: SizedBox(
          height: 592,
          width: 400,
          child: StrokeButton(
            surfaceColor:
                ColorTween(begin: Colors.yellow.shade800, end: Colors.brown),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: Center(
                      child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Text(
                          "Happy New Year!",
                          style: TextStyle(fontSize: 30),
                        ),
                      ),
                      Text(
                        "Steps: $step",
                        style: const TextStyle(fontSize: 20),
                      ),
                      Text(
                        "Score: $score",
                        style: const TextStyle(fontSize: 40),
                      ),
                    ],
                  )),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(
                          onPressed: () {
                            Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                    builder: (_) => const TryEndressPage()));
                          },
                          icon: const Icon(Icons.refresh)),
                      IconButton(
                          onPressed: () {}, icon: const Icon(Icons.share)),
                      IconButton(
                          onPressed: () {
                            Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                    builder: (_) => const FrontPage()));
                          },
                          icon: const Icon(Icons.home)),
                    ],
                  ),
                )
              ],
            ),
          ),
        )),
        isAndroidBackEnable: false,
      ),
    );
  }

  /*
   * 非表示
   */
  void hideCustomDialog() {
    Navigator.of(context).pop();
  }
}
