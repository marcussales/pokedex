import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pokedex/data/bloc/pokemons_bloc.dart';
import 'package:pokedex/data/bloc/pokemons_event.dart';
import 'package:pokedex/data/bloc/pokemons_state.dart';
import 'package:pokedex/pages/pokemon_page.dart';
import 'package:pokedex/utils/colors_util.dart';

import '../data/models/PokemonDetailModel.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  late PokemonBloc _pokemonBloc;
  final ValueNotifier<String> _searchText = ValueNotifier('');
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    _pokemonBloc = PokemonBloc();
    _pokemonBloc.add(GetPokemons());
    _textController.addListener(_handleTextChanged);
    _scrollController.addListener(() {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
        _pokemonBloc.add(GetPokemons());
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.asset('assets/images/header.png')
            .animate(onPlay: (c) => c.repeat())
            .shimmer(delay: 1000.ms, duration: 2000.ms),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      backgroundColor: ColorsUtil.cinzaEscuro,
      body: _body(),
    );
  }

  Widget _body() {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          _searchBar(),
          _results(),
        ],
      ),
    );
  }

  Widget _searchBar() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 16, horizontal: 10),
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      decoration: BoxDecoration(
        color: ColorsUtil.preto,
        boxShadow: const [
          BoxShadow(
            color: Colors.white,
            spreadRadius: 2,
            blurRadius: 0,
            offset: Offset(2, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: TextFormField(
              controller: _textController,
              cursorColor: Colors.white,
              style: GoogleFonts.goldman(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Busque pelo pokemon',
                hintStyle: GoogleFonts.goldman(color: Colors.white),
                focusedBorder: InputBorder.none,
              ),
            ),
          ),
          InkWell(
            onTap: () {
              _pokemonBloc.add(GetPokemon(pokemon: _textController.text));
            },
            child: Stack(children: [
              Row(
                children: [
                  ValueListenableBuilder(
                      valueListenable: _searchText,
                      builder: (context, text, _) => _searchText.value.isNotEmpty
                          ? InkWell(
                              onTap: () {
                                setState(() {
                                  _textController.clear();
                                });
                                _pokemonBloc.add(GetPokemons());
                              },
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  color: ColorsUtil.cinzaEscuro,
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Colors.white,
                                      spreadRadius: 2,
                                      blurRadius: 0,
                                      offset: Offset(2, 2),
                                    ),
                                  ],
                                ),
                                child: const Icon(Icons.backspace, color: Colors.white),
                              ),
                            ).animate().fadeIn(delay: 300.ms, duration: 400.ms)
                          : const SizedBox.shrink()),
                  const SizedBox(width: 8),
                  Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: ColorsUtil.amarelo,
                        boxShadow: [
                          BoxShadow(
                            color: ColorsUtil.ocre,
                            spreadRadius: 2,
                            blurRadius: 0,
                            offset: const Offset(2, 2),
                          ),
                        ],
                      ),
                      child: Icon(Icons.search, color: ColorsUtil.azul)),
                ],
              ),
            ]),
          ),
        ],
      ),
    );
  }

  Widget _results() {
    return BlocBuilder<PokemonBloc, PokemonsState>(
        bloc: _pokemonBloc,
        builder: (context, state) {
          if (state is PokemonsLoadingState) {
            return Center(
                child: Image.asset(
              'assets/images/pokeball-loading.png',
              height: 60,
              width: 60,
            )
                    .animate(onPlay: (c) => c.repeat())
                    .moveX(begin: -20, end: 10, curve: Curves.decelerate, duration: 500.ms)
                    .then()
                    .moveX(begin: 10, end: -20, curve: Curves.decelerate));
          } else if (state is PokemonsLoadedState) {
            return GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.only(top: 20, left: 15, right: 15),
              mainAxisSpacing: 15,
              crossAxisSpacing: 10,
              crossAxisCount: 2,
              children: state.pokemons.map((pokemon) => _pokemonCard(pokemon)).toList(),
            );
          } else {
            return Center(
              child: Column(
                children: [
                  Image.asset(
                    'assets/images/not-found.png',
                    height: 150,
                    width: 120,
                  ),
                  Text('Não encontramos esse \npokemon',
                      textAlign: TextAlign.center, style: GoogleFonts.goldman(color: Colors.white, fontSize: 22))
                ],
              ),
            );
          }
        });
  }

  Widget _pokemonCard(PokemonDetailModel pokemon) {
    var bgColor = pokemon.bgColor;
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => PokemonPage(pokemon: pokemon)));
      },
      child: Stack(
        children: [
          Container(
            decoration: ShapeDecoration(
              color: bgColor,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
              shadows: [
                BoxShadow(
                  color: bgColor.withOpacity(0.4),
                  blurRadius: 4,
                  offset: const Offset(6, 4),
                  spreadRadius: 0,
                )
              ],
            ),
            width: 160,
            height: 140,
            padding: const EdgeInsets.all(8),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  pokemon.name?.toUpperCase() ?? '',
                  style: GoogleFonts.goldman(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 14),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  color: Colors.white,
                  child: Text(pokemon.types?.first.type?.name ?? '',
                      style: GoogleFonts.goldman(fontWeight: FontWeight.bold, color: bgColor)),
                )
              ],
            ),
          ),
          Positioned(
              left: 90,
              top: 40,
              child: Image.network(
                pokemon.sprites?.other?.officialArtwork?.frontDefault ?? '',
                height: 95,
                width: 90,
              ))
        ],
      ),
    );
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  _handleTextChanged() {
    _searchText.value = _textController.text;
  }
}
