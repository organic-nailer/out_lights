import 'dart:math';

import 'package:out_lights/solve_square_equation.dart';

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
    RelativeOpData(-1, -1),
    RelativeOpData(0, -1),
    RelativeOpData(1, -1),
    RelativeOpData(-1, 0),
    RelativeOpData(0, 0),
    RelativeOpData(1, 0),
    RelativeOpData(-1, 1),
    RelativeOpData(0, 1),
    RelativeOpData(1, 1),
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
    if (table.every((r) => r.every((c) => c == 0))) continue;
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
