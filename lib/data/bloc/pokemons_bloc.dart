import 'package:bloc/bloc.dart';
import 'package:pokedex/data/bloc/pokemons_event.dart';
import 'package:pokedex/data/bloc/pokemons_state.dart';
import 'package:pokedex/data/http/http_client.dart';
import 'package:pokedex/data/models/PokemonDetailModel.dart';
import 'package:pokedex/repository/pokemon_repository.dart';

class PokemonBloc extends Bloc<PokemonEvent, PokemonsState> {
  final _repository = PokemonsRepository(client: HttpClient());

  PokemonBloc() : super(PokemonsInitialState()) {
    on(mapEventToState);
  }

  void mapEventToState(PokemonEvent event, Emitter emit) async {
    List<PokemonDetailModel> pokemons = [];

    emit(PokemonsLoadingState());

    if (event is GetPokemons) {
        pokemons = await _repository.getPokemons();
    } else if (event is GetPokemon) {
      final pokemon = await _repository.getPokemon(event.pokemon);
      if(pokemon != null) {
        pokemons.add(pokemon);
      }
    }
    
    emit(PokemonsLoadedState(pokemons: pokemons));

    if(pokemons.isEmpty) {
      emit(PokemonsErrorState(exception: Exception('Não foi possivel recuperar os pokemons')));
      return;
    }
  }

}