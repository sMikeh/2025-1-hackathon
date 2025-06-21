import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'questions.dart';

void main() {
  runApp(const ChallengeApp());
}

class ChallengeApp extends StatelessWidget {
  const ChallengeApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '챌린지 앱',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Color(0xFFAEDFF7),
        fontFamily: 'ComicSans',
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(child: CustomPaint(painter: SnowPainter())),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/logo.png',
                  width: 200,
                  height: 200,

                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => const PlayerOptionPage()));
                  },
                  child: const Text('시작하기', style: TextStyle(fontSize: 20)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class SnowPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.5)
      ..strokeCap = StrokeCap.round;

    for (int i = 0; i < 40; i++) {
      final dx = (size.width) * (i % 10) / 10 + (i.isEven ? 10 : -10);
      final dy = (size.height) * (i ~/ 10) / 4 + (i % 4) * 10;
      canvas.drawCircle(Offset(dx, dy), 4, paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class PlayerOptionPage extends StatefulWidget {
  const PlayerOptionPage({Key? key}) : super(key: key);

  @override
  State<PlayerOptionPage> createState() => _PlayerOptionPageState();
}

class _PlayerOptionPageState extends State<PlayerOptionPage> {
  int playerCount = 2;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Player Option')),
      body: Center(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 30),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 10)],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('인원수를 선택해주세요', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.remove_circle, size: 30),
                    onPressed: () {
                      if (playerCount > 1) setState(() => playerCount--);
                    },
                  ),
                  Text('$playerCount명', style: const TextStyle(fontSize: 24)),
                  IconButton(
                    icon: const Icon(Icons.add_circle, size: 30),
                    onPressed: () => setState(() => playerCount++),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => PlayerNamePage(playerCount: playerCount)));
                },
                child: const Text('다음', style: TextStyle(fontSize: 18)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PlayerNamePage extends StatefulWidget {
  final int playerCount;
  const PlayerNamePage({Key? key, required this.playerCount}) : super(key: key);

  @override
  State<PlayerNamePage> createState() => _PlayerNamePageState();
}

class _PlayerNamePageState extends State<PlayerNamePage> {
  late List<TextEditingController> controllers;

  @override
  void initState() {
    super.initState();
    controllers = List.generate(widget.playerCount, (_) => TextEditingController());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('플레이어 이름 입력')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Text('플레이어의 이름을 입력해주세요', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: widget.playerCount,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: TextField(
                      controller: controllers[index],
                      decoration: InputDecoration(
                        labelText: 'Player ${index + 1} *',
                        hintText: '입력해주세요.',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
                      ),
                    ),
                  );
                },
              ),
            ),
            const Text('*미설정시, 기본값으로 설정됩니다.', style: TextStyle(color: Colors.red)),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [

                IconButton(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ModeOptionPage(playerNames: controllers.map((c) {
                        final name = c.text.trim();
                        return name.isEmpty ? 'Player ${controllers.indexOf(c) + 1}' : name;
                      }).toList()),
                    ),
                  ),
                  padding: EdgeInsets.only(left: 310, top: 30),
                  icon: const Icon(Icons.arrow_forward, size: 40),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
class ModeOptionPage extends StatelessWidget {
  final List<String> playerNames;
  const ModeOptionPage({Key? key, required this.playerNames}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('모드 선택')),
      body: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => StopWatchPage(playerNames: playerNames)), // ✅ 전달
                );
              },
              icon: const FaIcon(FontAwesomeIcons.stopwatch, size: 32),
              label: const Text('Stop Watch Game', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              style: ElevatedButton.styleFrom(minimumSize: const Size.fromHeight(80)),
            ),
            const SizedBox(height: 30),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => FirstPage(playerNames: playerNames)));
              },
              icon: const FaIcon(FontAwesomeIcons.question, size: 32),
              label: const Text('Quiz Game', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              style: ElevatedButton.styleFrom(minimumSize: const Size.fromHeight(80)),
            ),
          ],
        ),
      ),
    );
  }
}

//question game start
class FirstPage extends StatelessWidget {
  final List<String> playerNames; // ✅ 여기에 추가

  const FirstPage({Key? key, required this.playerNames}) : super(key: key); // ✅ 여기도

  Widget categoryButton({
    required BuildContext context,
    required String title,
    required Color bgColor,
    required Widget nextPage,
  }) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => nextPage),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(30),
        ),
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        child: Text(
          title,
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 30,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(250),
          child: Container(
            width: double.infinity,
            height: 1000,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.white, width: 2),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),

            ),
            child: Row(
                children: [
            IconButton(
            icon: Icon(Icons.arrow_back, size: 30, color: Colors.black),
            onPressed: () {
              Navigator.pop(context); // 이전 화면으로 되돌아감
            },
          ),
        const SizedBox(width: 10),


            Expanded(
              child: Center(
              child: Text(
                ' 카테고리를\n선택해주세요',
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 30),
              ),
            ),
          ),
        ],
      ),
          )),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 80),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 40,
          mainAxisSpacing: 40,
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          children: [
            categoryButton(
              context: context,
              title: '상식',
              bgColor: Colors.yellow.shade300,
              nextPage: SecondPage(playerNames: playerNames),
            ),
            categoryButton(
              context: context,
              title: '연산',
              bgColor: Colors.purple.shade300,
              nextPage: ThirdPage(playerNames: playerNames),
            ),
            categoryButton(
              context: context,
              title: '코딩',
              bgColor: Colors.red.shade300,
              nextPage: FourthPage(playerNames: playerNames),
            ),
            categoryButton(
              context: context,
              title: '한국사',
              bgColor: Colors.green.shade300,
              nextPage: FifthPage(playerNames: playerNames),
            ),
          ],
        ),
      ),
    );
  }
}
class TimeAttackQuizPage extends StatefulWidget {
  final String category;
  final List<String> playerNames;
  const TimeAttackQuizPage({Key? key, required this.category, required this.playerNames}) : super(key: key);

  @override
  _TimeAttackQuizPageState createState() => _TimeAttackQuizPageState();
}

class _TimeAttackQuizPageState extends State<TimeAttackQuizPage> {
  int currentPlayerIndex = 0;
  int questionIndex = 0;
  int score = 0;
  int remainingTime = 30;
  Timer? timer;
  List<Question> questionList = [];
  late Question currentQuestion;
  bool answered = false;
  late List<int> scores;

  @override
  void initState() {
    super.initState();
    questionList = getQuestionsByCategory(widget.category);
    questionList.shuffle();
    scores = List.filled(widget.playerNames.length, 0);
    currentQuestion = questionList[questionIndex];
    startTimer();
  }

  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (remainingTime <= 0) {
        t.cancel();
        scores[currentPlayerIndex] = score;

        if (currentPlayerIndex < widget.playerNames.length - 1) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (_) => AlertDialog(
              title: const Text('시간 종료'),
              content: Text('${widget.playerNames[currentPlayerIndex]}님의 점수: $score점'),
            ),
          );

          Future.delayed(const Duration(seconds: 3), () {
            Navigator.of(context).pop(); // 팝업 닫기
            setState(() {
              currentPlayerIndex++;
              questionIndex = 0;
              score = 0;
              answered = false;
              remainingTime = 30;
              questionList.shuffle();
              currentQuestion = questionList[questionIndex];
            });
            startTimer(); // 다음 플레이어 시작
          });
        } else {
          // 마지막 플레이어일 경우 결과 화면으로 이동
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => FinalResultPage(
                playerNames: widget.playerNames,
                scores: scores,
              ),
            ),
          );
        }
      } else {
        setState(() {
          remainingTime--;
        });
      }
    });
  }

  void answerQuestion(String selected) {
    if (answered) return;

    setState(() {
      answered = true;
      if (selected == currentQuestion.options[currentQuestion.correctIndex]) {
        score++;
      }

      Future.delayed(const Duration(seconds: 1), () {
        if (questionIndex + 1 < questionList.length) {
          setState(() {
            questionIndex++;
            currentQuestion = questionList[questionIndex];
            answered = false;
          });
        } else {
          // 문제 끝나도 다음 사람으로 넘어감
          timer?.cancel();
          scores[currentPlayerIndex] = score;

          if (currentPlayerIndex < widget.playerNames.length - 1) {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (_) => AlertDialog(
                title: const Text('퀴즈 종료'),
                content: Text('${widget.playerNames[currentPlayerIndex]}님의 점수: $score점'),
              ),
            );

            Future.delayed(const Duration(seconds: 3), () {
              Navigator.of(context).pop(); // 팝업 닫기
              setState(() {
                currentPlayerIndex++;
                questionIndex = 0;
                score = 0;
                answered = false;
                remainingTime = 30;
                questionList.shuffle();
                currentQuestion = questionList[questionIndex];
              });
              startTimer();
            });
          } else {
            // 모든 플레이어 종료 후 결과 화면
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => FinalResultPage(
                  playerNames: widget.playerNames,
                  scores: scores,
                ),
              ),
            );
          }
        }
      });
    });
  }


  @override
    void dispose() {
      timer?.cancel();
      super.dispose();
    }

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(title: Text('Time Attack: ${widget.category}')),
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('플레이어: ${widget.playerNames[currentPlayerIndex]}',
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold)),
                  Text('카테고리: ${widget.category}',
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold)),
                ],
              ),
              const SizedBox(height: 30),
              Text(currentQuestion.question,
                  style: const TextStyle(
                      fontSize: 22, fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),
              ...currentQuestion.options.map((option) =>
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: ElevatedButton(
                      onPressed: () => answerQuestion(option),
                      child: Text(option, style: const TextStyle(fontSize: 18)),
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size.fromHeight(50),
                        backgroundColor: Colors.blueAccent,
                      ),
                    ),
                  )),
              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('⏱ $remainingTime초',
                      style: const TextStyle(fontSize: 16)),
                  Text('✅ $score개 정답', style: const TextStyle(fontSize: 16)),
                ],
              ),
              const SizedBox(height: 20),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
                ),
                child: Center(
                  child: Text(
                    '${questionIndex + 1}/${questionList.length} 문제 완료',
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ),

            ],
          ),
        ),
      );
    }
  }


class SecondPage extends StatelessWidget {
  final List<String> playerNames;
  const SecondPage({Key? key, required this.playerNames}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TimeAttackQuizPage(category: '상식', playerNames: playerNames);
  }
}



class ThirdPage extends StatelessWidget {
  final List<String> playerNames;
  const ThirdPage({Key? key, required this.playerNames}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TimeAttackQuizPage(category: '연산', playerNames: playerNames);
  }
}

class FourthPage extends StatelessWidget {
  final List<String> playerNames;
  const FourthPage({Key? key, required this.playerNames}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return TimeAttackQuizPage(category: '코딩', playerNames: playerNames);
  }
}

class FifthPage extends StatelessWidget {
  final List<String> playerNames;
  const FifthPage({Key? key, required this.playerNames}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return TimeAttackQuizPage(category: '한국사', playerNames: playerNames);
  }
}


//end
class StopWatchPage extends StatefulWidget {
  final List<String> playerNames;
  const StopWatchPage({Key? key, required this.playerNames}) : super(key: key);
  @override
  State<StopWatchPage> createState() => _StopWatchPageState();
}

class _StopWatchPageState extends State<StopWatchPage> {
  late double targetTime;
  late Stopwatch stopwatch;
  Timer? timer;
  double currentTime = 0.0;

  int currentPlayerIndex = 0;
  List<String> playerNames = ['P1', 'P2', 'P3'];
  List<double> results = [];

  @override
  void initState() {
    super.initState();
    stopwatch = Stopwatch();
    targetTime = _generateRandomTargetTime();  // 랜덤 목표 시간
    playerNames = widget.playerNames;
  }

  double _generateRandomTargetTime() {
    final random = Random();
    return double.parse((5 + random.nextDouble() * 3).toStringAsFixed(4)); // 5~8초 사이 랜덤
  }

  double _generateTargetTime() {
    DateTime now = DateTime.now();
    String timeStr = '${now.month}${now.day}${now.day}${now.minute}';
    String decimal = timeStr.substring(timeStr.length - 4);
    return double.parse('6.${decimal}');
  }

  void _startStopwatch() {
    stopwatch.reset();
    stopwatch.start();
    timer = Timer.periodic(const Duration(milliseconds: 10), (_) {
      setState(() {
        currentTime = stopwatch.elapsedMilliseconds / 1000.0;
      });
    });
  }

  void _stopStopwatch() {
    stopwatch.stop();
    timer?.cancel();

    final diff = (currentTime - targetTime).abs();
    final message = diff < 0.01
        ? "완벽해요!"
        : (currentTime > targetTime
        ? (diff > 3 ? "많이 늦었어요" : "조금 늦었어요")
        : (diff > 3 ? "너무 빨랐어요" : "조금 빨랐어요"));

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('${playerNames[currentPlayerIndex]}님의 결과'),
        content: Text(
          '목표 시간: ${targetTime.toStringAsFixed(4)}초\n'
              '측정 시간: ${currentTime.toStringAsFixed(4)}초\n'
              '차이: ${diff.toStringAsFixed(4)}초\n'
              '$message',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              results.add(currentTime); // 결과 저장

              if (currentPlayerIndex < playerNames.length - 1) {
                setState(() {
                  currentPlayerIndex++;
                  currentTime = 0.0;
                });
              } else {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ResultPage(
                      targetTime: targetTime,
                      playerNames: playerNames,
                      records: results,
                    ),
                  ),
                );
              }
            },
            child: const Text('확인'),
          ),
        ],
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    String currentPlayer = playerNames[currentPlayerIndex];
    return Scaffold(
      appBar: AppBar(title: const Text('StopWatch Mode')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("목표는", style: TextStyle(fontSize: 24)),
            Text('${targetTime.toStringAsFixed(4)} 초.',
                style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            Text(currentTime.toStringAsFixed(4),
                style: const TextStyle(fontSize: 48, color: Colors.blueAccent)),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: _startStopwatch,
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                  child: const Text('GO', style: TextStyle(fontSize: 24)),
                ),
                ElevatedButton(
                  onPressed: _stopStopwatch,
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  child: const Text('STOP', style: TextStyle(fontSize: 24)),
                ),
              ],
            ),
            const SizedBox(height: 30),
            Text('[${currentPlayer}]', style: const TextStyle(fontSize: 20)),
          ],
        ),
      ),
    );
  }
}


class FinalResultPage extends StatelessWidget {
  final List<String> playerNames;
  final List<int> scores;

  const FinalResultPage({
    Key? key,
    required this.playerNames,
    required this.scores,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // 점수 정렬
    List<MapEntry<String, int>> ranked = List.generate(
      playerNames.length,
          (i) => MapEntry(playerNames[i], scores[i]),
    );

    ranked.sort((a, b) => b.value.compareTo(a.value));

    // 동점자 처리 등수 계산
    List<int> rankNumbers = [];
    int currentRank = 1;

    for (int i = 0; i < ranked.length; i++) {
      if (i > 0 && ranked[i].value == ranked[i - 1].value) {
        rankNumbers.add(rankNumbers[i - 1]);
      } else {
        rankNumbers.add(currentRank);
      }
      currentRank = rankNumbers.last + 1;
    }

    // 메달 아이콘
    String getMedal(int rank) {
      switch (rank) {
        case 1:
          return '🥇';
        case 2:
          return '🥈';
        case 3:
          return '🥉';
        default:
          return '';
      }
    }

    return Scaffold(
      appBar: AppBar(title: const Text('최종 순위')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                '🏆 최종 순위',
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 30),

              // 결과 박스 목록
              ...List.generate(ranked.length, (i) {
                final rank = rankNumbers[i];
                final name = ranked[i].key;
                final score = ranked[i].value;
                final medal = getMedal(rank);

                return Container(
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(color: Colors.black26, blurRadius: 8, offset: Offset(0, 4)),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '$medal  $rank등: $name',
                        style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(width: 20),
                      Text(
                        '(${score}개 정답)',
                        style: const TextStyle(fontSize: 20, color: Colors.grey),
                      ),
                    ],
                  ),
                );
              }),

              const SizedBox(height: 40),

              ElevatedButton(
                onPressed: () => Navigator.popUntil(context, (route) => route.isFirst),
                child: const Text('메인화면으로', style: TextStyle(fontSize: 18)),
              ),
            ],
          ),
        ),
      ),
      backgroundColor: const Color(0xFFF1F5F9), // 밝은 배경
    );
  }
}

class ResultPage extends StatelessWidget {
  final double targetTime;
  final List<String> playerNames;
  final List<double> records;

  const ResultPage({
    Key? key,
    required this.targetTime,
    required this.playerNames,
    required this.records,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> results = [];

    for (int i = 0; i < playerNames.length; i++) {
      results.add({
        'name': playerNames[i],
        'record': records[i],
        'error': (records[i] - targetTime).abs(),
      });
    }

    // 오차 기준으로 정렬
    results.sort((a, b) => a['error'].compareTo(b['error']));

    return Scaffold(
      appBar: AppBar(title: const Text('최종 순위')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 20),
            const Text('최종 순위',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.separated(
                itemCount: results.length,
                separatorBuilder: (_, __) => const Divider(),
                itemBuilder: (context, index) {
                  final r = results[index];
                  String medal = '';
                  if (index == 0)
                    medal = '🥇 ';
                  else if (index == 1)
                    medal = '🥈 ';
                  else if (index == 2) medal = '🥉 ';
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('${medal}${index + 1}등 | ${r['name']}',
                          style: const TextStyle(fontSize: 20)),
                      Text('${r['record'].toStringAsFixed(4)}초',
                          style: const TextStyle(fontSize: 18)),
                      Text('${r['error'].toStringAsFixed(4)}초 오차',
                          style: const TextStyle(
                              fontSize: 16, color: Colors.grey)),
                    ],
                  );
                },
              ),
            ),
            const SizedBox(height: 30),
            Text('게임의 우승자는\n${results[0]['name']} 입니다!',
                textAlign: TextAlign.center,
                style: const TextStyle(
                    fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () =>
                  Navigator.popUntil(context, (route) => route.isFirst),
              child: const Text('처음으로', style: TextStyle(fontSize: 18)),
            ),
          ],
        ),
      ),
    );
  }
}

