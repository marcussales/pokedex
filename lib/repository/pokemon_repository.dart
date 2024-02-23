import 'dart:convert';

import '../data/http/http_client.dart';
import '../data/models/PokemonDetailModel.dart';

abstract class IPokemonsRepository {
  Future<List<PokemonDetailModel>> getPokemons();
}

class PokemonsRepository implements IPokemonsRepository {
  final IHttpClient client;

  PokemonsRepository({required this.client});

  @override
  Future<List<PokemonDetailModel>> getPokemons() async {
    final response = await client.get(url: 'https://pokeapi.co/api/v2/pokemon?limit=50');
    if (response.statusCode == 200) {
      final List<PokemonDetailModel> pokemons = [];
      var body = jsonDecode(response.body);
      await Future.forEach(body['results'], (item) async {
        var pokemon = await getPokemonDetails(item);
        pokemons.add(pokemon);
      });
      return pokemons;
    } else if (response.statusCode == 404) {
      throw Exception('Não foi possivel recuperar os pokemons');
    } else {
      throw Exception('Não foi possivel recuperar os pokemons');
    }
  }

  Future<PokemonDetailModel?> getPokemon(String pokemon) async {
    final response = await client.get(url: 'https://pokeapi.co/api/v2/pokemon/$pokemon');
    final bool success = response.body.toString().toLowerCase() != 'not found';
    if (success) {
      var pokemonBody = json.decode(response.body);
      final PokemonDetailModel pokemon = PokemonDetailModel.fromJson(pokemonBody);
      return pokemon;
    } else {
      return null;
    }
  }

  Future<PokemonDetailModel> getPokemonDetails(dynamic item) async {
    var pokemonData = await client.get(url: item['url']);
    var pokemonBody = json.decode(pokemonData.body);
    final PokemonDetailModel pokemon = PokemonDetailModel.fromJson(pokemonBody);
    return pokemon;
  }
}
