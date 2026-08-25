import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppSettings {
  AppSettings({
    this.musicOn = true,
    this.sfxOn = true,
    this.vibrationOn = true,
    this.bestScore = 0,
    this.bestLevel = 1,
  });

  bool musicOn;
  bool sfxOn;
  bool vibrationOn;
  int bestScore;
  int bestLevel;

  Map<String, dynamic> toJson() => {
        'musicOn': musicOn,
        'sfxOn': sfxOn,
        'vibrationOn': vibrationOn,
        'bestScore': bestScore,
        'bestLevel': bestLevel,
      };

  static AppSettings fromJson(Map<String, dynamic> json) {
    return AppSettings(
      musicOn: json['musicOn'] as bool? ?? true,
      sfxOn: json['sfxOn'] as bool? ?? true,
      vibrationOn: json['vibrationOn'] as bool? ?? true,
      bestScore: json['bestScore'] as int? ?? 0,
      bestLevel: json['bestLevel'] as int? ?? 1,
    );
  }
}

class SettingsStore {
  static const _key = 'boncompte_settings';

  static Future<AppSettings> load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key);
    if (raw == null) return AppSettings();

    try {
      return AppSettings.fromJson(
        jsonDecode(raw) as Map<String, dynamic>,
      );
    } catch (_) {
      return AppSettings();
    }
  }

  static Future<void> save(AppSettings settings) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, jsonEncode(settings.toJson()));
  }
}

class BonCompteHomeScreen extends StatefulWidget {
  const BonCompteHomeScreen({super.key});

  @override
  State<BonCompteHomeScreen> createState() => _BonCompteHomeScreenState();
}

class _BonCompteHomeScreenState extends State<BonCompteHomeScreen> {
  AppSettings _settings = AppSettings();
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final settings = await SettingsStore.load();
    if (!mounted) return;
    setState(() {
      _settings = settings;
      _loading = false;
    });
  }

  Future<void> _openSettings() async {
    final updated = await Navigator.of(context).push<AppSettings>(
      MaterialPageRoute(
        builder: (_) => BonCompteSettingsScreen(settings: _settings),
      ),
    );

    if (updated != null && mounted) {
      setState(() => _settings = updated);
      await SettingsStore.save(_settings);
    }
  }

  Future<void> _openRules() async {
    await showDialog<void>(
      context: context,
      builder: (_) => const _BonCompteRulesDialog(),
    );
  }

  Future<void> _play() async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => BonCompteGameScreen(settings: _settings),
      ),
    );
    if (mounted) {
      _settings = await SettingsStore.load();
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      body: _BonCompteBackground(
        child: SafeArea(
          child: Stack(
            children: [
              Positioned(
                top: 4,
                left: 4,
                child: IconButton(
                  icon: const Icon(Icons.arrow_back_rounded,
                      color: Colors.white70),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
              Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 520),
                    child: Column(
                      children: [
                        const SizedBox(height: 20),
                        _buildLogo(),
                        const SizedBox(height: 18),
                        const Text(
                          'DÉFIE TON CALCUL MENTAL',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 12,
                            letterSpacing: 2.4,
                            color: Colors.white54,
                            fontWeight: FontWeight.w800,
                            decoration: TextDecoration.none,
                          ),
                        ),
                        const SizedBox(height: 36),
                        _buildBestCard(),
                        const SizedBox(height: 24),
                        _buildPlayButton(),
                        const SizedBox(height: 12),
                        _buildSecondaryButtons(),
                        const SizedBox(height: 28),
                        Text(
                          'BonCompte • Jeu de calcul mental',
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: .28),
                            fontSize: 11,
                            decoration: TextDecoration.none,
                          ),
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
    );
  }

  Widget _buildLogo() {
    return Column(
      children: [
        Container(
          width: 102,
          height: 102,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFFFFE082),
                Color(0xFFFFB300),
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFFFD54F).withValues(alpha: .22),
                blurRadius: 30,
                spreadRadius: 5,
              ),
            ],
          ),
          child: const Icon(
            Icons.calculate_rounded,
            color: Color(0xFF16473F),
            size: 55,
          ),
        ).animate().scale(
              duration: 700.ms,
              curve: Curves.elasticOut,
            ),
        const SizedBox(height: 18),
        const Text(
          'BONCOMPTE',
          style: TextStyle(
            fontSize: 34,
            fontWeight: FontWeight.w900,
            letterSpacing: 1.5,
            decoration: TextDecoration.none,
          ),
        ),
      ],
    );
  }

  Widget _buildBestCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: .07),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withValues(alpha: .10)),
      ),
      child: Row(
        children: [
          Container(
            width: 54,
            height: 54,
            decoration: BoxDecoration(
              color: const Color(0xFFFFD54F).withValues(alpha: .12),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.emoji_events_rounded,
              color: Color(0xFFFFD54F),
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'MEILLEURE PERFORMANCE',
                  style: TextStyle(
                    color: Colors.white54,
                    fontSize: 10,
                    letterSpacing: 1.1,
                    fontWeight: FontWeight.w800,
                    decoration: TextDecoration.none,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  '${_settings.bestScore} point${_settings.bestScore.abs() > 1 ? 's' : ''}',
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                    decoration: TextDecoration.none,
                  ),
                ),
              ],
            ),
          ),
          Text(
            'Niv. ${_settings.bestLevel}',
            style: const TextStyle(
              color: Color(0xFFFFD54F),
              fontSize: 18,
              fontWeight: FontWeight.w900,
              decoration: TextDecoration.none,
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 450.ms).slideY(begin: .08, end: 0);
  }

  Widget _buildPlayButton() {
    return SizedBox(
      width: double.infinity,
      height: 62,
      child: FilledButton.icon(
        onPressed: _play,
        icon: const Icon(Icons.play_arrow_rounded, size: 29),
        label: const Text(
          'JOUER',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w900,
            letterSpacing: 1,
            decoration: TextDecoration.none,
          ),
        ),
        style: FilledButton.styleFrom(
          backgroundColor: const Color(0xFFFFD54F),
          foregroundColor: const Color(0xFF173A34),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),
      ),
    ).animate().fadeIn(delay: 120.ms, duration: 350.ms).slideY(begin: .15);
  }

  Widget _buildSecondaryButtons() {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: _openRules,
            icon: const Icon(Icons.help_outline_rounded),
            label: const Text('COMMENT JOUER'),
            style: OutlinedButton.styleFrom(
              minimumSize: const Size.fromHeight(50),
              foregroundColor: Colors.white,
              side: BorderSide(color: Colors.white.withValues(alpha: .16)),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        IconButton(
          onPressed: _openSettings,
          tooltip: 'Paramètres',
          style: IconButton.styleFrom(
            minimumSize: const Size(50, 50),
            backgroundColor: Colors.white.withValues(alpha: .08),
          ),
          icon: const Icon(Icons.settings_rounded),
        ),
      ],
    );
  }
}

class BonCompteSettingsScreen extends StatefulWidget {
  const BonCompteSettingsScreen({super.key, required this.settings});

  final AppSettings settings;

  @override
  State<BonCompteSettingsScreen> createState() =>
      _BonCompteSettingsScreenState();
}

class _BonCompteSettingsScreenState extends State<BonCompteSettingsScreen> {
  late AppSettings _settings;

  @override
  void initState() {
    super.initState();
    _settings = AppSettings(
      musicOn: widget.settings.musicOn,
      sfxOn: widget.settings.sfxOn,
      vibrationOn: widget.settings.vibrationOn,
      bestScore: widget.settings.bestScore,
      bestLevel: widget.settings.bestLevel,
    );
  }

  Future<void> _save() async {
    await SettingsStore.save(_settings);
    if (mounted) Navigator.of(context).pop(_settings);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: _BonCompteBackground(
        child: SafeArea(
          child: Column(
            children: [
              _BonCompteSimpleAppBar(
                title: 'PARAMÈTRES',
                onBack: _save,
              ),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(20),
                  children: [
                    _settingsSection(
                      'SON ET CONFORT',
                      [
                        _BonCompteSettingTile(
                          icon: Icons.music_note_rounded,
                          title: 'Musique',
                          subtitle: 'Musique de fond pendant la partie',
                          value: _settings.musicOn,
                          onChanged: (v) =>
                              setState(() => _settings.musicOn = v),
                        ),
                        _BonCompteSettingTile(
                          icon: Icons.volume_up_rounded,
                          title: 'Effets sonores',
                          subtitle: 'Sons de réussite et d\'interaction',
                          value: _settings.sfxOn,
                          onChanged: (v) =>
                              setState(() => _settings.sfxOn = v),
                        ),
                        _BonCompteSettingTile(
                          icon: Icons.vibration_rounded,
                          title: 'Vibration',
                          subtitle: 'Retour tactile lors des actions',
                          value: _settings.vibrationOn,
                          onChanged: (v) =>
                              setState(() => _settings.vibrationOn = v),
                        ),
                      ],
                    ),
                    const SizedBox(height: 22),
                    _settingsSection(
                      'STATISTIQUES',
                      [
                        _BonCompteInfoTile(
                          icon: Icons.star_rounded,
                          title: 'Meilleur score',
                          value: '${_settings.bestScore}',
                        ),
                        _BonCompteInfoTile(
                          icon: Icons.layers_rounded,
                          title: 'Meilleur niveau',
                          value: '${_settings.bestLevel}',
                        ),
                      ],
                    ),
                    const SizedBox(height: 22),
                    OutlinedButton.icon(
                      onPressed: () async {
                        setState(() {
                          _settings.bestScore = 0;
                          _settings.bestLevel = 1;
                        });
                        await SettingsStore.save(_settings);
                      },
                      icon: const Icon(Icons.restart_alt_rounded),
                      label: const Text('RÉINITIALISER LES SCORES'),
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size.fromHeight(50),
                        foregroundColor: Colors.redAccent,
                        side: BorderSide(
                          color: Colors.redAccent.withValues(alpha: .3),
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
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

  Widget _settingsSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 11,
            letterSpacing: 1.3,
            color: Colors.white54,
            fontWeight: FontWeight.w800,
            decoration: TextDecoration.none,
          ),
        ),
        const SizedBox(height: 10),
        Container(
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: .06),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white.withValues(alpha: .08)),
          ),
          child: Column(children: children),
        ),
      ],
    );
  }
}

class _BonCompteSettingTile extends StatelessWidget {
  const _BonCompteSettingTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
      secondary: Icon(icon, color: const Color(0xFFFFD54F)),
      title: Text(
        title,
        style: const TextStyle(
            fontWeight: FontWeight.w800, decoration: TextDecoration.none),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          color: Colors.white.withValues(alpha: 0.45),
          fontSize: 12,
          decoration: TextDecoration.none,
        ),
      ),
      value: value,
      onChanged: onChanged,
      activeThumbColor: const Color(0xFFFFD54F),
      activeTrackColor: const Color(0xFF557C72),
    );
  }
}

class _BonCompteInfoTile extends StatelessWidget {
  const _BonCompteInfoTile({
    required this.icon,
    required this.title,
    required this.value,
  });

  final IconData icon;
  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: const Color(0xFFFFD54F)),
      title: Text(
        title,
        style: const TextStyle(
            fontWeight: FontWeight.w800, decoration: TextDecoration.none),
      ),
      trailing: Text(
        value,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w900,
          color: Color(0xFFFFD54F),
          decoration: TextDecoration.none,
        ),
      ),
    );
  }
}

class _BonCompteSimpleAppBar extends StatelessWidget {
  const _BonCompteSimpleAppBar({
    required this.title,
    required this.onBack,
  });

  final String title;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 10, 16, 8),
      child: Row(
        children: [
          IconButton(
            onPressed: onBack,
            icon: const Icon(Icons.arrow_back_rounded),
          ),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w900,
                letterSpacing: 1,
                decoration: TextDecoration.none,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BonCompteRulesDialog extends StatelessWidget {
  const _BonCompteRulesDialog();

  @override
  Widget build(BuildContext context) {
    return _BonCompteGameDialog(
      icon: Icons.school_rounded,
      iconColor: const Color(0xFFFFD54F),
      title: 'COMMENT JOUER ?',
      subtitle: 'Teste ta rapidité de calcul',
      message: '',
      primaryLabel: 'J\'AI COMPRIS',
      onPrimary: () => Navigator.of(context).pop(),
      content: const _BonCompteRulesContent(),
    );
  }
}

class _BonCompteBackground extends StatelessWidget {
  const _BonCompteBackground({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF00695C),
            Color(0xFF004D40),
            Color(0xFF002B26),
          ],
        ),
      ),
      child: child,
    );
  }
}

class BonCompteGameScreen extends StatefulWidget {
  const BonCompteGameScreen({super.key, required this.settings});

  final AppSettings settings;

  @override
  State<BonCompteGameScreen> createState() => _BonCompteGameScreenState();
}

class _BonCompteGameScreenState extends State<BonCompteGameScreen>
    with WidgetsBindingObserver, TickerProviderStateMixin {
  late AppSettings _settings;
  static const _musicUrl =
      'https://cdn.pixabay.com/download/audio/2022/05/27/'
      'audio_1808fbf07a.mp3?filename=lofi-study-112191.mp3';

  static const _successUrl =
      'https://cdn.pixabay.com/download/audio/2021/08/04/'
      'audio_bb630cc098.mp3?filename=success-fanfare-trumpets-6185.mp3';

  final Random _random = Random();
  final AudioPlayer _bgmPlayer = AudioPlayer();
  final AudioPlayer _sfxPlayer = AudioPlayer();

  Timer? _timer;

  int _level = 1;
  int _score = 0;
  int _targetSum = 16;
  int _secondsRemaining = 45;
  int _totalSeconds = 45;

  List<int> _allNumbers = [];
  List<int?> _selectedSlots = [null, null, null];

  bool _isMusicOn = true;
  bool _isError = false;
  bool _isPaused = false;
  bool _isChecking = false;

  double get _timeProgress =>
      _totalSeconds == 0 ? 0 : _secondsRemaining / _totalSeconds;

  @override
  void initState() {
    _settings = widget.settings;
    _isMusicOn = _settings.musicOn;
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initializeAudio();
    _startNewLevel();
  }

  Future<void> _initializeAudio() async {
    try {
      await _bgmPlayer.setReleaseMode(ReleaseMode.loop);
      await _bgmPlayer.setVolume(0.025);

      if (_isMusicOn) {
        await _bgmPlayer.play(UrlSource(_musicUrl));
      }
    } catch (_) {}
  }

  Future<void> _toggleMusic() async {
    setState(() => _isMusicOn = !_isMusicOn);

    try {
      if (_isMusicOn) {
        await _bgmPlayer.resume();
      } else {
        await _bgmPlayer.pause();
      }
    } catch (_) {}
  }

  int _durationForLevel(int level) {
    return max(20, 45 - ((level - 1) * 2));
  }

  void _startNewLevel() {
    _timer?.cancel();

    final total = _durationForLevel(_level);
    final maxValue = 12 + (_level * 8);
    final values = <int>{};

    while (values.length < 8) {
      values.add(_random.nextInt(maxValue) + 1);
    }

    final numbers = values.toList()..shuffle(_random);
    final solution = [...numbers]..shuffle(_random);
    final target = solution[0] + solution[1] + solution[2];

    if (!mounted) return;

    setState(() {
      _allNumbers = numbers;
      _targetSum = target;
      _selectedSlots = [null, null, null];
      _isError = false;
      _isChecking = false;
      _isPaused = false;
      _totalSeconds = total;
      _secondsRemaining = total;
    });

    _startTimer();
  }

  void _startTimer() {
    _timer?.cancel();
    if (_isPaused) return;

    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;

      if (_secondsRemaining <= 1) {
        _timer?.cancel();
        setState(() => _secondsRemaining = 0);
        _handleTimeOut();
        return;
      }

      setState(() => _secondsRemaining--);
    });
  }

  void _pauseTimer() {
    _timer?.cancel();
  }

  void _resumeTimer() {
    if (!_isPaused) return;
    setState(() => _isPaused = false);
    _startTimer();
  }

  void _selectNumber(int number) {
    if (_isChecking || _isPaused) return;

    final emptyIndex = _selectedSlots.indexOf(null);
    if (emptyIndex == -1) return;

    setState(() {
      _selectedSlots[emptyIndex] = number;
      _isError = false;
    });
    if (_settings.vibrationOn) HapticFeedback.selectionClick();

    if (!_selectedSlots.contains(null)) {
      _verifySolution();
    }
  }

  void _deselectNumber(int index) {
    if (_isChecking || _isPaused) return;
    if (_selectedSlots[index] == null) return;

    setState(() {
      _selectedSlots[index] = null;
      _isError = false;
    });
  }

  Future<void> _verifySolution() async {
    if (_isChecking) return;

    final sum = _selectedSlots.fold<int>(
      0,
      (total, value) => total + (value ?? 0),
    );

    if (sum == _targetSum) {
      _isChecking = true;
      _pauseTimer();

      setState(() {
        _score += _level;
        if (_score > _settings.bestScore) {
          _settings.bestScore = _score;
        }
      });
      if (_level > _settings.bestLevel) _settings.bestLevel = _level;
      await SettingsStore.save(_settings);

      await _playSuccessSound();
      if (!mounted) return;

      await _showBravoDialog();
    } else {
      setState(() {
        _isError = true;
      });
      if (_settings.vibrationOn) HapticFeedback.mediumImpact();

      await Future<void>.delayed(const Duration(milliseconds: 550));
      if (!mounted) return;

      setState(() => _selectedSlots = [null, null, null]);
    }
  }

  Future<void> _playSuccessSound() async {
    if (!_isMusicOn || !_settings.sfxOn) return;

    try {
      await _sfxPlayer.setVolume(0.35);
      await _sfxPlayer.play(UrlSource(_successUrl));
    } catch (_) {}
  }

  void _handleTimeOut() {
    if (_isChecking || !mounted) return;

    setState(() {
      _score--;
      _isChecking = true;
    });

    _showTimeOutDialog();
  }

  Future<void> _showBravoDialog() async {
    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return _BonCompteGameDialog(
          icon: Icons.emoji_events_rounded,
          iconColor: const Color(0xFFFFD54F),
          title: 'Excellent !',
          subtitle: '+$_level point${_level > 1 ? 's' : ''}',
          message:
              'Tu viens de réussir le niveau $_level.\n'
              'Ton score est maintenant de $_score point${_score.abs() > 1 ? 's' : ''}.',
          primaryLabel: 'NIVEAU SUIVANT',
          onPrimary: () {
            Navigator.of(context).pop();
            if (!mounted) return;

            setState(() => _level++);
            _startNewLevel();
          },
        );
      },
    );
  }

  Future<void> _showTimeOutDialog() async {
    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return _BonCompteGameDialog(
          icon: Icons.timer_off_rounded,
          iconColor: Colors.redAccent,
          title: 'Temps écoulé',
          subtitle: '-1 point',
          message:
              'Le temps est terminé.\n'
              'Ne te décourage pas : essaie encore !',
          primaryLabel: 'RÉESSAYER',
          onPrimary: () {
            Navigator.of(context).pop();
            _startNewLevel();
          },
        );
      },
    );
  }

  Future<void> _showRulesDialog() async {
    _pauseTimer();
    setState(() => _isPaused = true);

    await showDialog<void>(
      context: context,
      builder: (context) {
        return _BonCompteGameDialog(
          icon: Icons.school_rounded,
          iconColor: const Color(0xFFFFD54F),
          title: 'Comment jouer ?',
          subtitle: 'Le principe est simple',
          message: '',
          primaryLabel: 'J\'AI COMPRIS',
          onPrimary: () {
            Navigator.of(context).pop();
            if (mounted) _resumeTimer();
          },
          content: const _BonCompteRulesContent(),
        );
      },
    );
  }

  Future<void> _showPauseDialog() async {
    _pauseTimer();
    setState(() => _isPaused = true);

    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return _BonCompteGameDialog(
          icon: Icons.pause_circle_filled_rounded,
          iconColor: const Color(0xFFFFD54F),
          title: 'Jeu en pause',
          subtitle: 'Ton niveau est conservé',
          message: '',
          primaryLabel: 'CONTINUER',
          onPrimary: () {
            Navigator.of(context).pop();
            if (mounted) _resumeTimer();
          },
          secondaryLabel: 'RECOMMENCER',
          onSecondary: () {
            Navigator.of(context).pop();
            _startNewLevel();
          },
        );
      },
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.inactive ||
        state == AppLifecycleState.paused) {
      _pauseTimer();
    } else if (state == AppLifecycleState.resumed &&
        !_isPaused &&
        !_isChecking &&
        _secondsRemaining > 0) {
      _startTimer();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _timer?.cancel();
    _bgmPlayer.dispose();
    _sfxPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _BonCompteBackground(
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final compact = constraints.maxHeight < 650;

              return Column(
                children: [
                  _buildHeader(),
                  Expanded(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      padding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: compact ? 8 : 18,
                      ),
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 700),
                        child: Column(
                          children: [
                            _buildStats(),
                            SizedBox(height: compact ? 12 : 22),
                            _buildChallengeCard(),
                            SizedBox(height: compact ? 14 : 24),
                            _buildNumberPad(),
                            SizedBox(height: compact ? 12 : 24),
                            _buildBottomActions(),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 12, 0),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.14),
              ),
            ),
            child: const Icon(
              Icons.calculate_rounded,
              color: Color(0xFFFFD54F),
            ),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'BONCOMPTE',
                  style: TextStyle(
                    fontSize: 20,
                    letterSpacing: 1.2,
                    fontWeight: FontWeight.w900,
                    decoration: TextDecoration.none,
                  ),
                ),
                Text(
                  'Défie ton calcul mental',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white60,
                    fontWeight: FontWeight.w500,
                    decoration: TextDecoration.none,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            tooltip: _isMusicOn ? 'Couper le son' : 'Activer le son',
            onPressed: _toggleMusic,
            style: IconButton.styleFrom(
              backgroundColor: Colors.white.withValues(alpha: 0.10),
            ),
            icon: Icon(
              _isMusicOn
                  ? Icons.volume_up_rounded
                  : Icons.volume_off_rounded,
            ),
          ),
          const SizedBox(width: 4),
          IconButton(
            tooltip: 'Pause',
            onPressed: _isChecking ? null : _showPauseDialog,
            style: IconButton.styleFrom(
              backgroundColor: Colors.white.withValues(alpha: 0.10),
            ),
            icon: const Icon(Icons.pause_rounded),
          ),
        ],
      ),
    );
  }

  Widget _buildStats() {
    return Row(
      children: [
        Expanded(
          child: _BonCompteStatCard(
            icon: Icons.layers_rounded,
            label: 'NIVEAU',
            value: '$_level',
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _BonCompteStatCard(
            icon: Icons.star_rounded,
            label: 'SCORE',
            value: '$_score',
            accent: const Color(0xFFFFD54F),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _BonCompteStatCard(
            icon: Icons.timer_rounded,
            label: 'TEMPS',
            value: '${_secondsRemaining}s',
            accent: _secondsRemaining <= 5
                ? Colors.redAccent
                : Colors.white,
          ),
        ),
      ],
    ).animate().fadeIn(duration: 350.ms).slideY(begin: -0.08, end: 0);
  }

  Widget _buildChallengeCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 18, 16, 16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.075),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: Colors.white.withValues(alpha: 0.10)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.18),
            blurRadius: 25,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        children: [
          const Text(
            'TROUVE LA BONNE SOMME',
            style: TextStyle(
              fontSize: 12,
              letterSpacing: 1.5,
              color: Colors.white54,
              fontWeight: FontWeight.w800,
              decoration: TextDecoration.none,
            ),
          ),
          const SizedBox(height: 16),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildSlot(0),
                _operator('+'),
                _buildSlot(1),
                _operator('+'),
                _buildSlot(2),
                _operator('='),
                _buildTargetCircle(_targetSum),
              ],
            ),
          ),
          const SizedBox(height: 18),
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: LinearProgressIndicator(
              minHeight: 7,
              value: _timeProgress,
              backgroundColor: Colors.white.withValues(alpha: 0.08),
              valueColor: AlwaysStoppedAnimation<Color>(
                _secondsRemaining <= 5
                    ? Colors.redAccent
                    : const Color(0xFFFFD54F),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _isError
                ? 'Mauvaise combinaison — essaie encore'
                : 'Choisis exactement 3 nombres',
            style: TextStyle(
              color: _isError ? Colors.redAccent : Colors.white54,
              fontSize: 12,
              fontWeight: FontWeight.w600,
              decoration: TextDecoration.none,
            ),
          ),
        ],
      ),
    ).animate(key: ValueKey(_level)).fadeIn(duration: 300.ms).scale(
          begin: const Offset(.97, .97),
          end: const Offset(1, 1),
        );
  }

  Widget _operator(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w900,
          color: Colors.white70,
          decoration: TextDecoration.none,
        ),
      ),
    );
  }

  Widget _buildNumberPad() {
    return Column(
      children: [
        const Row(
          children: [
            Expanded(
              child: Text(
                'NOMBRES DISPONIBLES',
                style: TextStyle(
                  fontSize: 12,
                  letterSpacing: 1.2,
                  color: Colors.white54,
                  fontWeight: FontWeight.w800,
                  decoration: TextDecoration.none,
                ),
              ),
            ),
            Icon(
              Icons.touch_app_rounded,
              size: 17,
              color: Colors.white38,
            ),
          ],
        ),
        const SizedBox(height: 12),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _allNumbers.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 1,
          ),
          itemBuilder: (_, index) => _buildNumberButton(_allNumbers[index]),
        ),
      ],
    );
  }

  Widget _buildNumberButton(int number) {
    final selected = _selectedSlots.contains(number);

    return Semantics(
      button: true,
      label: selected ? '$number, sélectionné' : 'Choisir $number',
      child: GestureDetector(
        onTap: selected ? null : () => _selectNumber(number),
        child: Opacity(
          opacity: selected ? 0.0 : 1.0,
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xFFFFD54F),
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.20),
                width: 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.20),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Center(
              child: Text(
                '$number',
                style: const TextStyle(
                  fontSize: 23,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF174B43),
                  decoration: TextDecoration.none,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSlot(int index) {
    final value = _selectedSlots[index];

    Widget child = Container(
      width: 62,
      height: 62,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: value == null
            ? Colors.white.withValues(alpha: 0.055)
            : const Color(0xFF00796B),
        border: Border.all(
          color: _isError
              ? Colors.redAccent
              : value == null
                  ? Colors.white24
                  : const Color(0xFFB2DFDB),
          width: 3,
        ),
        boxShadow: value == null
            ? null
            : [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.18),
                  blurRadius: 12,
                  offset: const Offset(0, 5),
                ),
              ],
      ),
      child: Center(
        child: value == null
            ? const Icon(
                Icons.add_rounded,
                color: Colors.white30,
                size: 28,
              )
            : Text(
                '$value',
                style: TextStyle(
                  fontSize: 23,
                  fontWeight: FontWeight.w900,
                  color: _isError ? Colors.redAccent : Colors.white,
                  decoration: TextDecoration.none,
                ),
              ),
      ),
    );

    if (_isError) {
      child = child.animate().shake(
            duration: 350.ms,
            hz: 5,
          );
    }

    return GestureDetector(
      onTap: value == null ? null : () => _deselectNumber(index),
      child: child,
    );
  }

  Widget _buildTargetCircle(int target) {
    return Container(
      width: 62,
      height: 62,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFFFD54F),
            Color(0xFFFFB300),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFFFD54F).withValues(alpha: 0.20),
            blurRadius: 18,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Center(
        child: Text(
          '$target',
          style: const TextStyle(
            fontSize: 23,
            fontWeight: FontWeight.w900,
            color: Color(0xFF3D3100),
            decoration: TextDecoration.none,
          ),
        ),
      ),
    );
  }

  Widget _buildBottomActions() {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: _showRulesDialog,
            icon: const Icon(Icons.help_outline_rounded, size: 19),
            label: const Text('RÈGLES'),
            style: OutlinedButton.styleFrom(
              minimumSize: const Size.fromHeight(48),
              foregroundColor: Colors.white,
              side: BorderSide(color: Colors.white.withValues(alpha: 0.18)),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: FilledButton.icon(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.exit_to_app_rounded, size: 19),
            label: const Text('QUITTER'),
            style: FilledButton.styleFrom(
              minimumSize: const Size.fromHeight(48),
              backgroundColor: Colors.white.withValues(alpha: 0.10),
              foregroundColor: const Color(0xFFFFD54F),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _BonCompteStatCard extends StatelessWidget {
  const _BonCompteStatCard({
    required this.icon,
    required this.label,
    required this.value,
    this.accent = Colors.white,
  });

  final IconData icon;
  final String label;
  final String value;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.075),
        borderRadius: BorderRadius.circular(17),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: Row(
        children: [
          Icon(icon, size: 19, color: accent),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 9,
                    letterSpacing: .8,
                    color: Colors.white.withValues(alpha: 0.45),
                    fontWeight: FontWeight.w800,
                    decoration: TextDecoration.none,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w900,
                    color: accent,
                    decoration: TextDecoration.none,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _BonCompteGameDialog extends StatelessWidget {
  const _BonCompteGameDialog({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.message,
    required this.primaryLabel,
    required this.onPrimary,
    this.secondaryLabel,
    this.onSecondary,
    this.content,
  });

  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final String message;
  final String primaryLabel;
  final VoidCallback onPrimary;
  final String? secondaryLabel;
  final VoidCallback? onSecondary;
  final Widget? content;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: const Color(0xFF073B35),
      insetPadding: const EdgeInsets.symmetric(horizontal: 24),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(28),
        side: BorderSide(color: Colors.white.withValues(alpha: 0.10)),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(22, 26, 22, 18),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 68,
              height: 68,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: iconColor.withValues(alpha: 0.12),
                border: Border.all(
                  color: iconColor.withValues(alpha: 0.28),
                ),
              ),
              child: Icon(icon, size: 34, color: iconColor),
            ).animate().scale(
                  duration: 350.ms,
                  curve: Curves.elasticOut,
                ),
            const SizedBox(height: 16),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.w900,
                decoration: TextDecoration.none,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: iconColor,
                fontWeight: FontWeight.w800,
                decoration: TextDecoration.none,
              ),
            ),
            if (message.isNotEmpty) ...[
              const SizedBox(height: 14),
              Text(
                message,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white60,
                  height: 1.45,
                  fontSize: 14,
                  decoration: TextDecoration.none,
                ),
              ),
            ],
            if (content != null) ...[
              const SizedBox(height: 14),
              content!,
            ],
            const SizedBox(height: 20),
            if (secondaryLabel != null)
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: onSecondary,
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size.fromHeight(48),
                    foregroundColor: Colors.white70,
                    side: BorderSide(
                      color: Colors.white.withValues(alpha: 0.15),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: Text(secondaryLabel!),
                ),
              ),
            if (secondaryLabel != null) const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: onPrimary,
                style: FilledButton.styleFrom(
                  minimumSize: const Size.fromHeight(50),
                  backgroundColor: iconColor,
                  foregroundColor: const Color(0xFF173A34),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: Text(
                  primaryLabel,
                  style: const TextStyle(
                      fontWeight: FontWeight.w900,
                      decoration: TextDecoration.none),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BonCompteRulesContent extends StatelessWidget {
  const _BonCompteRulesContent();

  @override
  Widget build(BuildContext context) {
    const rules = [
      ('1', 'Une addition de 3 nombres est proposée.'),
      ('2', 'Choisis 3 nombres parmi les 8 nombres affichés.'),
      ('3', 'La somme doit être exactement égale au nombre cible.'),
      ('4',
          'Bonne réponse : +N points au niveau N et passage au niveau suivant.'),
      ('5', 'Temps écoulé : -1 point au score.'),
      ('6', 'Touche un nombre sélectionné en haut pour le retirer.'),
    ];

    return Column(
      children: rules
          .map(
            (rule) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 25,
                    height: 25,
                    alignment: Alignment.center,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xFFFFD54F),
                    ),
                    child: Text(
                      rule.$1,
                      style: const TextStyle(
                        color: Color(0xFF173A34),
                        fontWeight: FontWeight.w900,
                        fontSize: 12,
                        decoration: TextDecoration.none,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      rule.$2,
                      style: const TextStyle(
                        color: Colors.white70,
                        height: 1.35,
                        fontSize: 13,
                        decoration: TextDecoration.none,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
          .toList(),
    );
  }
}