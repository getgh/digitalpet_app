import 'package:flutter/material.dart';
import 'dart:async';

void main() {
  runApp(MaterialApp(
    home: DigitalPetApp(),
  ));
}

class DigitalPetApp extends StatefulWidget {
  @override
  _DigitalPetAppState createState() => _DigitalPetAppState();
}

class _DigitalPetAppState extends State<DigitalPetApp> {
  String petName = "Your Pet";
  int happinessLevel = 50;
  int hungerLevel = 50;
  int energyLevel = 100;
  bool isNameSet = false;
  bool gameWon = false;
  bool gameLost = false;
  Timer? hungerTimer;
  Timer? winCheckTimer;
  Timer? happinessTimer;
  DateTime lastPlayTime = DateTime.now();
  TextEditingController nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // timer to + hunger and update the happiness
    hungerTimer = Timer.periodic(Duration(seconds: 30), (timer) {
      setState(() {
        hungerLevel = (hungerLevel + 5).clamp(0, 100);
        _updateHappiness();
        _checkWinLossCondition();
      });
    });

    // time to decrease happiness if user inactive
    happinessTimer = Timer.periodic(Duration(seconds: 20), (timer) {
      setState(() {
        final timeSinceLastPlay = DateTime.now().difference(lastPlayTime);
        if (timeSinceLastPlay.inSeconds > 30) {
          happinessLevel = (happinessLevel - 5).clamp(0, 100);
          _checkWinLossCondition();
        }
      });
    });

    // chkwin condition every 10s
    winCheckTimer = Timer.periodic(Duration(seconds: 10), (timer) {
      _checkWinLossCondition();
    });
  }

  @override
  void dispose() {
    hungerTimer?.cancel();
    winCheckTimer?.cancel();
    happinessTimer?.cancel();
    nameController.dispose();
    super.dispose();
  }

  Color _getPetColor() {
    if (happinessLevel > 70) return Colors.green;
    if (happinessLevel >= 30) return Colors.yellow;
    return Colors.red;
  }

  String _getMoodText() {
    if (happinessLevel > 70) return "Happy 😊";
    if (happinessLevel >= 30) return "Neutral 😐";
    return "Unhappy 😢";
  }

  void _increaseHunger() {
    setState(() {
      hungerLevel += 5;
      _updateHappiness();
      _checkWinLossCondition();
    });
  }

  void _checkWinLossCondition() {
    setState(() {
      // winning if happiness stays top and hunger stays low
      if (happinessLevel >= 80 && hungerLevel <= 30) {
        gameWon = true;
      }
      // lose
      if (hungerLevel >= 90 || happinessLevel <= 10) {
        gameLost = true;
      }
    });
  }

  void _playWithPet() {
    setState(() {
      if (energyLevel >= 10) {
        happinessLevel = (happinessLevel + 10).clamp(0, 100);
        energyLevel = (energyLevel - 10).clamp(0, 100);
        hungerLevel = (hungerLevel + 5).clamp(0, 100);
        lastPlayTime = DateTime.now();
        _checkWinLossCondition();
      }
    });
  }

  void _feedPet() {
    setState(() {
      hungerLevel = (hungerLevel - 10).clamp(0, 100);
      energyLevel = (energyLevel + 5).clamp(0, 100);
      happinessLevel = (happinessLevel + 10).clamp(0, 100);
      _checkWinLossCondition();
    });
  }

  void _updateHappiness() {
    if (hungerLevel > 80) {
      happinessLevel = (happinessLevel - 15).clamp(0, 100);
    } else if (hungerLevel < 30) {
      happinessLevel = (happinessLevel - 10).clamp(0, 100);
    }
  }

  void _updateHunger() {
    setState(() {
      hungerLevel = (hungerLevel + 5).clamp(0, 100);
      if (hungerLevel >= 90) {
        happinessLevel = (happinessLevel - 10).clamp(0, 100);
      }
      _checkWinLossCondition();
    });
  }

  @override
  Widget build(BuildContext context) {
    if (gameWon) {
      return _buildGameEndScreen("Congratulations! You Won! 🎉");
    }
    if (gameLost) {
      return _buildGameEndScreen("Game Over! Your pet needs more care 😢");
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Digital Pet'),
        backgroundColor: _getPetColor().withOpacity(0.7),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            if (!isNameSet) ...[
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: 'Enter Pet Name',
                  border: OutlineInputBorder(),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    if (nameController.text.isNotEmpty) {
                      petName = nameController.text;
                      isNameSet = true;
                    }
                  });
                },
                child: Text('Set Name'),
              ),
            ] else ...[
              Container(
                width: 200,
                height: 200,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Outer glow
                    Container(
                      width: 200,
                      height: 200,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _getPetColor().withOpacity(0.2),
                      ),
                    ),
                    Container(
                      width: 180,
                      height: 180,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: _getPetColor(),
                          width: 8,
                        ),
                      ),
                    ),
                    ClipOval(
                      child: Container(
                        width: 160,
                        height: 160,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: Image.asset(
                          'assets/images/img.png',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16.0),
              Text(
                petName,
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Mood: ${_getMoodText()}',
                style: TextStyle(fontSize: 20.0),
              ),
              SizedBox(height: 16.0),
              Text(
                'Happiness Level: $happinessLevel',
                style: TextStyle(fontSize: 20.0),
              ),
              LinearProgressIndicator(
                value: happinessLevel / 100,
                backgroundColor: Colors.grey[300],
                valueColor: AlwaysStoppedAnimation<Color>(_getPetColor()),
              ),
              SizedBox(height: 16.0),
              Text(
                'Hunger Level: $hungerLevel',
                style: TextStyle(fontSize: 20.0),
              ),
              LinearProgressIndicator(
                value: hungerLevel / 100,
                backgroundColor: Colors.grey[300],
                valueColor: AlwaysStoppedAnimation<Color>(Colors.orange),
              ),
              SizedBox(height: 16.0),
              Text(
                'Energy Level: $energyLevel',
                style: TextStyle(fontSize: 20.0),
              ),
              LinearProgressIndicator(
                value: energyLevel / 100,
                backgroundColor: Colors.grey[300],
                valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
              ),
              SizedBox(height: 32.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: _playWithPet,
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.green),
                      padding: MaterialStateProperty.all(
                        EdgeInsets.symmetric(horizontal: 32.0, vertical: 16.0),
                      ),
                    ),
                    child: Text('Play'),
                  ),
                  SizedBox(width: 16.0),
                  ElevatedButton(
                    onPressed: _feedPet,
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.orange),
                      padding: MaterialStateProperty.all(
                        EdgeInsets.symmetric(horizontal: 32.0, vertical: 16.0),
                      ),
                    ),
                    child: Text('Feed'),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildGameEndScreen(String message) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              message,
              style: TextStyle(fontSize: 24.0),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  happinessLevel = 50;
                  hungerLevel = 50;
                  energyLevel = 100;
                  gameWon = false;
                  gameLost = false;
                  isNameSet = false;
                  nameController.clear();
                });
              },
              child: Text('Play Again'),
            ),
          ],
        ),
      ),
    );
  }
}
