import 'dart:math';

import 'package:expanded_grid/expanded_grid.dart';
import 'package:flutter/material.dart';
import 'package:out_lights/front_page.dart';
import 'package:out_lights/solve_square_equation.dart';
import 'package:out_lights/stroke_button.dart';
import 'package:scidart/numdart.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const FrontPage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<List<bool>> buttonState = [];
  QuestionData? question;

  @override
  void initState() {
    setNewTable();
    super.initState();
  }

  void setNewTable() {
    question = generateQuestion(10);
    buttonState = [];
    for (var row in question!.table) {
      buttonState.add(row.map((e) => e == 1).toList());
    }
  }

  @override
  Widget build(BuildContext context) {
    final solution = question!.getBestSolution();
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.refresh),
        onPressed: () {
          setState(() {
            setNewTable();
          });
        },
      ),
      body: Center(
        child: AspectRatio(
            aspectRatio: 1,
            child: ExpandedGrid(
              column: buttonState.length,
              row: buttonState.length,
              children: List.generate(
                  buttonState.length * buttonState.length,
                  (index) => ExpandedGridContent(
                        columnIndex: index % buttonState.length,
                        rowIndex: (index / buttonState.length).floor(),
                        child: StrokeButton(
                          value:
                              buttonState[(index / buttonState.length).floor()]
                                  [index % buttonState.length],
                          onChanged: (value) {
                            setState(() {
                              for (var op in question!.ops) {
                                final x = index % buttonState.length + op.dx;
                                final y = (index / buttonState.length).floor() +
                                    op.dy;
                                if (x < 0 ||
                                    x >= buttonState.length ||
                                    y < 0 ||
                                    y >= buttonState.length) continue;
                                buttonState[y][x] = !buttonState[y][x];
                              }
                            });
                          },
                          child: Center(
                            child: Text(solution[index] == 1 ? "押す" : "押さない"),
                          ),
                          surfaceColor: ColorTween(
                              begin: Colors.yellow, end: Colors.brown),
                        ),
                      )),
            )),
      ),
    );
  }
}

class QuestionData {
  final List<List<int>> table;
  final List<RelativeOpData> ops;
  final List<List<int>> solutions;
  QuestionData(this.table, this.ops, this.solutions);

  bool sorted = false;

  List<int> getBestSolution() {
    if (solutions.length == 1 || sorted) return solutions[0];
    solutions.sort((a, b) =>
        a.where((e) => e == 1).length - a.where((e) => e == 1).length);
    sorted = true;
    return solutions[0];
  }
}

QuestionData generateQuestion(int size) {
  assert(size >= 2);
  const ops = [
    RelativeOpData(0, 0),
    // RelativeOpData(-2, -2),
    // RelativeOpData(-2, -1),
    // RelativeOpData(-2, 0),
    // RelativeOpData(-2, 1),
    // RelativeOpData(-2, 2),
    // RelativeOpData(-1, 2),
    // RelativeOpData(0, 2),
    // RelativeOpData(1, 2),
    // RelativeOpData(2, 2),
    // RelativeOpData(2, 1),
    // RelativeOpData(2, 0),
    // RelativeOpData(2, -1),
    // RelativeOpData(2, -2),
    // RelativeOpData(1, -2),
    // RelativeOpData(0, -2),
    // RelativeOpData(-1, -2),
    // RelativeOpData(0, 0)
  ];
  final opMatrix = generateOpMatrix(size, ops);
  while (true) {
    final table = generateTable(size);
    final expanded = table.expand((e) => e).map((e) => [e]).toList();
    final solutions = solveSquareEquation(opMatrix, expanded);
    if (solutions.isNotEmpty) {
      return QuestionData(
          table,
          ops,
          solutions
              .map((e) => e.expand((element) => element).toList())
              .toList());
    }
  }
}

List<List<int>> generateTable(int size) {
  return List.generate(
      size, (index) => List.generate(size, (index) => Random().nextInt(2)));
}

List<int>? getAnswer(Array2d table) {
  final flattened = Array(table.expand((e) => e).toList());
  final inv = matrixInverse(table);
}

List<List<int>> generateOpMatrix(int size, List<RelativeOpData> opData) {
  List<List<int>> result = [];
  // (targetColumn, targetRow)を押したときの影響を考える
  for (int targetRow = 0; targetRow < size; targetRow++) {
    for (int targetColumn = 0; targetColumn < size; targetColumn++) {
      // 相対位置を直列位置に変換してひっくり返るマスは1にする
      final targetLine = List.generate(size * size, (index) => 0);
      for (var relativeOp in opData) {
        final x = targetColumn + relativeOp.dx;
        final y = targetRow + relativeOp.dy;
        if (x < 0 || x >= size || y < 0 || y >= size) continue;
        final index = y * size + x;
        targetLine[index] = 1;
      }
      result.add(targetLine);
    }
  }
  return result;
}

class RelativeOpData {
  final int dx, dy;
  const RelativeOpData(this.dx, this.dy);
}
