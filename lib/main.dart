import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

late Logger _logger;
Logger get logger => _logger;

void main() {
  // Configure the logger
  _logger = Logger(
    filter: null, // Use the default LogFilter (-> only log in debug mode)
    printer: PrettyPrinter(
      methodCount: 2, // number of method calls to be displayed
      errorMethodCount: 8, // number of method calls if stacktrace is provided
      lineLength: 120, // width of the output
      colors: true, // Colorful log messages
      printEmojis: true, // Print an emoji for each log message
      printTime: false, // Should each log print contain a timestamp
    ), // Use the PrettyPrinter to format and print log
    output: null, // Use the default LogOutput (-> send everything to console)
  );

  // Start app
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
    if (field[0] == field[1] && field[0] == field[2] && field[0] != PlayerType.none) {
      return true;
    } else if (field[3] == field[4] && field[3] == field[5] && field[3] != PlayerType.none) {
      return true;
    } else if (field[6] == field[7] && field[6] == field[8] && field[6] != PlayerType.none) {
      return true;
    } else if (field[0] == field[3] && field[0] == field[6] && field[0] != PlayerType.none) {
      return true;
    } else if (field[1] == field[4] && field[1] == field[7] && field[1] != PlayerType.none) {
      return true;
    } else if (field[2] == field[5] && field[2] == field[8] && field[2] != PlayerType.none) {
      return true;
    } else if (field[0] == field[4] && field[0] == field[8] && field[0] != PlayerType.none) {
      return true;
    } else if (field[2] == field[4] && field[2] == field[6] && field[2] != PlayerType.none) {
      return true;
    }
    return false;
  }

  bool gameFinished() {
    return field.every((playerType) => playerType != PlayerType.none);
  }

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
            showDialog(
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
                });
          }
        } else {
          setState(() {});
          showDialog(
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
              });
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
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Cell(
                      icon: field[0],
                      onPressed: () {
                        makeMove(0);
                      },
                    ),
                    Cell(
                      icon: field[1],
                      onPressed: () {
                        makeMove(1);
                      },
                    ),
                    Cell(
                      icon: field[2],
                      onPressed: () {
                        makeMove(2);
                      },
                    ),
                  ],
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Cell(
                      icon: field[3],
                      onPressed: () {
                        makeMove(3);
                      },
                    ),
                    Cell(
                      icon: field[4],
                      onPressed: () {
                        makeMove(4);
                      },
                    ),
                    Cell(
                      icon: field[5],
                      onPressed: () {
                        makeMove(5);
                      },
                    ),
                  ],
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Cell(
                      icon: field[6],
                      onPressed: () {
                        makeMove(6);
                      },
                    ),
                    Cell(
                      icon: field[7],
                      onPressed: () {
                        makeMove(7);
                      },
                    ),
                    Cell(
                      icon: field[8],
                      onPressed: () {
                        makeMove(8);
                      },
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
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
