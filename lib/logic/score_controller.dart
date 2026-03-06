import 'dart:async';
import 'package:flutter/material.dart';
import 'package:watten_auswertung/models/game_state.dart';
import 'package:watten_auswertung/logic/storage_manager.dart';

class ScoreController extends ChangeNotifier {
  final StorageManager storage;

  GameState state = GameState.initial();

  Timer? autosaveTimer;
  bool autosaveEnabled = true;

  ScoreController({required this.storage}) {
    _init();
  }

  Future<void> _init() async {
    final loaded = await storage.loadState();
    if (loaded != null) {
      state = loaded;
    }
    _startAutosave();
    notifyListeners();
  }

  void _startAutosave() {
    autosaveTimer?.cancel();
    autosaveTimer = Timer.periodic(const Duration(seconds: 5), (_) {
      if (autosaveEnabled) {
        storage.saveState(state);
      }
    });
  }

  // ------------------------------------------------------------
  // Punkte-Logik
  // ------------------------------------------------------------

  void addPointTeam1() {
    state.team1Points++;
    _checkRoundEnd();
    notifyListeners();
  }

  void addPointTeam2() {
    state.team2Points++;
    _checkRoundEnd();
    notifyListeners();
  }

  void removePointTeam1() {
    if (state.team1Points > 0) {
      state.team1Points--;
      notifyListeners();
    }
  }

  void removePointTeam2() {
    if (state.team2Points > 0) {
      state.team2Points--;
      notifyListeners();
    }
  }

  // ------------------------------------------------------------
  // Runden-Logik
  // ------------------------------------------------------------

  void _checkRoundEnd() {
    if (state.team1Points >= state.pointsToWin) {
      state.team1Rounds++;
      _resetPoints();
    } else if (state.team2Points >= state.pointsToWin) {
      state.team2Rounds++;
      _resetPoints();
    }
  }

  void _resetPoints() {
    state.team1Points = 0;
    state.team2Points = 0;
  }

  // ------------------------------------------------------------
  // Spiel-Reset
  // ------------------------------------------------------------

  void resetGame() {
    state = GameState.initial();
    notifyListeners();
  }

  // ------------------------------------------------------------
  // Einstellungen
  // ------------------------------------------------------------

  void setPointsToWin(int value) {
    state.pointsToWin = value;
    notifyListeners();
  }

  void setTeamNames(String t1, String t2) {
    state.team1Name = t1;
    state.team2Name = t2;
    notifyListeners();
  }

  // ------------------------------------------------------------
  // Speichern / Laden
  // ------------------------------------------------------------

  Future<void> save() async {
    await storage.saveState(state);
  }

  Future<void> load() async {
    final loaded = await storage.loadState();
    if (loaded != null) {
      state = loaded;
      notifyListeners();
    }
  }

  Future<void> clear() async {
    await storage.clear();
    state = GameState.initial();
    notifyListeners();
  }

  // ------------------------------------------------------------
  // Historie
  // ------------------------------------------------------------

  void addHistoryEntry(String text) {
    state.history.add(text);
    notifyListeners();
  }

  void clearHistory() {
    state.history.clear();
    notifyListeners();
  }

  // ------------------------------------------------------------
  // PDF / Auswertung
  // ------------------------------------------------------------

  Map<String, dynamic> exportForPdf() {
    return {
      "team1": state.team1Name,
      "team2": state.team2Name,
      "points1": state.team1Points,
      "points2": state.team2Points,
      "rounds1": state.team1Rounds,
      "rounds2": state.team2Rounds,
      "history": List<String>.from(state.history),
    };
  }

  // ------------------------------------------------------------
  // Dispose
  // ------------------------------------------------------------

  @override
  void dispose() {
    autosaveTimer?.cancel();
    super.dispose();
  }
}
