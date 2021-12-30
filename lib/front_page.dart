import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:out_lights/fast_analytics.dart';
import 'package:out_lights/game_over_page.dart';
import 'package:out_lights/stroke_button.dart';
import 'package:out_lights/try_endress_page.dart';

class FrontPage extends StatefulWidget {
  const FrontPage({Key? key}) : super(key: key);

  @override
  _FrontPageState createState() => _FrontPageState();
}

class _FrontPageState extends State<FrontPage> {
  List<bool> buttonStates = [false, false, false];

  @override
  void initState() {
    super.initState();
    FastAnalytics.screenOpened("FrontPage");
  }

  void onClickButton(int index) {
    setState(() {
      buttonStates[index] = !buttonStates[index];
    });
    if (buttonStates[index]) {
      Future.delayed(const Duration(milliseconds: 1000), () {
        switch (index) {
          case 0:
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (_) => const TryEndlessPage()));
            break;
          case 1:
            showLicensePage(
              context: context,
              applicationName: 'out lights', // アプリの名前
              applicationVersion: '2.0.2.2', // バージョン
              applicationLegalese: '2022 fastriver_org', // 権利情報
            );
            break;
          case 2:
            openUrl(
                "https://twitter.com/intent/tweet?text=%E3%82%A2%E3%82%A6%5B%E3%83%88%E3%83%A9%5D%E3%82%A4%E3%83%84(2022)%0Afrom%20%40fastriver_org%0Ahttps%3A%2F%2Ftora.fastriver.dev");
            break;
        }
      });
    }
  }

  bool tryClicked = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: DefaultTextStyle.merge(
        style: GoogleFonts.oswald(),
        child: Stack(
          children: [
            Positioned.fill(
              child: Opacity(
                opacity: 0.6,
                child: Image.asset(
                  "image/tiger_bg.jpg",
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const Align(
              alignment: Alignment.bottomLeft,
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  "Photo by Keyur Nandaniya on Unsplash",
                  style: TextStyle(color: Colors.white54),
                ),
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: Column(
                children: [
                  Expanded(
                    flex: 6,
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "アウ[トラ]イツ",
                            style: GoogleFonts.yuseiMagic(
                                color: Colors.white, fontSize: 50),
                            //style: TextStyle(color: Colors.white, fontSize: 50),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 4,
                    child: Column(
                      children: [
                        SizedBox(
                          width: 210,
                          height: 90,
                          child: StrokeButton(
                              value: buttonStates[0],
                              onChanged: (value) => onClickButton(0),
                              offsetForProjection: 10,
                              sideColor: Colors.blueGrey,
                              surfaceColor: ColorTween(
                                  begin: Colors.amber, end: Colors.purple),
                              child: const Center(
                                child: Text(
                                  "Try",
                                  style: TextStyle(fontSize: 30),
                                ),
                              )),
                        ),
                        SizedBox(
                          width: 210,
                          height: 90,
                          child: StrokeButton(
                              value: buttonStates[1],
                              onChanged: (value) => onClickButton(1),
                              offsetForProjection: 10,
                              sideColor: Colors.blueGrey,
                              surfaceColor: ColorTween(
                                  begin: Colors.amber, end: Colors.purple),
                              child: const Center(
                                child: Text(
                                  "Licenses",
                                  style: TextStyle(fontSize: 30),
                                ),
                              )),
                        ),
                        SizedBox(
                          width: 210,
                          height: 90,
                          child: StrokeButton(
                              value: buttonStates[2],
                              onChanged: (value) => onClickButton(2),
                              offsetForProjection: 10,
                              sideColor: Colors.blueGrey,
                              surfaceColor: ColorTween(
                                  begin: Colors.amber, end: Colors.purple),
                              child: const Center(
                                child: Text(
                                  "Share",
                                  style: TextStyle(fontSize: 30),
                                ),
                              )),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
