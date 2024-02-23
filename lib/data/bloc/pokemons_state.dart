import '../models/PokemonDetailModel.dart';

abstract class PokemonsState {
  final List<PokemonDetailModel> pokemons;

  PokemonsState({required this.pokemons});
}

class PokemonsInitialState extends PokemonsState {
  PokemonsInitialState() : super(pokemons: []);
}

class PokemonsLoadingState extends PokemonsState {
  PokemonsLoadingState() : super(pokemons: []);
}

class PokemonsLoadedState extends PokemonsState {
  PokemonsLoadedState({required List<PokemonDetailModel> pokemons})
      : super(pokemons: pokemons);
}

class PokemonsErrorState extends PokemonsState {
  final Exception exception;
  PokemonsErrorState({required this.exception}) : super(pokemons: []);
}
