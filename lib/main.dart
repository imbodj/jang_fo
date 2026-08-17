import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:audioplayers/audioplayers.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ParaTirApp());
}

// ------------------- GESTIONNAIRE DE SON SÉCURISÉ -------------------
class SoundManager {
  static final AudioPlayer _shootPlayer = AudioPlayer();
  static final AudioPlayer _explosionPlayer = AudioPlayer();
  static final AudioPlayer _powerUpPlayer = AudioPlayer();
  static bool muted = false;

  static Future<void> loadMutePref() async {
    final prefs = await SharedPreferences.getInstance();
    muted = prefs.getBool('muted') ?? false;
  }

  static Future<void> toggleMute() async {
    muted = !muted;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('muted', muted);
  }

  static void playShoot() async {
    if (muted) return;
    try {
      await _shootPlayer.stop();
      await _shootPlayer.play(AssetSource('audio/shoot.wav'),
          mode: PlayerMode.lowLatency);
    } catch (_) {}
  }

  static void playExplosion() async {
    if (muted) return;
    try {
      await _explosionPlayer.stop();
      await _explosionPlayer.play(AssetSource('audio/explosion.wav'),
          mode: PlayerMode.lowLatency);
    } catch (_) {}
  }

  static void playPowerUp() async {
    if (muted) return;
    try {
      await _powerUpPlayer.stop();
      await _powerUpPlayer.play(AssetSource('audio/powerup.wav'),
          mode: PlayerMode.lowLatency);
    } catch (_) {}
  }
}

class ParaTirApp extends StatelessWidget {
  const ParaTirApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Para Tir',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorSchemeSeed: Colors.deepPurple,
      ),
      home: const MainMenuScreen(),
    );
  }
}

enum EnemyType {
  parachutist,
  alien,
  bird,
  helicopter,
  balloon,
  drone,
  meteor,
  plane,
  ufo,
  dragon
}

enum CannonSkin { cyan, pink, gold }

class Enemy {
  double x, y, speed;
  EnemyType type;
  Enemy(
      {required this.x,
      required this.y,
      required this.type,
      required this.speed});

  int get points => (EnemyType.values.indexOf(type) + 1) * 10;

  String get name {
    switch (type) {
      case EnemyType.parachutist:
        return 'Parachutiste';
      case EnemyType.alien:
        return 'Alien Rigolo';
      case EnemyType.bird:
        return 'Oiseau Magique';
      case EnemyType.helicopter:
        return 'Hélico Super';
      case EnemyType.balloon:
        return 'Ballon Festif';
      case EnemyType.drone:
        return 'Drone Tech';
      case EnemyType.meteor:
        return 'Météore de Feu';
      case EnemyType.plane:
        return 'Super Avion';
      case EnemyType.ufo:
        return 'Soucoupe Volante';
      case EnemyType.dragon:
        return 'Dragon de Feu';
    }
  }
}

class Bullet {
  double x, y, vx;
  Bullet({required this.x, required this.y, this.vx = 0.0});
}

class PowerUp {
  double x, y;
  PowerUp({required this.x, required this.y});
}

class Particle {
  double x, y, vx, vy, life;
  Color color;
  Particle(
      {required this.x,
      required this.y,
      required this.vx,
      required this.vy,
      required this.color,
      this.life = 1.0});
}

// ------------------- ÉCRAN MENU PRINCIPAL -------------------
class MainMenuScreen extends StatefulWidget {
  const MainMenuScreen({super.key});

  @override
  State<MainMenuScreen> createState() => _MainMenuScreenState();
}

class _MainMenuScreenState extends State<MainMenuScreen> {
  int highScore = 0;
  int bestLevel = 1;
  CannonSkin selectedSkin = CannonSkin.cyan;

  @override
  void initState() {
    super.initState();
    _loadPrefs();
  }

  Future<void> _loadPrefs() async {
    await SoundManager.loadMutePref();
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      highScore = prefs.getInt('high_score') ?? 0;
      bestLevel = prefs.getInt('best_level') ?? 1;
    });
  }

  void _showAboutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF2A085C),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25),
          side: const BorderSide(color: Colors.amberAccent, width: 2),
        ),
        title: const Text('À propos',
            style: TextStyle(
                color: Colors.amberAccent,
                fontSize: 26,
                fontWeight: FontWeight.bold)),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text('PARA TIR',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2)),
              SizedBox(height: 5),
              Text('Sky Defense Kids',
                  style: TextStyle(
                      color: Colors.cyanAccent,
                      fontSize: 16,
                      fontStyle: FontStyle.italic)),
              SizedBox(height: 15),
              Text('Version 1.0.0', style: TextStyle(color: Colors.white70)),
              Divider(color: Colors.amberAccent, height: 25),
              Text('Développé par :', style: TextStyle(color: Colors.white70)),
              SizedBox(height: 5),
              Text('Ismaela Mbodji',
                  style: TextStyle(
                      color: Colors.greenAccent,
                      fontSize: 20,
                      fontWeight: FontWeight.bold)),
              SizedBox(height: 15),
              Text('© 2026 - Tous droits réservés',
                  style: TextStyle(color: Colors.white38, fontSize: 12)),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('FERMER',
                style: TextStyle(
                    color: Colors.amberAccent, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isLandscape = size.width > size.height;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF2A085C), Color(0xFF4A00E0)],
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: size.height),
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: isLandscape ? 16 : 40, horizontal: 24),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'PARA TIR',
                            style: TextStyle(
                                fontSize: isLandscape ? 36 : 52,
                                fontWeight: FontWeight.w900,
                                color: Colors.amberAccent,
                                letterSpacing: 4),
                          ),
                          Text(
                            'SKY DEFENSE KIDS',
                            style: TextStyle(
                                fontSize: isLandscape ? 14 : 18,
                                color: Colors.cyanAccent,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: isLandscape ? 14 : 30),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 24, vertical: 12),
                            decoration: BoxDecoration(
                              color: Colors.black38,
                              borderRadius: BorderRadius.circular(25),
                              border: Border.all(
                                  color: Colors.amberAccent, width: 2),
                            ),
                            child: Column(
                              children: [
                                Text(
                                  '🏆 MEILLEUR SCORE : $highScore',
                                  style: TextStyle(
                                      fontSize: isLandscape ? 16 : 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '⭐ Meilleur niveau : $bestLevel',
                                  style: TextStyle(
                                      fontSize: isLandscape ? 13 : 15,
                                      color: Colors.cyanAccent),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: isLandscape ? 20 : 40),
                          Text('Choisis ton Canon :',
                              style: TextStyle(
                                  fontSize: isLandscape ? 14 : 16,
                                  color: Colors.white70)),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _skinButton(CannonSkin.cyan, Colors.cyanAccent),
                              const SizedBox(width: 15),
                              _skinButton(CannonSkin.pink, Colors.pinkAccent),
                              const SizedBox(width: 15),
                              _skinButton(CannonSkin.gold, Colors.amberAccent),
                            ],
                          ),
                          SizedBox(height: isLandscape ? 24 : 50),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        GameScreen(skin: selectedSkin)),
                              ).then((_) => _loadPrefs());
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.greenAccent,
                              foregroundColor: Colors.black,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 50,
                                  vertical: isLandscape ? 12 : 18),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30)),
                            ),
                            child: Text('JOUER',
                                style: TextStyle(
                                    fontSize: isLandscape ? 22 : 28,
                                    fontWeight: FontWeight.w900)),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              // Placés APRÈS le scroll view pour rester au-dessus (tap + affichage)
              Positioned(
                top: 10,
                right: 10,
                child: Row(
                  children: [
                    IconButton(
                      icon: Icon(
                          SoundManager.muted
                              ? Icons.volume_off
                              : Icons.volume_up,
                          color: Colors.amberAccent,
                          size: 28),
                      onPressed: () async {
                        await SoundManager.toggleMute();
                        setState(() {});
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.info_outline,
                          color: Colors.amberAccent, size: 30),
                      onPressed: _showAboutDialog,
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

  Widget _skinButton(CannonSkin skin, Color color) {
    bool isSelected = selectedSkin == skin;
    return GestureDetector(
      onTap: () => setState(() => selectedSkin = skin),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected ? color.withOpacity(0.3) : Colors.black26,
          shape: BoxShape.circle,
          border: Border.all(
              color: isSelected ? color : Colors.transparent, width: 3),
        ),
        child: Icon(Icons.security, color: color, size: 36),
      ),
    );
  }
}

// ------------------- ÉCRAN DE JEU FLUIDE (TICKER) -------------------
class GameScreen extends StatefulWidget {
  final CannonSkin skin;
  const GameScreen({super.key, required this.skin});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  late Ticker _ticker;
  double cannonX = 0.5;
  int score = 0, lives = 5, level = 1, enemiesKilled = 0;
  bool gameOver = false,
      showLevelUp = false,
      showInstructions = true,
      isPaused = false;
  int tripleShotTicks = 0;

  final List<Enemy> enemies = [];
  final List<Bullet> bullets = [];
  final List<PowerUp> powerUps = [];
  final List<Particle> particles = [];
  final Random random = Random();

  EnemyType get currentEnemyType =>
      EnemyType.values[(level - 1).clamp(0, EnemyType.values.length - 1)];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _ticker = createTicker(_onTick);
    startGame();
  }

  // Pause automatique quand l'app passe en arrière-plan (appel, home, etc.)
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state != AppLifecycleState.resumed) {
      if (!isPaused && !gameOver && !showInstructions) {
        setState(() => isPaused = true);
      }
      if (_ticker.isTicking) _ticker.stop();
    }
  }

  void startGame() {
    setState(() {
      score = 0;
      lives = 5;
      level = 1;
      enemiesKilled = 0;
      gameOver = false;
      showLevelUp = false;
      showInstructions = true;
      isPaused = false;
      tripleShotTicks = 0;
      enemies.clear();
      bullets.clear();
      powerUps.clear();
      particles.clear();
    });
    if (!_ticker.isTicking) _ticker.start();
  }

  void togglePause() {
    setState(() {
      isPaused = !isPaused;
    });
    if (isPaused) {
      _ticker.stop();
    } else {
      if (!_ticker.isTicking) _ticker.start();
    }
  }

  void _onTick(Duration elapsed) {
    if (!gameOver && !showLevelUp && !showInstructions && !isPaused) {
      updateGame();
    }
  }

  void addEnemy() {
    double speed =
        (level <= 4) ? 0.0020 + (level * 0.0004) : 0.0030 + (level * 0.0005);
    enemies.add(Enemy(
      x: random.nextDouble() * 0.8 + 0.1,
      y: 0.05,
      type: currentEnemyType,
      speed: speed,
    ));
  }

  void createExplosion(double x, double y, Color color) {
    SoundManager.playExplosion();
    HapticFeedback.lightImpact();
    for (int i = 0; i < 14; i++) {
      double angle = random.nextDouble() * 2 * pi;
      double speed = random.nextDouble() * 0.008 + 0.002;
      particles.add(Particle(
          x: x,
          y: y,
          vx: cos(angle) * speed,
          vy: sin(angle) * speed,
          color: color));
    }
  }

  Future<void> _checkHighScore() async {
    final prefs = await SharedPreferences.getInstance();
    int currentHigh = prefs.getInt('high_score') ?? 0;
    if (score > currentHigh) {
      await prefs.setInt('high_score', score);
    }
    int currentBestLevel = prefs.getInt('best_level') ?? 1;
    if (level > currentBestLevel) {
      await prefs.setInt('best_level', level);
    }
  }

  void levelUp() {
    if (showLevelUp || gameOver) return;

    setState(() {
      level++;
      enemiesKilled = 0;
      showLevelUp = true;
      enemies.clear();
      bullets.clear();
    });
    _checkHighScore();

    Timer(const Duration(seconds: 2), () {
      if (mounted && !gameOver) {
        setState(() {
          showLevelUp = false;
          for (int i = 0; i < 3; i++) {
            addEnemy();
          }
        });
      }
    });
  }

  void updateGame() {
    if (showLevelUp || gameOver || showInstructions || isPaused) return;

    bool shouldLevelUp = false;

    setState(() {
      if (tripleShotTicks > 0) tripleShotTicks--;

      for (var p in particles) {
        p.x += p.vx;
        p.y += p.vy;
        p.life -= 0.05;
      }
      particles.removeWhere((p) => p.life <= 0);

      for (var e in enemies) {
        e.y += e.speed;
      }
      for (var b in bullets) {
        b.y -= 0.035;
        b.x += b.vx;
      }
      for (var pu in powerUps) {
        pu.y += 0.003;
      }

      List<Bullet> bRemove = [];
      List<Enemy> eRemove = [];

      for (var b in bullets) {
        if (b.y < 0) {
          bRemove.add(b);
          continue;
        }
        for (var e in enemies) {
          if ((e.x - b.x).abs() < 0.08 && (e.y - b.y).abs() < 0.08) {
            score += e.points;
            enemiesKilled++;
            bRemove.add(b);
            eRemove.add(e);
            createExplosion(e.x, e.y, Colors.amberAccent);

            if (random.nextDouble() < 0.20) {
              powerUps.add(PowerUp(x: e.x, y: e.y));
            }

            if (enemiesKilled >= 10 && level < 10 && !showLevelUp) {
              shouldLevelUp = true;
            }
            break;
          }
        }
      }
      bullets.removeWhere((b) => bRemove.contains(b));
      enemies.removeWhere((e) => eRemove.contains(e));

      powerUps.removeWhere((pu) {
        if ((pu.x - cannonX).abs() < 0.1 && pu.y >= 0.8) {
          tripleShotTicks = 300;
          SoundManager.playPowerUp();
          HapticFeedback.mediumImpact();
          createExplosion(pu.x, pu.y, Colors.cyanAccent);
          return true;
        }
        return pu.y > 1.0;
      });

      List<Enemy> groundEnemies = [];
      for (var e in enemies) {
        if (e.y >= 0.78) {
          groundEnemies.add(e);
          lives--;
          HapticFeedback.heavyImpact();
          createExplosion(e.x, 0.80, Colors.redAccent);
          if (lives <= 0) {
            gameOver = true;
            showLevelUp = false;
            _ticker.stop();
            _checkHighScore();
          }
        }
      }
      enemies.removeWhere((e) => groundEnemies.contains(e));

      if (!showLevelUp && !gameOver && !showInstructions && !shouldLevelUp) {
        if (enemies.isEmpty || enemies.length < 3) {
          addEnemy();
        } else if (enemies.length < 3 + (level ~/ 2) &&
            random.nextDouble() < 0.03) {
          addEnemy();
        }
      }
    });

    if (shouldLevelUp) {
      levelUp();
    }
  }

  void shoot() {
    if (gameOver || showLevelUp || showInstructions || isPaused) return;
    SoundManager.playShoot();
    HapticFeedback.selectionClick();

    setState(() {
      if (tripleShotTicks > 0) {
        bullets.add(Bullet(x: cannonX, y: 0.78, vx: -0.008));
        bullets.add(Bullet(x: cannonX, y: 0.78, vx: 0.0));
        bullets.add(Bullet(x: cannonX, y: 0.78, vx: 0.008));
      } else {
        bullets.add(Bullet(x: cannonX, y: 0.78));
      }
    });
  }

  Future<bool> _confirmExit() async {
    if (gameOver) return true; // pas besoin de confirmer si la partie est finie

    final wasPaused = isPaused;
    if (!wasPaused && !gameOver && !showInstructions) {
      togglePause();
    }

    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF2A085C),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: Colors.amberAccent, width: 2),
        ),
        title: const Text('Quitter la partie ?',
            style: TextStyle(color: Colors.amberAccent)),
        content: const Text(
          'Ta progression de cette partie sera perdue.',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('CONTINUER À JOUER',
                style: TextStyle(color: Colors.white70)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('QUITTER',
                style: TextStyle(
                    color: Colors.redAccent, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );

    if (result != true && mounted) {
      // L'utilisateur reste : on relance seulement si ce n'était pas déjà en pause avant
      if (!wasPaused && isPaused) togglePause();
    }

    return result ?? false;
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _ticker.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isLandscape = screenSize.width > screenSize.height;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        final shouldExit = await _confirmExit();
        if (shouldExit && mounted) {
          Navigator.of(context).pop();
        }
      },
      child: Scaffold(
        body: SafeArea(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: level >= 7
                    ? [const Color(0xFF2D0036), const Color(0xFF000000)]
                    : [const Color(0xFF4A00E0), const Color(0xFF8E2DE2)],
              ),
            ),
            child: Stack(
              children: [
                Positioned.fill(
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onHorizontalDragUpdate: (details) {
                      if (showInstructions || isPaused) return;
                      final width = MediaQuery.of(context).size.width;
                      setState(() {
                        cannonX = (details.localPosition.dx / width)
                            .clamp(0.08, 0.92);
                      });
                    },
                    onTapDown: (_) => shoot(),
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        final w = constraints.maxWidth,
                            h = constraints.maxHeight;
                        return Stack(
                          children: [
                            ...particles.map((p) => Positioned(
                                  left: p.x * w,
                                  top: p.y * h,
                                  child: Opacity(
                                    opacity: p.life.clamp(0.0, 1.0),
                                    child: Container(
                                        width: 6,
                                        height: 6,
                                        decoration: BoxDecoration(
                                            color: p.color,
                                            shape: BoxShape.circle)),
                                  ),
                                )),
                            ...enemies.map((e) => Positioned(
                                left: e.x * w - 30,
                                top: e.y * h - 30,
                                child: EnemyWidget(type: e.type, size: 60))),
                            ...powerUps.map((pu) => Positioned(
                                  left: pu.x * w - 15,
                                  top: pu.y * h - 15,
                                  child: const Icon(Icons.star,
                                      color: Colors.amber, size: 30),
                                )),
                            ...bullets.map((b) => Positioned(
                                  left: b.x * w - 6,
                                  top: b.y * h - 12,
                                  child: Container(
                                    width: 12,
                                    height: 24,
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: tripleShotTicks > 0
                                            ? [Colors.cyan, Colors.blue]
                                            : [
                                                Colors.yellow,
                                                Colors.orangeAccent
                                              ],
                                      ),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                  ),
                                )),
                            Positioned(
                                left: cannonX * w - 30,
                                bottom: 55,
                                child: CannonWidget(skin: widget.skin)),
                            Positioned(
                                bottom: 45,
                                left: 0,
                                right: 0,
                                child: Container(
                                    height: 6, color: Colors.greenAccent)),
                          ],
                        );
                      },
                    ),
                  ),
                ),
                Positioned(
                  top: 15,
                  left: 10,
                  right: 10,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                              color: Colors.black45,
                              borderRadius: BorderRadius.circular(15)),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('NIVEAU $level',
                                  style: const TextStyle(
                                      color: Colors.amberAccent,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w900)),
                              Text('SCORE: $score',
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(
                                minWidth: 34, minHeight: 34),
                            iconSize: 20,
                            icon: Icon(
                                SoundManager.muted
                                    ? Icons.volume_off
                                    : Icons.volume_up,
                                color: Colors.white),
                            onPressed: () async {
                              await SoundManager.toggleMute();
                              setState(() {});
                            },
                          ),
                          if (!showInstructions && !gameOver)
                            IconButton(
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(
                                  minWidth: 34, minHeight: 34),
                              iconSize: 20,
                              icon: Icon(
                                  isPaused
                                      ? Icons.play_arrow
                                      : Icons.pause,
                                  color: Colors.white),
                              onPressed: togglePause,
                            ),
                          IconButton(
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(
                                minWidth: 34, minHeight: 34),
                            iconSize: 20,
                            icon: const Icon(Icons.arrow_back,
                                color: Colors.white),
                            onPressed: () async {
                              final shouldExit = await _confirmExit();
                              if (shouldExit && mounted) {
                                Navigator.of(context).pop();
                              }
                            },
                          ),
                        ],
                      ),
                      Flexible(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 6),
                          decoration: BoxDecoration(
                              color: Colors.black45,
                              borderRadius: BorderRadius.circular(15)),
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: List.generate(
                                  5,
                                  (i) => Icon(
                                      i < lives
                                          ? Icons.favorite
                                          : Icons.favorite_border,
                                      color: Colors.pinkAccent,
                                      size: 16)),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                if (isPaused && !showInstructions && !gameOver)
                  Container(
                    color: Colors.black.withOpacity(0.75),
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.pause_circle_filled,
                              color: Colors.amberAccent, size: 70),
                          const SizedBox(height: 10),
                          const Text('PAUSE',
                              style: TextStyle(
                                  color: Colors.amberAccent,
                                  fontSize: 36,
                                  fontWeight: FontWeight.w900)),
                          const SizedBox(height: 25),
                          ElevatedButton.icon(
                            onPressed: togglePause,
                            icon: const Icon(Icons.play_arrow,
                                color: Colors.black),
                            label: const Text('REPRENDRE',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold)),
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.greenAccent,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 30, vertical: 14)),
                          ),
                        ],
                      ),
                    ),
                  ),
                if (showLevelUp)
                  Container(
                    color: Colors.black87,
                    child: Center(
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text('BRAVO !',
                                style: TextStyle(
                                    color: Colors.amberAccent,
                                    fontSize: isLandscape ? 32 : 48,
                                    fontWeight: FontWeight.w900)),
                            const SizedBox(height: 10),
                            Text('Passage au Niveau $level',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: isLandscape ? 18 : 24)),
                            SizedBox(height: isLandscape ? 10 : 20),
                            EnemyWidget(
                                type: currentEnemyType,
                                size: isLandscape ? 60 : 90),
                            const SizedBox(height: 10),
                            Text(
                              Enemy(
                                      x: 0,
                                      y: 0,
                                      type: currentEnemyType,
                                      speed: 0)
                                  .name,
                              style: const TextStyle(
                                  color: Colors.greenAccent,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                if (showInstructions)
                  Container(
                    color: Colors.black.withOpacity(0.85),
                    child: Center(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        child: Container(
                          constraints: BoxConstraints(
                            maxWidth:
                                isLandscape ? screenSize.width * 0.7 : 400,
                          ),
                          margin: const EdgeInsets.symmetric(horizontal: 25),
                          padding: EdgeInsets.all(isLandscape ? 16 : 25),
                          decoration: BoxDecoration(
                            color: const Color(0xFF3B1578),
                            borderRadius: BorderRadius.circular(30),
                            border: Border.all(
                                color: Colors.amberAccent, width: 3),
                            boxShadow: const [
                              BoxShadow(
                                  color: Colors.purpleAccent, blurRadius: 15)
                            ],
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.stars,
                                  color: Colors.amberAccent,
                                  size: isLandscape ? 34 : 50),
                              const SizedBox(height: 8),
                              Text(
                                'COMMENT JOUER ?',
                                style: TextStyle(
                                    fontSize: isLandscape ? 20 : 26,
                                    fontWeight: FontWeight.w900,
                                    color: Colors.amberAccent),
                              ),
                              SizedBox(height: isLandscape ? 12 : 20),
                              Text(
                                '👉 Glisse ton doigt pour déplacer le canon.\n\n💥 Tape sur l\'écran pour tirer !\n\n⭐ Attrape les étoiles bonus.\n\n🛡️ Ne laisse pas les ennemis toucher le sol !',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: isLandscape ? 13 : 16,
                                    color: Colors.white,
                                    height: 1.4),
                              ),
                              SizedBox(height: isLandscape ? 16 : 25),
                              ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    showInstructions = false;
                                    for (int i = 0; i < 3; i++) {
                                      addEnemy();
                                    }
                                  });
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.greenAccent,
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 35,
                                      vertical: isLandscape ? 10 : 12),
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(20)),
                                ),
                                child: Text('C\'EST PARTI !',
                                    style: TextStyle(
                                        fontSize: isLandscape ? 16 : 20,
                                        fontWeight: FontWeight.w900,
                                        color: Colors.black)),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                if (gameOver)
                  Container(
                    color: Colors.black.withOpacity(0.92),
                    child: Center(
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text('GAME OVER',
                                style: TextStyle(
                                    color: Colors.redAccent,
                                    fontSize: isLandscape ? 32 : 44,
                                    fontWeight: FontWeight.w900)),
                            const SizedBox(height: 10),
                            Text('Score : $score',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: isLandscape ? 18 : 24)),
                            SizedBox(height: isLandscape ? 18 : 30),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                ElevatedButton(
                                  onPressed: startGame,
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.greenAccent),
                                  child: const Text('REJOUER',
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold)),
                                ),
                                const SizedBox(width: 15),
                                OutlinedButton(
                                  onPressed: () => Navigator.of(context).pop(),
                                  style: OutlinedButton.styleFrom(
                                    side: const BorderSide(
                                        color: Colors.white70),
                                  ),
                                  child: const Text('MENU',
                                      style: TextStyle(
                                          color: Colors.white70,
                                          fontSize: 18)),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ------------------- WIDGETS DE DESSIN ENNEMIS ET CANON -------------------
class EnemyWidget extends StatelessWidget {
  final EnemyType type;
  final double size;
  const EnemyWidget({super.key, required this.type, this.size = 60});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: size,
        height: size,
        child: CustomPaint(painter: EnemyPainter(type: type)));
  }
}

class EnemyPainter extends CustomPainter {
  final EnemyType type;
  EnemyPainter({required this.type});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    switch (type) {
      case EnemyType.alien:
        paint.color = Colors.greenAccent;
        canvas.drawCircle(Offset(size.width * 0.5, size.height * 0.4),
            size.width * 0.35, paint);
        paint.color = Colors.black;
        canvas.drawCircle(
            Offset(size.width * 0.38, size.height * 0.35), 4, paint);
        canvas.drawCircle(
            Offset(size.width * 0.62, size.height * 0.35), 4, paint);
        break;
      case EnemyType.bird:
        paint.color = Colors.orangeAccent;
        canvas.drawCircle(Offset(size.width * 0.5, size.height * 0.5),
            size.width * 0.3, paint);
        break;
      case EnemyType.dragon:
        paint.color = Colors.redAccent;
        canvas.drawCircle(Offset(size.width * 0.5, size.height * 0.5),
            size.width * 0.4, paint);
        break;
      default:
        paint.color = Colors.amberAccent;
        canvas.drawCircle(Offset(size.width * 0.5, size.height * 0.5),
            size.width * 0.38, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class CannonWidget extends StatelessWidget {
  final CannonSkin skin;
  const CannonWidget({super.key, required this.skin});

  @override
  Widget build(BuildContext context) {
    Color color;
    switch (skin) {
      case CannonSkin.pink:
        color = Colors.pinkAccent;
        break;
      case CannonSkin.gold:
        color = Colors.amberAccent;
        break;
      default:
        color = Colors.cyanAccent;
    }
    return SizedBox(
      width: 60,
      height: 50,
      child: CustomPaint(painter: CannonPainter(color: color)),
    );
  }
}

class CannonPainter extends CustomPainter {
  final Color color;
  CannonPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.fill
      ..color = color;
    canvas.drawRRect(
        RRect.fromRectAndRadius(
            Rect.fromLTWH(0, size.height * 0.5, size.width, size.height * 0.5),
            const Radius.circular(8)),
        paint);
    canvas.drawRect(
        Rect.fromLTWH(
            size.width * 0.38, 0, size.width * 0.24, size.height * 0.6),
        paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}