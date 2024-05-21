import 'package:dictionary/components/utils.dart';
import 'package:dictionary/main.dart';
import 'package:dictionary/pages/quiz.dart';
import 'package:flutter/material.dart';
import 'package:dictionary/pages/sejarah_kailolo.dart';
import 'package:flutter/services.dart';

class AboutDevPage extends StatefulWidget {
  const AboutDevPage({super.key});

  @override
  State<AboutDevPage> createState() => _AboutDevPageState();
}

class _AboutDevPageState extends State<AboutDevPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text("Tentang Developer"),
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
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const QuizPage()),
                );
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
                // Do nothing, already on the About Developer page
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
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                child: Image.asset(
                  'assets/images/logo.png',
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Irfan Pattinasarany\n&\nIsmawaty Marasabessy',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              const Text(
                'ITB Stikom Ambon',
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Halo, perkenalkan kami adalah Irfan dan Isma dari kampus ITB Stikom Ambon, harapan kami aplikasi ini dapat membantu masyarakat Negeri Kailolo dalam menerjemahkan kata-kata dalam Bahasa Indonesia ke Bahasa Daerah Kailolo, begitu juga sebaliknya.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13,
                ),
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
