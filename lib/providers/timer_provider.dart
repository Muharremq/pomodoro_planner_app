import 'package:flutter/foundation.dart';

class TimerProvider with ChangeNotifier {
  int remainingTime = 25 * 60;

  void startTimer() {
    print("Zamanlayici başlatildi (henüz mantik yok).");
  }

  void pauseTimer() {
    // TODO: Zamanlayıcıyı duraklatma mantığı buraya gelecek.
    print("Zamanlayici duraklatildi (henüz mantik yok).");
  }

  void resetTimer() {
    // TODO: Zamanlayıcıyı sıfırlama mantığı buraya gelecek.
    print("Zamanlayici sifirlandi (henüz mantik yok).");
  }
}
