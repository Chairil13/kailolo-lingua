import 'dart:math';
import 'package:dictionary/components/utils.dart';
import 'package:dictionary/main.dart';
import 'package:dictionary/pages/about_dev.dart';
import 'package:dictionary/pages/sejarah_kailolo.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const QuizApp());
}

class QuizApp extends StatelessWidget {
  const QuizApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quiz Kata',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const QuizPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class QuizPage extends StatefulWidget {
  const QuizPage({super.key});

  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  final Map<String, String> dictionary = {
    'rumah': 'house',
    'buah': 'fruit',
    'mobil': 'car',
    'kucing': 'cat',
    // Tambahkan kata-kata dari kamus bahasa daerah Anda di sini
  };

  List<String> questions = [];
  String correctAnswer = '';
  int score = 0;
  int currentQuestionIndex = 0;
  List<Map<String, String>> incorrectAnswers = [];

  @override
  void initState() {
    super.initState();
    generateQuestions();
  }

  void generateQuestions() {
    List<String> keys = dictionary.keys.toList();
    questions.clear();
    for (int i = 0; i < 4; i++) {
      int randomIndex = Random().nextInt(keys.length);
      String question = keys[randomIndex];
      questions.add(question);
    }
    setState(() {
      currentQuestionIndex = 0;
      correctAnswer = dictionary[questions[currentQuestionIndex]]!;
    });
  }

  void checkAnswer(String selectedAnswer) {
    if (selectedAnswer == correctAnswer) {
      setState(() {
        score++;
      });
    } else {
      incorrectAnswers.add({
        'question': questions[currentQuestionIndex],
        'correctAnswer': correctAnswer,
      });
    }
    if (currentQuestionIndex < 3) {
      setState(() {
        currentQuestionIndex++;
        correctAnswer = dictionary[questions[currentQuestionIndex]]!;
      });
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ScorePage(
            score: score,
            onRestart: generateQuestions,
            incorrectAnswers: incorrectAnswers,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text('Quiz'),
        actions: [
          Builder(
            builder: (context) => IconButton(
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
              icon: const Icon(Icons.menu),
            ),
          ),
        ],
        automaticallyImplyLeading: false,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Kailolo Lingua',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Aplikasi kamus terjemahan Indonesia - Kailolo',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Home'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const WordPage()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.question_answer),
              title: const Text('Quiz'),
              onTap: () {
                Navigator.pop(context);
                // Do nothing, already on the About Developer page
              },
            ),
            ListTile(
              leading: const Icon(Icons.public),
              title: const Text('Sejarah Negeri Kailolo'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const AboutKailoloPage()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Tentang Developer'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const AboutDevPage()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.update),
              title: FutureBuilder<String>(
                future: lastUpdatedLocalFile(),
                // future: lastUpdatedLocalFile(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator(
                      semanticsLabel: 'Loading..',
                    );
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    return Text('Updated time: ${snapshot.data}');
                  }
                },
              ),
              onTap: () {
                Navigator.pop(context); // Close the drawer
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.exit_to_app,
                size: 17,
              ),
              title: const Text('Exit'),
              onTap: () {
                _konfirmasiKeluar(context); // Panggil fungsi konfirmasi keluar
              },
            ),
          ],
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text(
                'Pilih terjemahan yang benar untuk kata:',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20.0),
              ),
              const SizedBox(height: 20.0),
              QuestionWidget(question: questions[currentQuestionIndex]),
              const SizedBox(height: 20.0),
              OptionsWidget(
                options: dictionary.values.toList(),
                onOptionSelected: checkAnswer,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _konfirmasiKeluar(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Konfirmasi"),
          content: const Text("Apakah Anda yakin ingin keluar?"),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Tutup dialog
              },
              child: const Text("Batal"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Tutup dialog
                SystemNavigator.pop(); // Keluar dari aplikasi
              },
              child: const Text("Ya"),
            ),
          ],
        );
      },
    );
  }
}

class QuestionWidget extends StatelessWidget {
  final String question;

  const QuestionWidget({super.key, required this.question});

  @override
  Widget build(BuildContext context) {
    return Text(
      question,
      textAlign: TextAlign.center,
      style: const TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold),
    );
  }
}

class OptionsWidget extends StatelessWidget {
  final List<String> options;
  final Function(String) onOptionSelected;

  const OptionsWidget({
    super.key,
    required this.options,
    required this.onOptionSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: options
          .map((option) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: ElevatedButton(
                  onPressed: () {
                    onOptionSelected(option);
                  },
                  child: Text(option),
                ),
              ))
          .toList(),
    );
  }
}

class ScorePage extends StatelessWidget {
  final int score;
  final VoidCallback onRestart;
  final List<Map<String, String>> incorrectAnswers;

  const ScorePage({
    super.key,
    required this.score,
    required this.onRestart,
    required this.incorrectAnswers,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Skor Akhir'),
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (incorrectAnswers.isEmpty)
              const Padding(
                padding: EdgeInsets.all(12.0),
                child: Text(
                  'Selamat! Anda menjawab semua pertanyaan dengan benar!',
                  style: TextStyle(fontSize: 20),
                  textAlign: TextAlign.center,
                ),
              ),
            if (incorrectAnswers.isNotEmpty) ...[
              const Text('Pertanyaan yang Salah:',
                  style: TextStyle(fontSize: 20)),
              for (var answer in incorrectAnswers)
                Column(
                  children: [
                    Text('Pertanyaan: ${answer['question']}',
                        style: const TextStyle(fontSize: 16)),
                    Text('Jawaban yang Benar: ${answer['correctAnswer']}',
                        style: const TextStyle(fontSize: 16)),
                    const SizedBox(height: 10),
                  ],
                ),
            ],
            Text('Skor Anda: $score / 4', style: const TextStyle(fontSize: 24)),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          const QuizApp()), // Navigasi ke halaman QuizApp
                );
              },
              child: const Text('Ulangi Kuis'),
            ),
          ],
        ),
      ),
    );
  }
}
