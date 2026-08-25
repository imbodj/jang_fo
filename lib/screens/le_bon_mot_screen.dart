import 'dart:math';
import 'package:flutter/material.dart';
import '../services/dictionary_db.dart';

class LeBonMotScreen extends StatefulWidget {
  const LeBonMotScreen({super.key});

  @override
  State<LeBonMotScreen> createState() => _LeBonMotScreenState();
}

class _LeBonMotScreenState extends State<LeBonMotScreen> {
  final List<String> voyelles = ['A', 'E', 'I', 'O', 'U', 'Y'];
  final List<String> consonnes = [
    'B', 'C', 'D', 'F', 'G', 'H', 'J', 'L', 'M',
    'N', 'P', 'R', 'S', 'T', 'V'
  ];

  List<String> tirage = [];
  List<bool> lettreUtilisee = [];
  List<int> indicesSelectionnes = [];

  int score = 0;
  bool isChecking = false;
  String messageValidation = '';
  Color colorMessage = Colors.amberAccent;

  @override
  void initState() {
    super.initState();
    _nouveauTirage();
  }

Future<void> _nouveauTirage() async {
    final random = Random();
    List<String> nouveauTirage = [];
    bool tirageValide = false;

    // Boucle de sécurité : génère un tirage jusqu'à en trouver un avec au moins 1 mot possible
    while (!tirageValide) {
      nouveauTirage.clear();

      // Tirage de 3 voyelles et 4 consonnes
      for (int i = 0; i < 3; i++) {
        nouveauTirage.add(voyelles[random.nextInt(voyelles.length)]);
      }
      for (int i = 0; i < 4; i++) {
        nouveauTirage.add(consonnes[random.nextInt(consonnes.length)]);
      }

      nouveauTirage.shuffle();

      // Vérification SQLite
      tirageValide = await DictionaryDB.hasValidWord(nouveauTirage);
    }

    if (!mounted) return;

    setState(() {
      tirage = nouveauTirage;
      lettreUtilisee = List.generate(7, (_) => false);
      indicesSelectionnes.clear();
      messageValidation = '';
    });
  }

  void _ajouterLettre(int index) {
    if (lettreUtilisee[index]) return;
    setState(() {
      lettreUtilisee[index] = true;
      indicesSelectionnes.add(index);
      messageValidation = '';
    });
  }

  void _retirerLettre(int positionDansMot) {
    setState(() {
      int indexOrigine = indicesSelectionnes[positionDansMot];
      lettreUtilisee[indexOrigine] = false;
      indicesSelectionnes.removeAt(positionDansMot);
      messageValidation = '';
    });
  }

  void _effacerTout() {
    setState(() {
      lettreUtilisee = List.generate(7, (_) => false);
      indicesSelectionnes.clear();
      messageValidation = '';
    });
  }

  Future<void> _validerMot() async {
    if (isChecking) return;

    String motForme = indicesSelectionnes.map((i) => tirage[i]).join();

    if (motForme.length < 2) {
      setState(() {
        messageValidation = 'Le mot doit faire au moins 2 lettres !';
        colorMessage = Colors.orangeAccent;
      });
      return;
    }

    setState(() => isChecking = true);

    bool isValid = await DictionaryDB.isWordValid(motForme);
    List<String> meillleursMots = await DictionaryDB.getBestWordsForTirage(tirage);

    if (!mounted) return;

    setState(() => isChecking = false);

    if (isValid) {
      int pointsGagnes = motForme.length * 10;
      score += pointsGagnes;
      _afficherResultatManche(
        titre: 'BRAVO ! 🎉',
        messageScore: 'Tu gagnes +$pointsGagnes Pts avec "$motForme"',
        meillleursMots: meillleursMots,
        couleurTitre: Colors.greenAccent,
      );
    } else {
      _afficherResultatManche(
        titre: 'MOT INCONNU 😅',
        messageScore: 'Ce mot n\'existe pas dans le dictionnaire.',
        meillleursMots: meillleursMots,
        couleurTitre: Colors.orangeAccent,
      );
    }
  }

  void _afficherResultatManche({
    required String titre,
    required String messageScore,
    required List<String> meillleursMots,
    required Color couleurTitre,
  }) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF2D085C),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Text(
            titre,
            textAlign: TextAlign.center,
            style: TextStyle(color: couleurTitre, fontWeight: FontWeight.bold),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                messageScore,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white, fontSize: 16),
              ),
              const SizedBox(height: 20),
              const Text(
                'Les plus longs mots possibles :',
                style: TextStyle(color: Colors.white70, fontSize: 14),
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                alignment: WrapAlignment.center,
                children: meillleursMots.map((m) {
                  return Chip(
                    backgroundColor: Colors.amberAccent,
                    label: Text(
                      '$m (${m.length} let.)',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
          actions: [
            Center(
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                  _nouveauTirage();
                },
                icon: const Icon(Icons.arrow_forward_rounded),
                label: const Text('TIRAGE SUIVANT'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.greenAccent,
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),
            )
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
            colors: [Color(0xFF2D085C), Color(0xFF6B11B0)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_rounded,
                          color: Colors.white, size: 28),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const Text(
                      'LE BON MOT',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w900,
                        color: Colors.amberAccent,
                        letterSpacing: 2,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.black38,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.amberAccent, width: 2),
                      ),
                      child: Text(
                        '⭐ $score',
                        style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Compose le mot le plus long :',
                        style: TextStyle(color: Colors.white70, fontSize: 16),
                      ),
                      const SizedBox(height: 20),
                      Container(
                        constraints: const BoxConstraints(minHeight: 80),
                        margin: const EdgeInsets.symmetric(horizontal: 20),
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.black26,
                          borderRadius: BorderRadius.circular(25),
                          border:
                              Border.all(color: Colors.purpleAccent, width: 2),
                        ),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(
                                indicesSelectionnes.length, (index) {
                              int origIndex = indicesSelectionnes[index];
                              return GestureDetector(
                                onTap: () => _retirerLettre(index),
                                child: _buildCubeLettre(
                                  tirage[origIndex],
                                  isSelected: true,
                                  color: Colors.amberAccent,
                                ),
                              );
                            }),
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),
                      Text(
                        messageValidation,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: colorMessage,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                decoration: const BoxDecoration(
                  color: Color(0xFF1E053D),
                  borderRadius:
                      BorderRadius.vertical(top: Radius.circular(30)),
                ),
                child: Column(
                  children: [
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(tirage.length, (index) {
                          bool utilisee = lettreUtilisee[index];
                          return GestureDetector(
                            onTap: () => _ajouterLettre(index),
                            child: Opacity(
                              opacity: utilisee ? 0.3 : 1.0,
                              child: _buildCubeLettre(
                                tirage[index],
                                isSelected: false,
                                color: _getCubeColor(index),
                              ),
                            ),
                          );
                        }),
                      ),
                    ),
                    const SizedBox(height: 25),
                    Wrap(
                      alignment: WrapAlignment.center,
                      spacing: 8,
                      runSpacing: 10,
                      children: [
                        ElevatedButton.icon(
                          onPressed: _effacerTout,
                          icon: const Icon(Icons.refresh,
                              color: Colors.white, size: 18),
                          label: const Text('EFFACER',
                              style: TextStyle(fontSize: 12)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.redAccent,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 10),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16)),
                          ),
                        ),
                        ElevatedButton.icon(
                          onPressed: _nouveauTirage,
                          icon: const Icon(Icons.shuffle,
                              color: Colors.black, size: 18),
                          label: const Text('CHANGER',
                              style: TextStyle(fontSize: 12)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.cyanAccent,
                            foregroundColor: Colors.black,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 10),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16)),
                          ),
                        ),
                        ElevatedButton.icon(
                          onPressed: _validerMot,
                          icon: isChecking
                              ? const SizedBox(
                                  width: 18,
                                  height: 18,
                                  child: CircularProgressIndicator(
                                      strokeWidth: 2, color: Colors.black),
                                )
                              : const Icon(Icons.check_circle,
                                  color: Colors.black, size: 18),
                          label: const Text('VALIDER',
                              style: TextStyle(fontSize: 12)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.greenAccent,
                            foregroundColor: Colors.black,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 10),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16)),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCubeLettre(String lettre,
      {required bool isSelected, required Color color}) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      width: 45,
      height: 50,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.4),
            offset: const Offset(0, 4),
            blurRadius: 4,
          ),
        ],
      ),
      child: Center(
        child: Text(
          lettre,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w900,
            color: isSelected ? Colors.black : Colors.white,
          ),
        ),
      ),
    );
  }

  Color _getCubeColor(int index) {
    List<Color> colors = [
      Colors.pinkAccent,
      Colors.deepOrangeAccent,
      Colors.blueAccent,
      Colors.purpleAccent,
      Colors.tealAccent.shade700,
      Colors.orangeAccent,
      Colors.indigoAccent,
    ];
    return colors[index % colors.length];
  }
}