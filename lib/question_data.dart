import 'dart:math';

import 'package:flutter/rendering.dart';
import 'package:out_lights/solve_square_equation.dart';
import 'package:out_lights/table_data.dart';

class QuestionData {
  final TableData<int?> table;
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

QuestionData? generateSpecificQuestion(int step) {
  List<RelativeOpData> ops = RelativeOps.square;
  final TableData<int> table;
  if (step == 4) {
    table = StaticTables.four;
  } else if (step == 12) {
    ops = RelativeOps.h;
    table = StaticTables.oneTwo;
  } else if (step == 20) {
    table = StaticTables.twoThousand22;
  } else if (step == 21) {
    table = StaticTables.fastRiver;
  } else {
    return null;
  }
  final lostCells = generateLostTable(table.length, 0);
  final opMatrix = generateOpMatrix(table.length, ops, lostCells);
  final expanded = table.expand((e) => e).map((e) => [e]).toList();
  final solutions = solveSquareEquation(opMatrix, expanded);
  assert(solutions.isNotEmpty);
  return QuestionData(
    table,
    ops,
    solutions.map((e) => e.expand((element) => element).toList()).toList(),
  );
}

QuestionData generateQuestion(int size, int lost) {
  assert(size >= 2);
  final ops = RelativeOps.getRandomly(size < 5 ? 3 : 6);
  final lostCells = generateLostTable(size, lost);
  final opMatrix = generateOpMatrix(size, ops, lostCells);
  while (true) {
    final table = generateTable(size, lostCells);
    if (table.every((r) => r.every((c) => c == 0 || c == null))) continue;
    final expanded = table
        .expand((e) => e)
        .where((e) => e != null)
        .map((e) => [e!])
        .toList();
    final solutions = solveSquareEquation(opMatrix, expanded);
    if (solutions.isNotEmpty) {
      final flattenedSolutions = solutions
          .map((e) => e.expand((element) => element).toList())
          .toList();
      if (lost > 0) {
        for (int i = 0; i < size * size; i++) {
          if (lostCells.index(i)) {
            for (var solution in flattenedSolutions) {
              solution.insert(i, 0);
            }
          }
        }
      }
      return QuestionData(
        table,
        ops,
        flattenedSolutions,
      );
    }
  }
}

TableData<bool> generateLostTable(int size, int quantity) {
  assert(quantity < size * size);
  final random = Random();
  final resSet = <int>{};
  while (resSet.length < quantity) {
    resSet.add(random.nextInt(size * size));
  }
  return TableDataExt.gen(
      size, size, (row, column) => resSet.contains(row * size + column));
}

TableData<int?> generateTable(int size, List<List<bool>> lostTable) {
  return TableDataExt.gen(size, size,
      (row, column) => lostTable[row][column] ? null : Random().nextInt(2));
}

TableData<int> generateOpMatrix(
    int size, List<RelativeOpData> opData, TableData<bool> lostTable) {
  TableData<int> result = [];
  // (targetColumn, targetRow)を押したときの影響を考える
  for (int targetRow = 0; targetRow < size; targetRow++) {
    for (int targetColumn = 0; targetColumn < size; targetColumn++) {
      // 欠損している場合は飛ばす
      if (lostTable.rc(targetRow, targetColumn)) {
        continue;
      }
      // 相対位置を直列位置に変換してひっくり返るマスは1にする
      final targetLine = List.generate(size * size, (index) => 0);
      for (var relativeOp in opData) {
        final x = targetColumn + relativeOp.dx;
        final y = targetRow + relativeOp.dy;
        if (x < 0 || x >= size || y < 0 || y >= size) continue;
        final index = y * size + x;
        targetLine[index] = 1;
      }
      // 欠損している場合を取り除く
      int offset = 0;
      for (int index = 0; index < size * size; index++) {
        if (lostTable.index(index)) {
          targetLine.removeAt(index - offset);
          offset++;
        }
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

class RelativeOps {
  static List<RelativeOpData> getRandomly(int number) {
    switch (Random().nextInt(number)) {
      case 0:
      case 1:
        return square;
      case 2:
        return plus;
      case 3:
        return x;
      case 4:
        return ripple;
      case 5:
        return h;
    }
    return square;
  }

  /// o,o,o
  /// o,c,o
  /// o,o,o
  static const List<RelativeOpData> square = [
    RelativeOpData(-1, -1),
    RelativeOpData(0, -1),
    RelativeOpData(1, -1),
    RelativeOpData(-1, 0),
    RelativeOpData(0, 0),
    RelativeOpData(1, 0),
    RelativeOpData(-1, 1),
    RelativeOpData(0, 1),
    RelativeOpData(1, 1),
  ];

  ///  ,o,
  /// o,c,o
  ///  ,o,
  static const List<RelativeOpData> plus = [
    RelativeOpData(0, -1),
    RelativeOpData(-1, 0),
    RelativeOpData(0, 0),
    RelativeOpData(1, 0),
    RelativeOpData(0, 1),
  ];

  /// o, ,o
  ///  ,c,
  /// o, ,o
  static const List<RelativeOpData> x = [
    RelativeOpData(-1, -1),
    RelativeOpData(1, -1),
    RelativeOpData(0, 0),
    RelativeOpData(-1, 1),
    RelativeOpData(1, 1),
  ];

  /// o,o,o,o,o
  /// o, , , ,o
  /// o, ,c, ,o
  /// o, , , ,o
  /// o,o,o,o,o
  static const List<RelativeOpData> ripple = [
    RelativeOpData(-2, -2),
    RelativeOpData(-2, -1),
    RelativeOpData(-2, 0),
    RelativeOpData(-2, 1),
    RelativeOpData(-2, 2),
    RelativeOpData(-1, 2),
    RelativeOpData(0, 2),
    RelativeOpData(1, 2),
    RelativeOpData(2, 2),
    RelativeOpData(2, 1),
    RelativeOpData(2, 0),
    RelativeOpData(2, -1),
    RelativeOpData(2, -2),
    RelativeOpData(1, -2),
    RelativeOpData(0, -2),
    RelativeOpData(-1, -2),
    RelativeOpData(0, 0)
  ];

  /// o, ,o
  /// o,c,o
  /// o, ,o
  static const List<RelativeOpData> h = [
    RelativeOpData(-1, -1),
    RelativeOpData(1, -1),
    RelativeOpData(-1, 0),
    RelativeOpData(0, 0),
    RelativeOpData(1, 0),
    RelativeOpData(-1, 1),
    RelativeOpData(1, 1),
  ];
}

class StaticTables {
  static const TableData<int> four = [
    [0, 1, 0],
    [0, 0, 0],
    [1, 1, 0],
  ];

  static const TableData<int> oneTwo = [
    [0, 1, 0, 0, 0],
    [0, 1, 1, 1, 0],
    [0, 1, 1, 0, 1],
    [0, 1, 0, 1, 1],
    [0, 1, 0, 0, 0],
  ];

  static const TableData<int> twoThousand22 = [
    [1, 0, 0, 0, 1, 0, 0, 0, 1],
    [1, 1, 1, 0, 1, 0, 1, 0, 1],
    [1, 0, 0, 0, 1, 0, 1, 0, 1],
    [1, 0, 1, 1, 1, 0, 1, 0, 1],
    [1, 0, 0, 0, 1, 0, 0, 0, 1],
    [1, 1, 1, 0, 1, 1, 1, 0, 1],
    [1, 0, 0, 0, 1, 0, 0, 0, 1],
    [1, 0, 1, 1, 1, 0, 1, 1, 1],
    [1, 0, 0, 0, 1, 0, 0, 0, 1],
  ];

  static const TableData<int> fastRiver = [
    [0, 0, 0, 0, 1, 1, 0, 0, 1],
    [0, 0, 0, 0, 1, 0, 0, 0, 0],
    [0, 0, 0, 0, 1, 0, 0, 0, 0],
    [0, 0, 0, 0, 1, 1, 0, 0, 1],
    [1, 1, 1, 1, 1, 1, 1, 1, 1],
    [0, 0, 0, 0, 1, 0, 1, 1, 1],
    [0, 0, 0, 0, 1, 0, 0, 1, 1],
    [0, 0, 0, 0, 1, 0, 0, 0, 1],
    [0, 0, 0, 0, 1, 0, 0, 0, 0],
  ];
}
