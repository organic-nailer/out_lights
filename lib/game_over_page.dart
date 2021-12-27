import 'package:expanded_grid/expanded_grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:out_lights/extention_color.dart';
import 'package:out_lights/front_page.dart';
import 'package:out_lights/stroke_button.dart';
import 'package:out_lights/try_endress_page.dart';
import 'package:url_launcher/url_launcher.dart';

class GameOverPage extends StatefulWidget {
  final int step;
  final int score;
  const GameOverPage({Key? key, required this.step, required this.score})
      : super(key: key);

  @override
  _GameOverPageState createState() => _GameOverPageState();
}

class _GameOverPageState extends State<GameOverPage> {
  List<bool> buttonStates = [];
  List<List<int>> effectList = [
    [0, 1, 2],
    [0, 1, 3],
    [0, 2, 3, 4, 5],
    [1, 2, 3, 6],
    [2, 4, 5, 7],
    [2, 4, 5, 6, 8],
    [3, 5, 6, 9],
    [4, 7, 8],
    [5, 7, 8, 9],
    [6, 8, 9]
  ];
  @override
  void initState() {
    super.initState();
    buttonStates = List.generate(10, (index) => false);
  }

  void onClickButton(int index) {
    setState(() {
      for (var value in effectList[index]) {
        buttonStates[value] = !buttonStates[value];
      }
    });
    if (index >= 4 && buttonStates[index]) {
      Future.delayed(const Duration(milliseconds: 1000), () {
        switch (index) {
          case 4:
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (_) => const TryEndressPage()));
            break;
          case 5:
            tweetScore(widget.step, widget.score);
            break;
          case 6:
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (_) => const FrontPage()));
            break;
          case 7:
            openUrl("https://fastriver.dev");
            break;
          case 8:
            openUrl("https://year-greeting-condition2020.fastriver.dev");
            break;
          case 9:
            openUrl("https://p987.fastriver.dev");
        }
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
          style: GoogleFonts.oswald(),
          child: SafeArea(
            child: Center(
                child: SizedBox(
              height: 592,
              width: 400,
              child: Column(
                children: [
                  const SizedBox(
                    height: 59,
                    child: Text(
                      "Happy New Year!",
                      style: TextStyle(fontSize: 30),
                    ),
                  ),
                  Expanded(
                    child: ExpandedGrid(
                      row: 4,
                      column: 3,
                      children: [
                        ExpandedGridContent(
                          rowIndex: 0,
                          columnIndex: 0,
                          columnSpan: 2,
                          child: StrokeButton(
                            value: buttonStates[0],
                            onChanged: (_) => onClickButton(0),
                            surfaceColor: ColorTween(
                                begin: Colors.yellow.shade800,
                                end: Colors.brown),
                            child: const Center(
                              child: Text(
                                "Steps:",
                                style: TextStyle(fontSize: 50),
                              ),
                            ),
                          ),
                        ),
                        ExpandedGridContent(
                          rowIndex: 0,
                          columnIndex: 2,
                          child: StrokeButton(
                            value: buttonStates[1],
                            onChanged: (_) => onClickButton(1),
                            surfaceColor: ColorTween(
                                begin: Colors.yellow.shade800,
                                end: Colors.brown),
                            child: Center(
                              child: Text(
                                widget.step.toString(),
                                style: const TextStyle(fontSize: 30),
                              ),
                            ),
                          ),
                        ),
                        ExpandedGridContent(
                          rowIndex: 1,
                          columnIndex: 0,
                          columnSpan: 2,
                          child: StrokeButton(
                            value: buttonStates[2],
                            onChanged: (_) => onClickButton(2),
                            surfaceColor: ColorTween(
                                begin: Colors.yellow.shade800,
                                end: Colors.brown),
                            child: const Center(
                              child: Text(
                                "Score:",
                                style: TextStyle(fontSize: 50),
                              ),
                            ),
                          ),
                        ),
                        ExpandedGridContent(
                          rowIndex: 1,
                          columnIndex: 2,
                          child: StrokeButton(
                            value: buttonStates[3],
                            onChanged: (_) => onClickButton(3),
                            surfaceColor: ColorTween(
                                begin: Colors.yellow.shade800,
                                end: Colors.brown),
                            child: Center(
                              child: Text(
                                widget.score.toString(),
                                style: const TextStyle(fontSize: 30),
                              ),
                            ),
                          ),
                        ),
                        ExpandedGridContent(
                          rowIndex: 2,
                          columnIndex: 0,
                          child: StrokeButton(
                            value: buttonStates[4],
                            onChanged: (_) => onClickButton(4),
                            surfaceColor: ColorTween(
                                begin: Colors.yellow.shade800,
                                end: Colors.brown),
                            child: const Center(
                                child: Icon(Icons.refresh, size: 50)),
                          ),
                        ),
                        ExpandedGridContent(
                          rowIndex: 2,
                          columnIndex: 1,
                          child: StrokeButton(
                            value: buttonStates[5],
                            onChanged: (_) => onClickButton(5),
                            surfaceColor: ColorTween(
                                begin: Colors.yellow.shade800,
                                end: Colors.brown),
                            child: const Center(
                                child: Icon(Icons.share, size: 50)),
                          ),
                        ),
                        ExpandedGridContent(
                          rowIndex: 2,
                          columnIndex: 2,
                          child: StrokeButton(
                            value: buttonStates[6],
                            onChanged: (_) => onClickButton(6),
                            surfaceColor: ColorTween(
                                begin: Colors.yellow.shade800,
                                end: Colors.brown),
                            child: const Center(
                                child: Icon(
                              Icons.home,
                              size: 50,
                            )),
                          ),
                        ),
                        ExpandedGridContent(
                          rowIndex: 3,
                          columnIndex: 0,
                          child: StrokeButton(
                            value: buttonStates[7],
                            onChanged: (_) => onClickButton(7),
                            surfaceColor: ColorTween(
                              begin: const Color(0xFF60807E),
                              end: const Color(0xFF60807E),
                            ),
                            child: Image.asset("image/fastriver.png"),
                          ),
                        ),
                        ExpandedGridContent(
                          rowIndex: 3,
                          columnIndex: 1,
                          child: StrokeButton(
                            value: buttonStates[8],
                            onChanged: (_) => onClickButton(8),
                            surfaceColor: ColorTween(
                                begin: Colors.white, end: Colors.black),
                            child: Image.asset("image/cheese.png"),
                          ),
                        ),
                        ExpandedGridContent(
                          rowIndex: 3,
                          columnIndex: 2,
                          child: StrokeButton(
                            value: buttonStates[9],
                            onChanged: (_) => onClickButton(9),
                            surfaceColor: ColorTween(
                                begin: Colors.green.shade800,
                                end: Colors.green.shade800),
                            child: Image.asset("image/p987.png"),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              // child: StrokeButton(
              //   surfaceColor:
              //       ColorTween(begin: Colors.yellow.shade800, end: Colors.brown),
              //   child: Column(
              //     crossAxisAlignment: CrossAxisAlignment.stretch,
              //     children: [
              //       Expanded(
              //         child: Center(
              //             child: Column(
              //           mainAxisSize: MainAxisSize.min,
              //           children: [
              //             const Padding(
              //               padding: EdgeInsets.all(16.0),
              //               child: Text(
              //                 "Happy New Year!",
              //                 style: TextStyle(fontSize: 30),
              //               ),
              //             ),
              //             Text(
              //               "Steps: ${widget.step}",
              //               style: const TextStyle(fontSize: 20),
              //             ),
              //             Text(
              //               "Score: ${widget.score}",
              //               style: const TextStyle(fontSize: 40),
              //             ),
              //           ],
              //         )),
              //       ),
              //       Padding(
              //         padding: const EdgeInsets.all(16.0),
              //         child: Row(
              //           mainAxisSize: MainAxisSize.max,
              //           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              //           children: [
              //             IconButton(
              //                 onPressed: () {
              //                   Navigator.of(context).pushReplacement(
              //                       MaterialPageRoute(
              //                           builder: (_) => const TryEndressPage()));
              //                 },
              //                 icon: const Icon(Icons.refresh)),
              //             IconButton(
              //                 onPressed: () {}, icon: const Icon(Icons.share)),
              //             IconButton(
              //                 onPressed: () {
              //                   Navigator.of(context).pushReplacement(
              //                       MaterialPageRoute(
              //                           builder: (_) => const FrontPage()));
              //                 },
              //                 icon: const Icon(Icons.home)),
              //           ],
              //         ),
              //       )
              //     ],
              //   ),
              // ),
            )),
          ),
        ),
      ),
    );
  }
}

void openUrl(String url) async {
  try {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  } catch (e) {
    1;
  }
}

void tweetScore(int step, int score) async {
  //TODO: IMPLEMENT
  var url = "https://twitter.com";
  openUrl(url);
}
