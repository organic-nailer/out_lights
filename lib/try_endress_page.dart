import 'dart:async';

import 'package:expanded_grid/expanded_grid.dart';
import 'package:flutter/material.dart';
import 'package:out_lights/dialog_game_over.dart';
import 'package:out_lights/game_over_page.dart';
import 'package:out_lights/main.dart';
import 'package:out_lights/stroke_button.dart';
import 'package:intl/intl.dart';
import 'package:out_lights/extention_color.dart';

class TryEndressPage extends StatefulWidget {
  const TryEndressPage({Key? key}) : super(key: key);

  @override
  _TryEndressPageState createState() => _TryEndressPageState();
}

class _TryEndressPageState extends State<TryEndressPage> {
  final timeFormat = NumberFormat("00.0", "ja_JP");
  List<List<bool>> buttonState = [];
  QuestionData? question;
  int remMs = 0;
  int step = 1;
  bool lock = false;

  bool gameOver = false;
  late CountDownTimer _countDownTimer;

  @override
  void initState() {
    super.initState();
    _countDownTimer = CountDownTimer(onTick: (value) {
      setState(() {
        remMs = value;
      });
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    startNewTimer(setNewTable());
  }

  void startNewTimer(int maxMs) {
    _countDownTimer.cancel();
    _countDownTimer.start(maxMs, () {
      setState(() {
        gameOver = true;
        lock = true;
      });
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (_) => const GameOverPage(step: 10, score: 20)));
      //GameOverDialog(context).showCustomDialog(10, 20);
    });
  }

  /// return: 想定ミリ秒
  int setNewTable() {
    question = generateQuestion(3);
    buttonState = [];
    for (var row in question!.table) {
      buttonState.add(row.map((e) => e == 1).toList());
    }
    return 1 * 1000;
  }

  void nextGame() {
    final ms = setNewTable();
    lock = false;
    startNewTimer(ms);
  }

  void onTapButton(int index) {
    assert(index >= 0 && index < buttonState.length * buttonState[0].length);
    if (lock) return;
    setState(() {
      for (var op in question!.ops) {
        final x = index % buttonState.length + op.dx;
        final y = (index / buttonState.length).floor() + op.dy;
        if (x < 0 ||
            x >= buttonState.length ||
            y < 0 ||
            y >= buttonState.length) {
          continue;
        }
        buttonState[y][x] = !buttonState[y][x];
      }
    });
    // すべて凸の場合
    if (buttonState.every((r) => r.every((c) => !c))) {
      print("Clear");
      step++;
      _countDownTimer.cancel();
      lock = true;
      Future.delayed(const Duration(milliseconds: 1000), () {
        setState(() {
          for (var row in buttonState) {
            for (int i = 0; i < row.length; i++) {
              row[i] = true;
            }
          }
        });
        Future.delayed(const Duration(milliseconds: 1000), () {
          setState(() {
            nextGame();
          });
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final solution = question!.getBestSolution();
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor:
            Colors.black.stackOnTop(Colors.yellow.shade500.withOpacity(0.5)),
        body: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 700),
              child: Column(
                children: [
                  SizedBox(
                    height: 56,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: const Icon(Icons.arrow_back)),
                        const Text("Endless")
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 56,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text("ボタンを押して全部黄色にしよう！"),
                        Text("Time: ${timeFormat.format(remMs / 1000.0)} s")
                      ],
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                            maxWidth: 140.0 * buttonState.length),
                        child: AspectRatio(
                            aspectRatio: 1,
                            child: ExpandedGrid(
                              column: buttonState.length,
                              row: buttonState.length,
                              children: List.generate(
                                  buttonState.length * buttonState.length,
                                  (index) => ExpandedGridContent(
                                        columnIndex: index % buttonState.length,
                                        rowIndex: (index / buttonState.length)
                                            .floor(),
                                        child: StrokeButton(
                                          duration: const Duration(
                                              milliseconds: 1000),
                                          value: buttonState[
                                                  (index / buttonState.length)
                                                      .floor()]
                                              [index % buttonState.length],
                                          onChanged: (value) {
                                            onTapButton(index);
                                          },
                                          child: Container(),
                                          // child: Center(
                                          //   child: Text(solution[index] == 1
                                          //       ? "押す"
                                          //       : "押さない"),
                                          // ),
                                          surfaceColor: ColorTween(
                                              begin: Colors.black.stackOnTop(
                                                  Colors.yellow
                                                      .withOpacity(0.8)),
                                              end: Colors.brown.shade700),
                                        ),
                                      )),
                            )),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class CountDownTimer {
  int remMs = 0;
  final int tickMs;
  int maxMs = 30 * 1000;
  Timer? mTimer;
  final Function(int remMs) onTick;
  CountDownTimer({this.tickMs = 100, required this.onTick});

  void start(int maxMs, Function onFinish) {
    mTimer = Timer.periodic(Duration(milliseconds: tickMs), (timer) {
      onTick(maxMs - timer.tick * tickMs);
      if (maxMs - timer.tick * tickMs <= 0) {
        onFinish();
        timer.cancel();
      }
    });
  }

  void cancel() {
    mTimer?.cancel();
    mTimer = null;
  }
}
