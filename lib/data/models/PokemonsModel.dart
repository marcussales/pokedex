class PokemonsModel {
    int count;
    String next;
    String previous;
    List<PokemonResumeModel> results;

    PokemonsModel({
        required this.count,
        required this.next,
        required this.previous,
        required this.results,
    });
}

class PokemonResumeModel {
    String name;
    String url;

    PokemonResumeModel({
        required this.name,
        required this.url,
    });

    factory PokemonResumeModel.fromMap(Map<String, dynamic> map) {
    return PokemonResumeModel(
      name: map["name"], 
      url: map["url"] 
    );
  }
}

