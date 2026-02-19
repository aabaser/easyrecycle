class City {
  const City({required this.id, required this.name});

  final String id;
  final String name;

  static List<City> defaults(
      {required String berlinName, required String hannoverName}) {
    return [
      City(id: "berlin", name: berlinName),
      City(id: "hannover", name: hannoverName),
    ];
  }
}
