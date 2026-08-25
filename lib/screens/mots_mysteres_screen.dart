import 'dart:math';
import 'package:flutter/material.dart';

class WordQuestion {
  final String category;
  final String word;

  const WordQuestion({required this.category, required this.word});
}

class MotsMysteresScreen extends StatefulWidget {
  const MotsMysteresScreen({super.key});

  @override
  State<MotsMysteresScreen> createState() => _MotsMysteresScreenState();
}

class _MotsMysteresScreenState extends State<MotsMysteresScreen> {


final List<WordQuestion> questions = const [
    // --- ANIMAUX ---
    WordQuestion(category: 'ANIMAL', word: 'GIRAFE'),
    WordQuestion(category: 'ANIMAL', word: 'ELEPHANT'),
    WordQuestion(category: 'ANIMAL', word: 'DAUPHIN'),
    WordQuestion(category: 'ANIMAL', word: 'SERPENT'),
    WordQuestion(category: 'ANIMAL', word: 'PANTHERE'),
    WordQuestion(category: 'ANIMAL', word: 'TIGRE'),
    WordQuestion(category: 'ANIMAL', word: 'LEOPARD'),
    WordQuestion(category: 'ANIMAL', word: 'ZEBRE'),
    WordQuestion(category: 'ANIMAL', word: 'KANGOUROU'),
    WordQuestion(category: 'ANIMAL', word: 'CHEVAL'),
    WordQuestion(category: 'ANIMAL', word: 'MOUTON'),
    WordQuestion(category: 'ANIMAL', word: 'COCHON'),
    WordQuestion(category: 'ANIMAL', word: 'LAPIN'),
    WordQuestion(category: 'ANIMAL', word: 'SINGERIE'),
    WordQuestion(category: 'ANIMAL', word: 'GORILLE'),
    WordQuestion(category: 'ANIMAL', word: 'CHAMEAU'),
    WordQuestion(category: 'ANIMAL', word: 'GAZELLE'),
    WordQuestion(category: 'ANIMAL', word: 'AIGLE'),
    WordQuestion(category: 'ANIMAL', word: 'FAUCON'),
    WordQuestion(category: 'ANIMAL', word: 'PERROQUET'),
    WordQuestion(category: 'ANIMAL', word: 'AUTRUCHE'),
    WordQuestion(category: 'ANIMAL', word: 'BALEINE'),
    WordQuestion(category: 'ANIMAL', word: 'REQUIN'),
    WordQuestion(category: 'ANIMAL', word: 'TORTUE'),
    WordQuestion(category: 'ANIMAL', word: 'CROCODILE'),

    // --- FRUITS & LÉGUMES ---
    WordQuestion(category: 'FRUIT / LEGUME', word: 'BANANE'),
    WordQuestion(category: 'FRUIT / LEGUME', word: 'MANGUE'),
    WordQuestion(category: 'FRUIT / LEGUME', word: 'ANANAS'),
    WordQuestion(category: 'FRUIT / LEGUME', word: 'ORANGE'),
    WordQuestion(category: 'FRUIT / LEGUME', word: 'CITRON'),
    WordQuestion(category: 'FRUIT / LEGUME', word: 'PASTEQUE'),
    WordQuestion(category: 'FRUIT / LEGUME', word: 'PAPAYE'),
    WordQuestion(category: 'FRUIT / LEGUME', word: 'POMME'),
    WordQuestion(category: 'FRUIT / LEGUME', word: 'POIRE'),
    WordQuestion(category: 'FRUIT / LEGUME', word: 'FRAISE'),
    WordQuestion(category: 'FRUIT / LEGUME', word: 'CERISE'),
    WordQuestion(category: 'FRUIT / LEGUME', word: 'RAISIN'),
    WordQuestion(category: 'FRUIT / LEGUME', word: 'CAROTTE'),
    WordQuestion(category: 'FRUIT / LEGUME', word: 'TOMATE'),
    WordQuestion(category: 'FRUIT / LEGUME', word: 'OIGNON'),
    WordQuestion(category: 'FRUIT / LEGUME', word: 'SALADE'),
    WordQuestion(category: 'FRUIT / LEGUME', word: 'HARICOT'),
    WordQuestion(category: 'FRUIT / LEGUME', word: 'AVOCAT'),
    WordQuestion(category: 'FRUIT / LEGUME', word: 'MELON'),
    WordQuestion(category: 'FRUIT / LEGUME', word: 'GOMBO'),

    // --- PAYS ---
    WordQuestion(category: 'PAYS', word: 'SENEGAL'),
    WordQuestion(category: 'PAYS', word: 'FRANCE'),
    WordQuestion(category: 'PAYS', word: 'CANADA'),
    WordQuestion(category: 'PAYS', word: 'BRESIL'),
    WordQuestion(category: 'PAYS', word: 'MAROC'),
    WordQuestion(category: 'PAYS', word: 'EGYPTE'),
    WordQuestion(category: 'PAYS', word: 'JAPON'),
    WordQuestion(category: 'PAYS', word: 'CHINE'),
    WordQuestion(category: 'PAYS', word: 'ITALIE'),
    WordQuestion(category: 'PAYS', word: 'ESPAGNE'),
    WordQuestion(category: 'PAYS', word: 'MALI'),
    WordQuestion(category: 'PAYS', word: 'GUINEE'),
    WordQuestion(category: 'PAYS', word: 'NIGERIA'),
    WordQuestion(category: 'PAYS', word: 'GHANA'),
    WordQuestion(category: 'PAYS', word: 'ALLEMAGNE'),
    WordQuestion(category: 'PAYS', word: 'ARGENTINE'),
    WordQuestion(category: 'PAYS', word: 'TUNISIE'),
    WordQuestion(category: 'PAYS', word: 'MEXIQUE'),

    // --- VILLES ---
    WordQuestion(category: 'VILLE', word: 'DAKAR'),
    WordQuestion(category: 'VILLE', word: 'PARIS'),
    WordQuestion(category: 'VILLE', word: 'TOKYO'),
    WordQuestion(category: 'VILLE', word: 'LONDRES'),
    WordQuestion(category: 'VILLE', word: 'THIES'),
    WordQuestion(category: 'VILLE', word: 'BAMAKO'),
    WordQuestion(category: 'VILLE', word: 'ABIDJAN'),
    WordQuestion(category: 'VILLE', word: 'RABAT'),
    WordQuestion(category: 'VILLE', word: 'CAIRE'),
    WordQuestion(category: 'VILLE', word: 'ROME'),
    WordQuestion(category: 'VILLE', word: 'MADRID'),
    WordQuestion(category: 'VILLE', word: 'NEWYORK'),

    // --- OBJETS & ÉCOLE ---
    WordQuestion(category: 'OBJET', word: 'CARTABLE'),
    WordQuestion(category: 'OBJET', word: 'CRAYON'),
    WordQuestion(category: 'OBJET', word: 'CAHIER'),
    WordQuestion(category: 'OBJET', word: 'ARDISE'),
    WordQuestion(category: 'OBJET', word: 'TABLEAU'),
    WordQuestion(category: 'OBJET', word: 'TROUSSE'),
    WordQuestion(category: 'OBJET', word: 'RÈGLE'),
    WordQuestion(category: 'OBJET', word: 'CISEAUX'),
    WordQuestion(category: 'OBJET', word: 'HORLOGE'),
    WordQuestion(category: 'OBJET', word: 'ORDINATEUR'),
    WordQuestion(category: 'OBJET', word: 'TELEPHONE'),
    WordQuestion(category: 'OBJET', word: 'VALISE'),
    WordQuestion(category: 'OBJET', word: 'MIROIR'),
    WordQuestion(category: 'OBJET', word: 'LAMPADA IRE'),

    // --- TRANSPORTS ---
    WordQuestion(category: 'TRANSPORT', word: 'AVION'),
    WordQuestion(category: 'TRANSPORT', word: 'BATEAU'),
    WordQuestion(category: 'TRANSPORT', word: 'VOITURE'),
    WordQuestion(category: 'TRANSPORT', word: 'CAMION'),
    WordQuestion(category: 'TRANSPORT', word: 'TRAIN'),
    WordQuestion(category: 'TRANSPORT', word: 'BICYCLETTE'),
    WordQuestion(category: 'TRANSPORT', word: 'FUSEE'),
    WordQuestion(category: 'TRANSPORT', word: 'HELICOPTERE'),

    // --- NATURE & ESPACE ---
    WordQuestion(category: 'NATURE', word: 'SOLEIL'),
    WordQuestion(category: 'NATURE', word: 'ETOILE'),
    WordQuestion(category: 'NATURE', word: 'PLANETE'),
    WordQuestion(category: 'NATURE', word: 'RIVIERE'),
    WordQuestion(category: 'NATURE', word: 'MONTAGNE'),
    WordQuestion(category: 'NATURE', word: 'VOLCAN'),
    WordQuestion(category: 'NATURE', word: 'FORET'),
    WordQuestion(category: 'NATURE', word: 'DESERT'),
    WordQuestion(category: 'NATURE', word: 'NUAGE'),
    WordQuestion(category: 'NATURE', word: 'ORAGE'),

    // --- MÉRTIERS ---
    WordQuestion(category: 'METIER', word: 'DOCTEUR'),
    WordQuestion(category: 'METIER', word: 'MAITRE'),
    WordQuestion(category: 'METIER', word: 'PILOTE'),
    WordQuestion(category: 'METIER', word: 'POMPIER'),
    WordQuestion(category: 'METIER', word: 'POLICIER'),
    WordQuestion(category: 'METIER', word: 'CUISINIER'),
    WordQuestion(category: 'METIER', word: 'ARTISTE'),
    WordQuestion(category: 'METIER', word: 'ARCHITECTE'),

    // --- ANIMAUX (SUITE) ---
    WordQuestion(category: 'ANIMAL', word: 'HIPPOPOTAME'),
    WordQuestion(category: 'ANIMAL', word: 'RHINOCEROS'),
    WordQuestion(category: 'ANIMAL', word: 'CHIMPANZE'),
    WordQuestion(category: 'ANIMAL', word: 'PINGOUIN'),
    WordQuestion(category: 'ANIMAL', word: 'MANCHOT'),
    WordQuestion(category: 'ANIMAL', word: 'AUTRUCHE'),
    WordQuestion(category: 'ANIMAL', word: 'FLAMANT'),
    WordQuestion(category: 'ANIMAL', word: 'PELICAN'),
    WordQuestion(category: 'ANIMAL', word: 'CORBEAU'),
    WordQuestion(category: 'ANIMAL', word: 'HIBOU'),
    WordQuestion(category: 'ANIMAL', word: 'CHOUETTE'),
    WordQuestion(category: 'ANIMAL', word: 'CAMALEON'),
    WordQuestion(category: 'ANIMAL', word: 'IGUANE'),
    WordQuestion(category: 'ANIMAL', word: 'SALAMANDRE'),
    WordQuestion(category: 'ANIMAL', word: 'GRENOUILLE'),
    WordQuestion(category: 'ANIMAL', word: 'CRAPAUD'),
    WordQuestion(category: 'ANIMAL', word: 'MEDUSE'),
    WordQuestion(category: 'ANIMAL', word: 'PIUVRE'),
    WordQuestion(category: 'ANIMAL', word: 'HOMARD'),
    WordQuestion(category: 'ANIMAL', word: 'CREVETTE'),
    WordQuestion(category: 'ANIMAL', word: 'CRABE'),
    WordQuestion(category: 'ANIMAL', word: 'CREQUET'),
    WordQuestion(category: 'ANIMAL', word: 'LIBELLULE'),
    WordQuestion(category: 'ANIMAL', word: 'PAPILLON'),
    WordQuestion(category: 'ANIMAL', word: 'ABEILLE'),
    WordQuestion(category: 'ANIMAL', word: 'GUEPE'),
    WordQuestion(category: 'ANIMAL', word: 'FOURMI'),
    WordQuestion(category: 'ANIMAL', word: 'COCCINELLE'),
    WordQuestion(category: 'ANIMAL', word: 'ESCARGOT'),
    WordQuestion(category: 'ANIMAL', word: 'HERISSON'),
    WordQuestion(category: 'ANIMAL', word: 'ECUREUIL'),
    WordQuestion(category: 'ANIMAL', word: 'BLAIREAU'),
    WordQuestion(category: 'ANIMAL', word: 'CASTOR'),
    WordQuestion(category: 'ANIMAL', word: 'LOUP'),
    WordQuestion(category: 'ANIMAL', word: 'RENARD'),
    WordQuestion(category: 'ANIMAL', word: 'OURS'),
    WordQuestion(category: 'ANIMAL', word: 'KOALA'),
    WordQuestion(category: 'ANIMAL', word: 'PANDA'),
    WordQuestion(category: 'ANIMAL', word: 'PARESSEUX'),

    // --- FRUITS, LÉGUMES & NOURRITURE ---
    WordQuestion(category: 'FRUIT / LEGUME', word: 'CRAMBERRY'),
    WordQuestion(category: 'FRUIT / LEGUME', word: 'FRAMBOISE'),
    WordQuestion(category: 'FRUIT / LEGUME', word: 'MYRTILLE'),
    WordQuestion(category: 'FRUIT / LEGUME', word: 'CASSIS'),
    WordQuestion(category: 'FRUIT / LEGUME', word: 'GROSEILLE'),
    WordQuestion(category: 'FRUIT / LEGUME', word: 'ABRICOT'),
    WordQuestion(category: 'FRUIT / LEGUME', word: 'PECHE'),
    WordQuestion(category: 'FRUIT / LEGUME', word: 'BRUGNON'),
    WordQuestion(category: 'FRUIT / LEGUME', word: 'NECTARINE'),
    WordQuestion(category: 'FRUIT / LEGUME', word: 'PRUNE'),
    WordQuestion(category: 'FRUIT / LEGUME', word: 'FIGUE'),
    WordQuestion(category: 'FRUIT / LEGUME', word: 'DATTE'),
    WordQuestion(category: 'FRUIT / LEGUME', word: 'GRENADE'),
    WordQuestion(category: 'FRUIT / LEGUME', word: 'KIWI'),
    WordQuestion(category: 'FRUIT / LEGUME', word: 'LITCHI'),
    WordQuestion(category: 'FRUIT / LEGUME', word: 'COROSSOL'),
    WordQuestion(category: 'FRUIT / LEGUME', word: 'MARACUJA'),
    WordQuestion(category: 'FRUIT / LEGUME', word: 'COURGETTE'),
    WordQuestion(category: 'FRUIT / LEGUME', word: 'AUBERGINE'),
    WordQuestion(category: 'FRUIT / LEGUME', word: 'CONCOMBRE'),
    WordQuestion(category: 'FRUIT / LEGUME', word: 'POTIRON'),
    WordQuestion(category: 'FRUIT / LEGUME', word: 'CITROUILLE'),
    WordQuestion(category: 'FRUIT / LEGUME', word: 'BROCOLI'),
    WordQuestion(category: 'FRUIT / LEGUME', word: 'CHOUFLEUR'),
    WordQuestion(category: 'FRUIT / LEGUME', word: 'EPINARD'),
    WordQuestion(category: 'FRUIT / LEGUME', word: 'POIREAU'),
    WordQuestion(category: 'FRUIT / LEGUME', word: 'CELERI'),
    WordQuestion(category: 'FRUIT / LEGUME', word: 'NAVET'),
    WordQuestion(category: 'FRUIT / LEGUME', word: 'RADIS'),
    WordQuestion(category: 'FRUIT / LEGUME', word: 'BETTERAVE'),
    WordQuestion(category: 'FRUIT / LEGUME', word: 'MANIOC'),
    WordQuestion(category: 'FRUIT / LEGUME', word: 'PATATE'),
    WordQuestion(category: 'FRUIT / LEGUME', word: 'IGNAME'),
    WordQuestion(category: 'FRUIT / LEGUME', word: 'MAIS'),
    WordQuestion(category: 'FRUIT / LEGUME', word: 'PETITPOIS'),
    WordQuestion(category: 'NOURRITURE', word: 'CHOCLAT'),
    WordQuestion(category: 'NOURRITURE', word: 'GATEAU'),
    WordQuestion(category: 'NOURRITURE', word: 'BISCUIT'),
    WordQuestion(category: 'NOURRITURE', word: 'CONFITURE'),
    WordQuestion(category: 'NOURRITURE', word: 'FROMAGE'),
    WordQuestion(category: 'NOURRITURE', word: 'YAOURT'),
    WordQuestion(category: 'NOURRITURE', word: 'OMELETTE'),
    WordQuestion(category: 'NOURRITURE', word: 'SOUPE'),

    // --- PAYS & VILLES (SUITE) ---
    WordQuestion(category: 'PAYS', word: 'CAMEROUN'),
    WordQuestion(category: 'PAYS', word: 'GABON'),
    WordQuestion(category: 'PAYS', word: 'CONGO'),
    WordQuestion(category: 'PAYS', word: 'ANGOLA'),
    WordQuestion(category: 'PAYS', word: 'ZAMBIE'),
    WordQuestion(category: 'PAYS', word: 'KENYA'),
    WordQuestion(category: 'PAYS', word: 'ETHIOPIE'),
    WordQuestion(category: 'PAYS', word: 'MADAGASCAR'),
    WordQuestion(category: 'PAYS', word: 'ALGERIE'),
    WordQuestion(category: 'PAYS', word: 'MAURITANIE'),
    WordQuestion(category: 'PAYS', word: 'GAMBIE'),
    WordQuestion(category: 'PAYS', word: 'TOGO'),
    WordQuestion(category: 'PAYS', word: 'BENIN'),
    WordQuestion(category: 'PAYS', word: 'PORTUGAL'),
    WordQuestion(category: 'PAYS', word: 'BELGIQUE'),
    WordQuestion(category: 'PAYS', word: 'SUISSE'),
    WordQuestion(category: 'PAYS', word: 'AUTRICHE'),
    WordQuestion(category: 'PAYS', word: 'GRECE'),
    WordQuestion(category: 'PAYS', word: 'TURQUIE'),
    WordQuestion(category: 'PAYS', word: 'RUSSIE'),
    WordQuestion(category: 'PAYS', word: 'INDE'),
    WordQuestion(category: 'PAYS', word: 'VIETNAM'),
    WordQuestion(category: 'PAYS', word: 'THAILANDE'),
    WordQuestion(category: 'PAYS', word: 'INDONESIE'),
    WordQuestion(category: 'PAYS', word: 'AUSTRALIE'),
    WordQuestion(category: 'VILLE', word: 'SAINTLOUIS'),
    WordQuestion(category: 'VILLE', word: 'ZIGUINCHOR'),
    WordQuestion(category: 'VILLE', word: 'TOUBA'),
    WordQuestion(category: 'VILLE', word: 'KAOLACK'),
    WordQuestion(category: 'VILLE', word: 'RUFISQUE'),
    WordQuestion(category: 'VILLE', word: 'CASABLANCA'),
    WordQuestion(category: 'VILLE', word: 'MARRAKECH'),
    WordQuestion(category: 'VILLE', word: 'ALGER'),
    WordQuestion(category: 'VILLE', word: 'TUNIS'),
    WordQuestion(category: 'VILLE', word: 'BERLIN'),
    WordQuestion(category: 'VILLE', word: 'AMSTERDAM'),
    WordQuestion(category: 'VILLE', word: 'BRUXELLES'),
    WordQuestion(category: 'VILLE', word: 'LISBONNE'),
    WordQuestion(category: 'VILLE', word: 'MOSCOU'),
    WordQuestion(category: 'VILLE', word: 'BEIJING'),
    WordQuestion(category: 'VILLE', word: 'SYDNEY'),

    // --- OBJETS, ÉCOLE & MAISON ---
    WordQuestion(category: 'OBJET', word: 'STYLO'),
    WordQuestion(category: 'OBJET', word: 'GOMME'),
    WordQuestion(category: 'OBJET', word: 'TAILLECRAYON'),
    WordQuestion(category: 'OBJET', word: 'CLASSEUR'),
    WordQuestion(category: 'OBJET', word: 'COMPAS'),
    WordQuestion(category: 'OBJET', word: 'RAPPORTEUR'),
    WordQuestion(category: 'OBJET', word: 'CALCULATRICE'),
    WordQuestion(category: 'OBJET', word: 'DICTIONNAIRE'),
    WordQuestion(category: 'OBJET', word: 'ENVELOPPE'),
    WordQuestion(category: 'OBJET', word: 'TIMBRE'),
    WordQuestion(category: 'OBJET', word: 'FAUTEUIL'),
    WordQuestion(category: 'OBJET', word: 'CANAPE'),
    WordQuestion(category: 'OBJET', word: 'ARMOIRE'),
    WordQuestion(category: 'OBJET', word: 'COMMODE'),
    WordQuestion(category: 'OBJET', word: 'ETAGERE'),
    WordQuestion(category: 'OBJET', word: 'REFRIGERATEUR'),
    WordQuestion(category: 'OBJET', word: 'CONGELATEUR'),
    WordQuestion(category: 'OBJET', word: 'MICROONDES'),
    WordQuestion(category: 'OBJET', word: 'TELEVISION'),
    WordQuestion(category: 'OBJET', word: 'RADIO'),
    WordQuestion(category: 'OBJET', word: 'ENCEINTE'),
    WordQuestion(category: 'OBJET', word: 'CASQUE'),
    WordQuestion(category: 'OBJET', word: 'VENTILATEUR'),
    WordQuestion(category: 'OBJET', word: 'CLIMATISEUR'),
    WordQuestion(category: 'OBJET', word: 'Casserole'),
    WordQuestion(category: 'OBJET', word: 'POELE'),
    WordQuestion(category: 'OBJET', word: 'ASSIETTE'),
    WordQuestion(category: 'OBJET', word: 'CUILLERE'),
    WordQuestion(category: 'OBJET', word: 'FOURCHETTE'),
    WordQuestion(category: 'OBJET', word: 'COUTEAU'),
    WordQuestion(category: 'OBJET', word: 'BOUTEILLE'),
    WordQuestion(category: 'OBJET', word: 'VERRE'),
    WordQuestion(category: 'OBJET', word: 'SERVIETTE'),
    WordQuestion(category: 'OBJET', word: 'SAVON'),
    WordQuestion(category: 'OBJET', word: 'BROSSE'),
    WordQuestion(category: 'OBJET', word: 'PEIGNE'),
    WordQuestion(category: 'OBJET', word: 'DENTIFRICE'),

    // --- TRANSPORTS & MÉTIERS (SUITE) ---
    WordQuestion(category: 'TRANSPORT', word: 'AUTOBUS'),
    WordQuestion(category: 'TRANSPORT', word: 'AUTOCAR'),
    WordQuestion(category: 'TRANSPORT', word: 'METRO'),
    WordQuestion(category: 'TRANSPORT', word: 'TRAMWAY'),
    WordQuestion(category: 'TRANSPORT', word: 'MOTOCYCLETTE'),
    WordQuestion(category: 'TRANSPORT', word: 'SCOOTER'),
    WordQuestion(category: 'TRANSPORT', word: 'TROTTINETTE'),
    WordQuestion(category: 'TRANSPORT', word: 'TAXIMETRE'),
    WordQuestion(category: 'TRANSPORT', word: 'AMBULANCE'),
    WordQuestion(category: 'TRANSPORT', word: 'PIROGUE'),
    WordQuestion(category: 'TRANSPORT', word: 'VOILIER'),
    WordQuestion(category: 'TRANSPORT', word: 'SOUSMARIN'),
    WordQuestion(category: 'METIER', word: 'DENTISTE'),
    WordQuestion(category: 'METIER', word: 'CHIRURGIEN'),
    WordQuestion(category: 'METIER', word: 'INFIRMIER'),
    WordQuestion(category: 'METIER', word: 'VETERINAIRE'),
    WordQuestion(category: 'METIER', word: 'PHARMACIEN'),
    WordQuestion(category: 'METIER', word: 'INGENIEUR'),
    WordQuestion(category: 'METIER', word: 'MECANICIEN'),
    WordQuestion(category: 'METIER', word: 'ELECTRICIEN'),
    WordQuestion(category: 'METIER', word: 'PLOMBIER'),
    WordQuestion(category: 'METIER', word: 'MENUISIER'),
    WordQuestion(category: 'METIER', word: 'MACON'),
    WordQuestion(category: 'METIER', word: 'PEINTRE'),
    WordQuestion(category: 'METIER', word: 'BOULANGER'),
    WordQuestion(category: 'METIER', word: 'PATISSIER'),
    WordQuestion(category: 'METIER', word: 'BOUCHER'),
    WordQuestion(category: 'METIER', word: 'COIFFEUR'),
    WordQuestion(category: 'METIER', word: 'TAILLEUR'),
    WordQuestion(category: 'METIER', word: 'JARDINIER'),
    WordQuestion(category: 'METIER', word: 'AGRICULTEUR'),
    WordQuestion(category: 'METIER', word: 'PECHEUR'),
    WordQuestion(category: 'METIER', word: 'JOURNALISTE'),
    WordQuestion(category: 'METIER', word: 'PHOTOGRAPHE'),
    WordQuestion(category: 'METIER', word: 'AVOCAT'),
    WordQuestion(category: 'METIER', word: 'JUGE'),
    WordQuestion(category: 'METIER', word: 'ASTRONAUTE'),

    // --- NATURE, ESPACE & CORPS HUMAIN ---
    WordQuestion(category: 'NATURE', word: 'OCEAN'),
    WordQuestion(category: 'NATURE', word: 'LAC'),
    WordQuestion(category: 'NATURE', word: 'CASCADE'),
    WordQuestion(category: 'NATURE', word: 'FLEUVE'),
    WordQuestion(category: 'NATURE', word: 'LAGUNE'),
    WordQuestion(category: 'NATURE', word: 'COLLINE'),
    WordQuestion(category: 'NATURE', word: 'VALLEE'),
    WordQuestion(category: 'NATURE', word: 'CANYON'),
    WordQuestion(category: 'NATURE', word: 'GROTTE'),
    WordQuestion(category: 'NATURE', word: 'ILE'),
    WordQuestion(category: 'NATURE', word: 'PRESQU ILE'),
    WordQuestion(category: 'ESPACE', word: 'GALAXIE'),
    WordQuestion(category: 'ESPACE', word: 'COMETE'),
    WordQuestion(category: 'ESPACE', word: 'ASTEROIDE'),
    WordQuestion(category: 'ESPACE', word: 'SATELLITE'),
    WordQuestion(category: 'CORPS', word: 'VISAGE'),
    WordQuestion(category: 'CORPS', word: 'CHEVEUX'),
    WordQuestion(category: 'CORPS', word: 'OREILLE'),
    WordQuestion(category: 'CORPS', word: 'EPAULE'),
    WordQuestion(category: 'CORPS', word: 'POITRINE'),
    WordQuestion(category: 'CORPS', word: 'ESTOMAC'),
    WordQuestion(category: 'CORPS', word: 'GENOU'),
    WordQuestion(category: 'CORPS', word: 'CHEVILLE'),
  ];


  late WordQuestion currentQuestion;
  List<String> shuffledLetters = [];
  List<bool> letterUsed = [];
  List<int> selectedIndices = [];

  int score = 0;
  String feedbackMessage = '';
  Color feedbackColor = Colors.amberAccent;

  @override
  void initState() {
    super.initState();
    _loadNewWord();
  }

  void _loadNewWord() {
    final random = Random();
    currentQuestion = questions[random.nextInt(questions.length)];

    List<String> letters = currentQuestion.word.split('');
    do {
      letters.shuffle(random);
    } while (letters.join() == currentQuestion.word && letters.length > 1);

    setState(() {
      shuffledLetters = letters;
      letterUsed = List.generate(letters.length, (_) => false);
      selectedIndices.clear();
      feedbackMessage = '';
    });
  }

  void _addLetter(int index) {
    if (letterUsed[index]) return;
    setState(() {
      letterUsed[index] = true;
      selectedIndices.add(index);
      feedbackMessage = '';
    });

    if (selectedIndices.length == currentQuestion.word.length) {
      _verifyWord();
    }
  }

  void _removeLetter(int position) {
    setState(() {
      int origIndex = selectedIndices[position];
      letterUsed[origIndex] = false;
      selectedIndices.removeAt(position);
      feedbackMessage = '';
    });
  }

  void _resetSelection() {
    setState(() {
      letterUsed = List.generate(shuffledLetters.length, (_) => false);
      selectedIndices.clear();
      feedbackMessage = '';
    });
  }

  void _verifyWord() {
    String userWord = selectedIndices.map((i) => shuffledLetters[i]).join();

    if (userWord == currentQuestion.word) {
      setState(() {
        score += 15;
        feedbackMessage = 'EXCELLENT ! 🎉';
        feedbackColor = Colors.greenAccent;
      });

      Future.delayed(const Duration(milliseconds: 1300), () {
        if (mounted) _loadNewWord();
      });
    } else {
      setState(() {
        feedbackMessage = 'Ce n\'est pas tout à fait ça, réessaie !';
        feedbackColor = Colors.redAccent;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF11998E), Color(0xFF38EF7D)],
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
                      'MOTS MYSTÈRES',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                        letterSpacing: 2,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.black26,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.white, width: 2),
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
              const SizedBox(height: 15),
              // Badge de Catégorie (Indice)
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(25),
                  boxShadow: const [
                    BoxShadow(color: Colors.black26, blurRadius: 8)
                  ],
                ),
                child: Text(
                  'INDICE : ${currentQuestion.category}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF11998E),
                    letterSpacing: 1.2,
                  ),
                ),
              ),
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Zone du mot tapé
                      Container(
                        constraints: const BoxConstraints(minHeight: 70),
                        margin: const EdgeInsets.symmetric(horizontal: 15),
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.black26,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(
                              selectedIndices.length,
                              (index) {
                                int origIndex = selectedIndices[index];
                                return GestureDetector(
                                  onTap: () => _removeLetter(index),
                                  child: _buildLetterBox(
                                    shuffledLetters[origIndex],
                                    color: Colors.amberAccent,
                                    textColor: Colors.black,
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),
                      Text(
                        feedbackMessage,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: feedbackColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Zone des lettres mélangées
              Container(
                padding: const EdgeInsets.all(20),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius:
                      BorderRadius.vertical(top: Radius.circular(30)),
                ),
                child: Column(
                  children: [
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(shuffledLetters.length, (index) {
                          bool isUsed = letterUsed[index];
                          return GestureDetector(
                            onTap: () => _addLetter(index),
                            child: Opacity(
                              opacity: isUsed ? 0.2 : 1.0,
                              child: _buildLetterBox(
                                shuffledLetters[index],
                                color: const Color(0xFF11998E),
                                textColor: Colors.white,
                              ),
                            ),
                          );
                        }),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        OutlinedButton.icon(
                          onPressed: _resetSelection,
                          icon: const Icon(Icons.refresh, color: Colors.redAccent),
                          label: const Text('EFFACER',
                              style: TextStyle(color: Colors.redAccent)),
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Colors.redAccent),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15)),
                          ),
                        ),
                        ElevatedButton.icon(
                          onPressed: _loadNewWord,
                          icon: const Icon(Icons.skip_next, color: Colors.white),
                          label: const Text('PASSER'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF11998E),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15)),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLetterBox(String letter,
      {required Color color, required Color textColor}) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      width: 44,
      height: 50,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(10),
        boxShadow: const [
          BoxShadow(
              color: Colors.black12, offset: Offset(0, 3), blurRadius: 3)
        ],
      ),
      child: Center(
        child: Text(
          letter,
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        ),
      ),
    );
  }
}