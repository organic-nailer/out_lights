import 'dart:math';

/// Ax = b を解く
/// Aは正方行列
List<List<List<int>>> solveSquareEquation(
    List<List<int>> inputA, List<List<int>> inputB) {
  assert(inputA.length == inputB.length);
  assert(inputA.length == inputA[0].length);
  final inputAB = _concatHorizontal(inputA, inputB);
  List<int> swappedColumn = [];
  final rank = _triangulate(inputAB, swappedColumn);
  if (rank == inputAB.length) {
    print("正則");
    for (int column = rank - 1; column >= 1; column--) {
      for (int row = column - 1; row >= 0; row--) {
        if (inputAB[row][column] == 1) {
          _addRow(inputAB, row, column);
        }
      }
    }
    final List<List<int>> x = [];
    for (int i = 0; i < rank; i++) {
      x.add([inputAB[i][rank]]);
    }
    return [x];
  }
  bool isNoSolution = false;
  for (int i = rank; i < inputAB.length; i++) {
    if (inputAB[i][inputAB[0].length - 1] != 0) {
      isNoSolution = true;
      break;
    }
  }
  if (isNoSolution) {
    print("解なし");
    return [];
  }

  // 左上rank*rankの部分は単位行列にする
  for (int column = rank - 1; column >= 1; column--) {
    for (int row = column - 1; row >= 0; row--) {
      if (inputAB[row][column] == 1) {
        _addRow(inputAB, row, column);
      }
    }
  }
  //print("swap: $swappedColumn");
  // 答えの行列を作る
  final result = List.generate(inputA.length,
      (index) => List.generate(inputAB[0].length - rank, (i) => 0));
  for (int row = 0; row < rank; row++) {
    result[row][0] = inputAB[row].last;
    for (int column = 0; column < inputAB[0].length - rank - 1; column++) {
      result[row][column + 1] = inputAB[row][column + rank];
    }
  }
  for (int row = 0; row < inputA.length - rank; row++) {
    result[rank + row][1 + row] = 1;
  }
  for (var column in swappedColumn.reversed) {
    _swapRowFromTail(result, column);
  }
  //print("不定解");
  //print("answer: $result");
  final List<List<List<int>>> answers = [];
  for (int i = 0; i < pow(2, result[0].length - 1); i++) {
    final List<List<int>> partAns = [];
    for (int j = 0; j < result.length; j++) {
      int c = result[j][0];
      for (int k = 1; k < result[0].length; k++) {
        if (1 & (i >> (k - 1)) != 0) {
          c = (c + result[j][k]) % 2;
        }
      }
      partAns.add([c]);
    }
    answers.add(partAns);
  }
  //print("answers: $answers");
  return answers;
}

/// 上三角行列を作る
/// 入力は inputAB のみ
int _triangulate(List<List<int>> input, List<int> swappedColumn) {
  // 上三角行列を作る
  // rankの数だけ計算すればよい(それより下は0になるはず)
  for (int column = 0; column < input.length; column++) {
    int firstRaw = -1;
    // 最初に1がある行を探す
    for (int i = column; i < input.length; i++) {
      if (firstRaw < 0 && input[i][column] == 1) {
        firstRaw = i;
        continue;
      }
      if (firstRaw >= 0 && input[i][column] == 1) {
        _addRow(input, i, firstRaw);
      }
    }
    // 1を残した行を正しい位置に移動
    if (firstRaw >= 1) {
      _swapRow(input, column, firstRaw);
    }
    // 全て0の場合は列を入れ替えて再計算
    // 入れ替え先も全て0なら計算は終了している
    else if (firstRaw < 0) {
      bool remainFlag = false;
      for (int r = column; r < input.length; r++) {
        for (int c = column + 1; c < input[0].length - 1; c++) {
          if (input[r][c] != 0) {
            remainFlag = true;
            break;
          }
        }
        if (remainFlag) {
          break;
        }
      }
      if (!remainFlag) {
        // 正則でない
        return column;
      }
      _swapColumnToTail(input, column);
      swappedColumn.add(column);
      column--;
    }
  }
  return input.length;
}

/// row1とrow2を入れ替える
void _swapRow(List<List<int>> input, int row1, int row2) {
  final tmp = input[row1];
  input[row1] = input[row2];
  input[row2] = tmp;
}

/// augendにaddendを足す
void _addRow(List<List<int>> input, int augend, int addend) {
  for (int i = 0; i < input[0].length; i++) {
    input[augend][i] = (input[augend][i] + input[addend][i]) % 2;
  }
}

void _swapColumnToTail(List<List<int>> input, int col) {
  for (int i = 0; i < input.length; i++) {
    final tmp = input[i].removeAt(col);
    input[i].insert(input[i].length - 1, tmp);
  }
}

void _swapRowFromTail(List<List<int>> input, int row) {
  final tmp = input.removeLast();
  input.insert(row, tmp);
}

List<List<int>> _dot(List<List<int>> a, List<List<int>> b) {
  final result =
      List.generate(a.length, (index) => List.generate(b[0].length, (i) => 0));
  for (int row = 0; row < a.length; row++) {
    for (int column = 0; column < b[0].length; column++) {
      for (int i = 0; i < a[0].length; i++) {
        result[row][column] =
            (result[row][column] + a[row][i] * b[i][column]) % 2;
      }
    }
  }
  return result;
}

List<List<int>> _concatHorizontal(List<List<int>> left, List<List<int>> right) {
  assert(left.length == right.length);
  final List<List<int>> result = [];
  for (int i = 0; i < left.length; i++) {
    result.add([...left[i], ...right[i]]);
  }
  return result;
}
