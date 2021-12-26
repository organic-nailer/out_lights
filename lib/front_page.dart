import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:out_lights/stroke_button.dart';
import 'package:out_lights/try_endress_page.dart';

class FrontPage extends StatefulWidget {
  const FrontPage({Key? key}) : super(key: key);

  @override
  _FrontPageState createState() => _FrontPageState();
}

class _FrontPageState extends State<FrontPage> {
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
                              value: tryClicked,
                              onChanged: (value) async {
                                setState(() {
                                  tryClicked = value;
                                });
                                Future.delayed(
                                    const Duration(milliseconds: 500), () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (_) => const TryEndressPage()));
                                });
                              },
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
