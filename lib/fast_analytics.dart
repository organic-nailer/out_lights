import 'package:firebase_analytics/firebase_analytics.dart';

class FastAnalytics {
  static void screenOpened(String name) async {
    await FirebaseAnalytics.instance.setCurrentScreen(screenName: name);
  }

  static void sendGameOver(int step, int score) async {
    await FirebaseAnalytics.instance.logEvent(
        name: "game_over", parameters: {"step": step, "score": score});
  }

  static void sendStartStep(
      int step, int size, int lost, String filterName) async {
    await FirebaseAnalytics.instance.logEvent(name: "start_step", parameters: {
      "step": step,
      "size": size,
      "lost": lost,
      "filter": filterName
    });
  }
}
