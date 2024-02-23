abstract class PokemonEvent {}

class GetPokemons extends PokemonEvent {}

class GetPokemon extends PokemonEvent {
  final String pokemon;

  GetPokemon({required this.pokemon});
}
