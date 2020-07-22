import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';

class ConfettiShooter extends StatefulWidget {
  final Function setBlastAway;
  ConfettiShooter({this.setBlastAway});
  @override
  _ConfettiShooter createState() => _ConfettiShooter(setBlastAway);
}

class _ConfettiShooter extends State<ConfettiShooter> {
  static const DURAITON = 3;

  ConfettiController majorLazer;

  _ConfettiShooter(Function setBlastAway) {
    setBlastAway(blastAway);
  }

  void blastAway() {
    majorLazer.play();
  }

  @override
  void initState() {
    majorLazer = ConfettiController(
      duration: const Duration(seconds: DURAITON)
    );
    super.initState();
  }

  @override
  void dispose() {
    majorLazer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ConfettiWidget(
      confettiController: majorLazer,
      blastDirectionality: BlastDirectionality.explosive,
      emissionFrequency: 0.08,
      numberOfParticles: 25,
      shouldLoop: false,
      maxBlastForce: 20,
      minBlastForce: 10,
      displayTarget: false,
      colors: [
        Color(0xff1d1ae8),
        Color(0xffeb891a),
        Color(0xfffcec03),
        Color(0xFF90CAF9),
        Color(0xFFFFA726),
      ],
    );
  }
}
