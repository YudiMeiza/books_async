import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Yudi Meiza',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const FuturePage(),
    );
  }
}

class FuturePage extends StatefulWidget {
  const FuturePage({super.key});

  @override
  State<FuturePage> createState() => _FuturePageState();
}

class _FuturePageState extends State<FuturePage> {
  String result = '';
  bool isLoading = false;

  // 🔽 Method untuk ambil data dari Google Books API
  Future<http.Response> getData() async {
    const authority = 'www.googleapis.com';
    const path = '/books/v1/volumes/_2_uDAAAQBAJ';
    Uri url = Uri.https(authority, path);
    return http.get(url);
  }

  // 🔽 Fungsi untuk memanggil getData dan update UI
  void fetchBookData() async {
    setState(() {
      isLoading = true;
    });

    try {
      final response = await getData();
      if (response.statusCode == 200) {
        setState(() {
          result = response.body;
        });
      } else {
        setState(() {
          result = 'Error: ${response.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        result = 'Exception: $e';
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Back from the Future'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const Spacer(),
              ElevatedButton(
                onPressed: fetchBookData,
                child: const Text('GO!'),
              ),
              const Spacer(),
              if (result.isNotEmpty)
                Expanded(child: SingleChildScrollView(child: Text(result)))
              else
                const Text('No data'),
              const Spacer(),
              if (isLoading) const CircularProgressIndicator(),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
