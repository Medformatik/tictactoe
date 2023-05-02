import 'package:flutter/material.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Tic-Tac-Toe',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: const Home(),
    );
  }
}

enum PlayerType { none, x, o }

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final List<PlayerType> field = [];
  late PlayerType currentPlayer;

  void reset() {
    field.clear();
    currentPlayer = PlayerType.o;
    for (var i = 0; i < 9; i++) {
      field.add(PlayerType.none);
    }
  }

  void nextPlayer() {
    if (currentPlayer == PlayerType.o) {
      currentPlayer = PlayerType.x;
    } else {
      currentPlayer = PlayerType.o;
    }
  }

  bool checkWin() {
    List<List<int>> winningPositions = [
      [0, 1, 2], [3, 4, 5], [6, 7, 8], // horizontal
      [0, 3, 6], [1, 4, 7], [2, 5, 8], // vertical
      [0, 4, 8], [2, 4, 6] // diagonal
    ];

    for (var positions in winningPositions) {
      if (field[positions[0]] == field[positions[1]] && field[positions[0]] == field[positions[2]] && field[positions[0]] != PlayerType.none) {
        return true;
      }
    }

    return false;
  }

  bool gameFinished() => field.every((playerType) => playerType != PlayerType.none);

  @override
  void initState() {
    super.initState();
    reset();
  }

  @override
  Widget build(BuildContext context) {
    void makeMove(int id) {
      if (field[id] == PlayerType.none) {
        field[id] = currentPlayer;
        if (!checkWin()) {
          if (!gameFinished()) {
            nextPlayer();
            setState(() {});
          } else {
            setState(() {});
            showNoWinnerDialog(context);
          }
        } else {
          setState(() {});
          showWinnerDialog(context);
        }
      }
    }

    return Scaffold(
      backgroundColor: currentPlayer == PlayerType.x ? Colors.red : Colors.blue,
      appBar: AppBar(
        title: const Text("Tic-Tac-Toe"),
      ),
      body: Center(
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.grey[500],
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                for (int i = 0; i < 9; i += 3)
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      for (int j = i; j < i + 3; j++)
                        Cell(
                          icon: field[j],
                          onPressed: () {
                            makeMove(j);
                          },
                        ),
                    ],
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<dynamic> showWinnerDialog(BuildContext context) {
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Game over!"),
          content: Text("Player ${currentPlayer.toString().split(".")[1]} won the game"),
          actions: [
            ElevatedButton(
                onPressed: () {
                  reset();
                  Navigator.of(context).pop();
                  setState(() {});
                },
                child: const Text("Restart")),
          ],
        );
      },
    );
  }

  Future<dynamic> showNoWinnerDialog(BuildContext context) {
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Game over!"),
          content: const Text("No player won this game"),
          actions: [
            ElevatedButton(
                onPressed: () {
                  reset();
                  Navigator.of(context).pop();
                  setState(() {});
                },
                child: const Text("Restart")),
          ],
        );
      },
    );
  }
}

class Cell extends StatelessWidget {
  const Cell({
    Key? key,
    required this.icon,
    required this.onPressed,
  }) : super(key: key);

  final PlayerType icon;
  final Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: ElevatedButton(
        onPressed: () {
          onPressed();
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: icon == PlayerType.none
              ? Colors.grey[300]
              : icon == PlayerType.x
                  ? Colors.red
                  : Colors.blue,
          minimumSize: const Size(64, 64),
        ),
        child: icon == PlayerType.x ? const Icon(Icons.close) : (icon == PlayerType.o ? const Icon(Icons.circle_outlined) : Container()),
      ),
    );
  }
}
