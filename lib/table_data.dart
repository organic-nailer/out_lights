typedef TableData<T> = List<List<T>>;

extension TableDataExt<T> on TableData<T> {
  T rc(int row, int column) => this[row][column];

  T index(int index) => this[(index / length).floor()][index % length];

  static TableData<E> gen<E>(
      int rowSize, int columnSize, E Function(int row, int column) generator) {
    return List.generate(
        rowSize, (r) => List.generate(columnSize, (c) => generator(r, c)));
  }
}
