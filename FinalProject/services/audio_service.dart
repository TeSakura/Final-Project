import 'package:audioplayers/audioplayers.dart';

class AudioService {
  static final AudioService _instance = AudioService._internal();
  factory AudioService() => _instance;
  AudioService._internal();

  final AudioPlayer _player = AudioPlayer();
  bool _soundEnabled = true;
  bool _musicEnabled = true;

  // Sound files would be in assets/audio/
  final Map<String, String> _soundPaths = {
    'click': 'assets/audio/click.mp3',
    'correct': 'assets/audio/correct.mp3',
    'wrong': 'assets/audio/wrong.mp3',
    'flip': 'assets/audio/flip.mp3',
    'win': 'assets/audio/win.mp3',
    'note_do': 'assets/audio/note_do.mp3',
    'note_re': 'assets/audio/note_re.mp3',
    'note_mi': 'assets/audio/note_mi.mp3',
    'note_fa': 'assets/audio/note_fa.mp3',
    'note_sol': 'assets/audio/note_sol.mp3',
  };

  void initialize() async {
    // Preload sounds if needed
  }

  void playSound(String soundName) async {
    if (!_soundEnabled) return;

    try {
      await _player.play(AssetSource(_soundPaths[soundName]!));
    } catch (e) {
      print('Error playing sound: $e');
    }
  }

  void playNote(String noteName) {
    playSound('note_${noteName.toLowerCase()}');
  }

  void toggleSound(bool enabled) {
    _soundEnabled = enabled;
  }

  void toggleMusic(bool enabled) {
    _musicEnabled = enabled;
    if (!enabled) {
      _player.stop();
    }
  }

  bool get isSoundEnabled => _soundEnabled;
  bool get isMusicEnabled => _musicEnabled;

  void dispose() {
    _player.dispose();
  }
}
