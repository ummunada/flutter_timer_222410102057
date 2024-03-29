import 'dart:async';
import 'package:flutter/material.dart';

void main() {
  runApp(TimerApp());
}

class TimerApp extends StatefulWidget {
  @override
  _TimerAppState createState() => _TimerAppState();
}

class _TimerAppState extends State<TimerApp> {
  int _minutes = 0;
  int _seconds = 0;
  bool _isRunning = false;
  Timer? _timer;
  TextEditingController _minutesController = TextEditingController();

  void _startTimer() {
    if (!_isRunning) {
      int totalSeconds = (_minutes * 60) + _seconds;
      if (totalSeconds > 0) {
        setState(() {
          _isRunning = true;
          _timer = Timer.periodic(Duration(seconds: 1), (timer) {
            if (totalSeconds > 0) {
              setState(() {
                totalSeconds--;
                _minutes = totalSeconds ~/ 60;
                _seconds = totalSeconds % 60;
              });
            } else {
              _stopTimer();
            }
          });
        });
      } else {
        _restartTimer();
      }
    }
  }

  void _stopTimer() {
    if (_isRunning) {
      setState(() {
        _isRunning = false;
        _timer?.cancel();
      });
    }
  }

  void _restartTimer() {
    _stopTimer();
    setState(() {
      _minutes = int.tryParse(_minutesController.text) ?? 0;
      _seconds = 0;
    });
    _startTimer();
  }

  @override
  void dispose() {
    _stopTimer();
    _minutesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String formattedMinutes = _minutes.toString().padLeft(2, '0');
    String formattedSeconds = _seconds.toString().padLeft(2, '0');

    return MaterialApp(
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.blue[200],
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text(
            'Timer App',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.blue[400],
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 20),
              Text(
                "Ummu Ni'matun Nada - 222410102057",
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
              SizedBox(height: 20),
              TimerWidget(
                formattedMinutes: formattedMinutes,
                formattedSeconds: formattedSeconds,
                startTimer: _startTimer,
                stopTimer: _stopTimer,
                restartTimer: _restartTimer,
              ),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: TextField(
                  controller: _minutesController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Input Minutes',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TimerWidget extends StatelessWidget {
  final String formattedMinutes;
  final String formattedSeconds;
  final VoidCallback startTimer;
  final VoidCallback stopTimer;
  final VoidCallback restartTimer;

  TimerWidget({
    required this.formattedMinutes,
    required this.formattedSeconds,
    required this.startTimer,
    required this.stopTimer,
    required this.restartTimer,
  });

  @override
  Widget build(BuildContext context) {
    bool timeIsUp =
        int.parse(formattedMinutes) == 0 && int.parse(formattedSeconds) == 0;

    return Card(
      elevation: 4,
      color: Colors.blue[400],
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              'Timer',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 20),
            Text(
              timeIsUp
                  ? 'Waktu Habis!'
                  : ' $formattedMinutes : $formattedSeconds ',
              style: TextStyle(
                fontSize: 45,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  children: [
                    IconButton(
                      iconSize: 48,
                      icon: Icon(Icons.play_arrow),
                      onPressed: startTimer,
                      tooltip: 'Start',
                      color: Colors.white,
                    ),
                    Text(
                      'Start',
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
                SizedBox(width: 20),
                Column(
                  children: [
                    IconButton(
                      iconSize: 48,
                      icon: Icon(Icons.stop),
                      onPressed: stopTimer,
                      tooltip: 'Stop',
                      color: Colors.white,
                    ),
                    Text(
                      'Stop',
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
                SizedBox(width: 20),
                Column(
                  children: [
                    IconButton(
                      iconSize: 48,
                      icon: Icon(Icons.refresh),
                      onPressed: restartTimer,
                      tooltip: 'Restart',
                      color: Colors.white,
                    ),
                    Text(
                      'Restart',
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
