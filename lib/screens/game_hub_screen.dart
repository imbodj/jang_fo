import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import 'para_tir_screen.dart';
import 'bon_compte_screen.dart';
import 'le_bon_mot_screen.dart';
import 'mots_mysteres_screen.dart';

class _GameEntry {
  final String title;
  final String subtitle;
  final String imagePath;
  final List<Color> colors;
  final WidgetBuilder builder;

  const _GameEntry({
    required this.title,
    required this.subtitle,
    required this.imagePath,
    required this.colors,
    required this.builder,
  });
}

class GameHubScreen extends StatelessWidget {
  const GameHubScreen({super.key});

  static final List<_GameEntry> _games = [
    _GameEntry(
      title: 'Para Tir',
      subtitle: 'Sky Defense Kids',
      imagePath: 'assets/images/para_tir.png',
      colors: const [Color(0xFF00C6FF), Color(0xFF0072FF)],
      builder: (_) => const ParaTirMainMenuScreen(),
    ),
    _GameEntry(
      title: 'BonCompte',
      subtitle: 'Défie ton calcul mental',
      imagePath: 'assets/images/bon_compte.png',
      colors: const [Color(0xFF00B4DB), Color(0xFF0083B0)],
      builder: (_) => const BonCompteHomeScreen(),
    ),
    _GameEntry(
      title: 'Le Bon Mot',
      subtitle: 'Méli-mélo de lettres',
      imagePath: 'assets/images/le_bon_mot.png',
      colors: const [Color(0xFFFF512F), Color(0xFFDD2476)],
      builder: (_) => const LeBonMotScreen(),
    ),
    _GameEntry(
      title: 'Mots Mystères',
      subtitle: 'Devine le mot caché',
      imagePath: 'assets/images/mots_mysteres.png',
      colors: const [Color(0xFF11998E), Color(0xFF38EF7D)],
      builder: (_) => const MotsMysteresScreen(),
    ),
  ];

  void _afficherAPropos(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF16213E),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
            side: const BorderSide(color: Colors.amberAccent, width: 2),
          ),
          title: const Row(
            children: [
              Icon(Icons.info_outline_rounded, color: Colors.amberAccent),
              SizedBox(width: 10),
              Text(
                'À propos',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Jàng&Fo',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                  color: Colors.amberAccent,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'Version 1.1.0',
                style: TextStyle(color: Colors.white54, fontSize: 13),
              ),
              const SizedBox(height: 16),
              Text(
                'Jàng&Fo est une suite de jeux éducatifs conçue pour stimuler le calcul mental, le vocabulaire et la réflexion des enfants tout en s\'amusant.',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.87),
                  fontSize: 14,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Développé avec ❤️ pour l\'éveil des jeunes esprits.',
                style: TextStyle(
                  color: Colors.white60,
                  fontSize: 12,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                'FERMER',
                style: TextStyle(color: Colors.amberAccent, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF1A1A2E), Color(0xFF16213E)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const SizedBox(width: 48),
                    const Icon(Icons.sports_esports_rounded, color: Colors.amberAccent, size: 40),
                    IconButton(
                      icon: const Icon(Icons.info_outline_rounded, color: Colors.white70, size: 28),
                      onPressed: () => _afficherAPropos(context),
                      tooltip: 'À propos',
                    ),
                  ],
                ),
              ),
              const Text(
                'JÀNG&FO',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                  letterSpacing: 3,
                ),
              ),
              const Text(
                'Choisis un jeu pour commencer',
                style: TextStyle(color: Colors.white54, fontSize: 14),
              ),
              const SizedBox(height: 25),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: _games.length,
                  itemBuilder: (context, index) {
                    final game = _games[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 18),
                      child: _GameCard(game: game),
                    ).animate().fadeIn(
                          delay: (index * 120).ms,
                          duration: 400.ms,
                        ).slideY(begin: 0.1, end: 0);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _GameCard extends StatelessWidget {
  const _GameCard({required this.game});
  final _GameEntry game;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(24),
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: game.builder),
          );
        },
        child: Container(
          height: 110,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: game.colors,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: game.colors.last.withValues(alpha: 0.4),
                blurRadius: 16,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 65,
                height: 65,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.25),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.asset(
                    game.imagePath,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(Icons.sports_esports,
                          color: Colors.white, size: 32);
                    },
                  ),
                ),
              ),
              const SizedBox(width: 18),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      game.title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      game.subtitle,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.85),
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios_rounded,
                  color: Colors.white70, size: 18),
            ],
          ),
        ),
      ),
    );
  }
}