abstract class Mapper<I, O> {
  O map(I input);

  List<O> mapList(List<I> inputs) {
    final List<O> results = [];

    for (var element in inputs) {
      results.add(map(element));
    }
    return results;
  }
}
