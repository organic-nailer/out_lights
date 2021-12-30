import 'dart:async';
import 'dart:math';

import 'package:expanded_grid/expanded_grid.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:out_lights/fast_analytics.dart';
import 'package:out_lights/game_over_page.dart';
import 'package:out_lights/question_data.dart';
import 'package:out_lights/stroke_button.dart';
import 'package:intl/intl.dart';
import 'package:out_lights/extention_color.dart';
import 'package:out_lights/table_data.dart';

class TryEndlessPage extends StatefulWidget {
  const TryEndlessPage({Key? key}) : super(key: key);

  @override
  _TryEndlessPageState createState() => _TryEndlessPageState();
}

class _TryEndlessPageState extends State<TryEndlessPage> {
  final timeFormat = NumberFormat("00.0", "ja_JP");
  final scoreFormat = NumberFormat("0000", "ja_JP");
  TableData<bool?> buttonState = [];
  QuestionData? question;
  int remMs = 0;
  int step = 1;
  int score = 0;
  int tapped = 0;
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
    FastAnalytics.screenOpened("TryEndlessPage");
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
          builder: (_) => GameOverPage(step: step, score: score)));
      //GameOverDialog(context).showCustomDialog(10, 20);
    });
  }

  /// return: 想定ミリ秒
  int setNewTable() {
    final int tableSize;
    if (step <= 2) {
      tableSize = 2;
    } else if (step <= 5) {
      tableSize = 3;
    } else if (step <= 10) {
      tableSize = 4;
    } else if (step <= 13) {
      tableSize = 5;
    } else if (step <= 19) {
      tableSize = 6;
    } else {
      tableSize = 9;
    }
    final int lost;
    if (tableSize <= 4) {
      lost = 0;
    } else {
      lost = Random().nextInt((tableSize * tableSize / 4).floor());
    }
    question =
        generateSpecificQuestion(step) ?? generateQuestion(tableSize, lost);
    buttonState = [];
    for (var row in question!.table) {
      buttonState.add(row.map((e) => e == null ? null : e == 1).toList());
    }
    FastAnalytics.sendStartStep(step, tableSize, lost, question!.opsName);
    return tableSize * 20 * 1000;
  }

  void nextGame() {
    final ms = setNewTable();
    lock = false;
    startNewTimer(ms);
  }

  void onTapButton(int index) {
    assert(index >= 0 && index < buttonState.length * buttonState[0].length);
    if (lock) return;
    tapped++;
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
        buttonState[y][x] = !buttonState[y][x]!;
      }
    });
    // すべて凸の場合
    if (buttonState.every((r) => r.every((c) => c == null || !c))) {
      print("Clear");
      _countDownTimer.cancel();
      lock = true;
      final minTap = question!.getBestSolution().where((e) => e == 1).length;
      final sizeFactor = log(buttonState.length * buttonState.length) / log(e);
      score += (max(4.0 - tapped + minTap, 1) *
              max(sqrt(remMs / 1000.0), 5.0) *
              sizeFactor)
          .ceil();
      tapped = 0;
      step++;
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
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor:
            Colors.black.stackOnTop(Colors.yellow.shade500.withOpacity(0.5)),
        body: DefaultTextStyle.merge(
          style: GoogleFonts.shareTechMono(),
          child: SafeArea(
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
                                Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                        builder: (_) => GameOverPage(
                                            step: step, score: score)));
                              },
                              icon: const Icon(Icons.close)),
                          const Text("Endless")
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 100,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Time:",
                            style: TextStyle(fontSize: 20),
                          ),
                          Text(
                            timeFormat.format(remMs / 1000.0),
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                fontSize: 50, fontWeight: FontWeight.bold),
                          ),
                          const Text(
                            " s",
                            style: TextStyle(fontSize: 20),
                          ),
                          const SizedBox(
                            width: 16,
                          ),
                          const Text(
                            "Score:",
                            style: TextStyle(fontSize: 20),
                          ),
                          Text(
                            timeFormat.format(score),
                            style: const TextStyle(
                                fontSize: 50, fontWeight: FontWeight.bold),
                          ),
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
                                          columnIndex:
                                              index % buttonState.length,
                                          rowIndex: (index / buttonState.length)
                                              .floor(),
                                          child: buttonState.index(index) ==
                                                  null
                                              ? Container()
                                              : StrokeButton(
                                                  duration: const Duration(
                                                      milliseconds: 1000),
                                                  value: buttonState[
                                                      (index /
                                                              buttonState
                                                                  .length)
                                                          .floor()][index %
                                                      buttonState.length]!,
                                                  onChanged: (value) {
                                                    onTapButton(index);
                                                  },
                                                  offsetForProjection: min(
                                                      50 / buttonState.length,
                                                      10),
                                                  child: Container(),
                                                  // child: Center(
                                                  //   child: Text(solution[index] == 1
                                                  //       ? "押す"
                                                  //       : "押さない"),
                                                  // ),
                                                  surfaceColor: ColorTween(
                                                      begin: Colors.black
                                                          .stackOnTop(Colors
                                                              .yellow
                                                              .withOpacity(
                                                                  0.8)),
                                                      end: Colors
                                                          .brown.shade700),
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
