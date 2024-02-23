import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pokedex/data/models/PokemonDetailModel.dart';
import 'package:pokedex/utils/colors_util.dart';

class PokemonPage extends StatefulWidget {
  final PokemonDetailModel pokemon;
  const PokemonPage({super.key, required this.pokemon});

  @override
  State<PokemonPage> createState() => _PokemonPageState();
}

class _PokemonPageState extends State<PokemonPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late Color bgColor;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    bgColor = widget.pokemon.bgColor;
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        title: Text(
          widget.pokemon.name ?? 'Pokemon',
          style: GoogleFonts.goldman(
            shadows: [
              const Shadow(
                offset: Offset(2.0, 2.0),
                blurRadius: 0.5,
                color: Color.fromARGB(255, 0, 0, 0),
              ),
            ],
          ),
        ),
      ),
      body: _body(),
    );
  }

  Widget _body() {
    return Column(
      children: [
        _header(),
        _tabs(),
        _tabsBody(),
      ],
    );
  }

  Widget _header() {
    return Flexible(
      flex: 1,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: ColorsUtil.cinzaEscuro,
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
                    children: [
                      Image.asset('assets/images/pokeball.png', height: 20, width: 20),
                      const SizedBox(width: 20),
                      Text(
                        widget.pokemon.types?.first.type?.name ?? '',
                        style: GoogleFonts.goldman(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 18),
                      ),
                    ],
                  ),
                ).animate(onPlay: (c) => c.repeat()).shimmer(delay: 1000.ms, duration: 2000.ms),
              ],
            ),
            Column(
              children: [
                Image.network(
                  widget.pokemon.sprites?.other?.officialArtwork?.frontDefault ?? '',
                  height: 180,
                  width: 200,
                )
                    .animate(onPlay: (controller) => controller.repeat())
                    .moveY(begin: -10, end: 8, curve: Curves.easeIn, duration: 1000.ms)
                    .then()
                    .moveY(begin: 8, end: -10, curve: Curves.easeOut),
                Container(
                  width: 200,
                  height: 15,
                  decoration: const BoxDecoration(
                      color: Colors.black38, borderRadius: BorderRadius.all(Radius.elliptical(200, 15))),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _tabs() {
    return Container(
      color: ColorsUtil.cinzaEscuro,
      child: TabBar(
        indicator: UnderlineTabIndicator(
          borderSide: BorderSide(color: bgColor, width: 3.0),
        ),
        automaticIndicatorColorAdjustment: true,
        controller: _tabController,
        tabs: <Widget>[
          _tabHeader("Base stats"),
          _tabHeader("Abilities"),
          _tabHeader("Moves"),
        ],
      ),
    );
  }

  Tab _tabHeader(String text) {
    return Tab(
      child: Text(
        text,
        style: GoogleFonts.goldman(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          shadows: [
            Shadow(
              offset: const Offset(1.5, 1.5),
              blurRadius: 0.8,
              color: bgColor,
            ),
          ],
        ),
      ),
    );
  }

  Widget _tabsBody() {
    return Flexible(
      flex: 2,
      child: Container(
        color: ColorsUtil.cinzaEscuro,
        child: TabBarView(
          controller: _tabController,
          children: <Widget>[
            Column(
              children: widget.pokemon.stats!
                  .map((s) => Container(
                        color: Colors.white,
                        padding: const EdgeInsets.all(12),
                        margin: const EdgeInsets.all(4),
                        child: Row(
                          children: [
                            Image.asset('assets/images/arrow.png', width: 20, height: 20)
                                .animate(onPlay: (controller) => controller.repeat())
                                .moveX(begin: -4, end: 2, curve: Curves.decelerate, duration: 500.ms)
                                .then()
                                .moveX(begin: 2, end: -4, curve: Curves.decelerate),
                            const SizedBox(width: 20),
                            Text(
                              '${s.stat!.name} - ${s.baseStat}'.toUpperCase(),
                              style: GoogleFonts.goldman(),
                            ),
                          ],
                        ),
                      ))
                  .toList(),
            ),
            Center(
              child: Column(
                children: widget.pokemon.abilities!
                    .map((a) => Container(
                          color: bgColor,
                          padding: const EdgeInsets.all(8),
                          margin: const EdgeInsets.all(4),
                          child: Row(
                            children: [
                              Image.asset('assets/images/punch.png', width: 20, height: 20)
                                  .animate(onPlay: (controller) => controller.repeat())
                                  .shake(),
                              const SizedBox(width: 20),
                              Text(
                                '${a.ability?.name}',
                                style: GoogleFonts.goldman(fontSize: 20),
                              ),
                            ],
                          ),
                        ))
                    .toList(),
              ),
            ),
            Center(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 8,
                  crossAxisSpacing: 0.2,
                  mainAxisSpacing: 10,
                ),
                itemCount: widget.pokemon.moves?.length ?? 0,
                itemBuilder: (context, index) {
                  var pokemon = widget.pokemon.moves?[index];
                  return ListTile(
                    title: Container(
                      color: bgColor,
                      child: Center(
                        child: Text(
                          '${pokemon!.move!.name}',
                          style: GoogleFonts.goldman(color: ColorsUtil.cinzaEscuro),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
