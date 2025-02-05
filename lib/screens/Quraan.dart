import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:quraanapp/constants/color.dart';

class Quraan extends StatefulWidget {
  const Quraan({super.key});

  @override
  State<Quraan> createState() => _QuraanState();
}

class _QuraanState extends State<Quraan> {
  List<dynamic> surahs = [];
  bool isLoading = true;
  bool isDarkMode = false;
  @override
  void initState() {
    super.initState();
    fetchQuran();
  }

  Future<void> fetchQuran() async {
    final response = await http
        .get(Uri.parse('http://api.alquran.cloud/v1/quran/quran-uthmani'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        surahs = data['data']['surahs'];
        isLoading = false;
      });
    } else {
      print(' فشل تحميل القرآن الكريم');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: isDarkMode ? Colors.black : offWhite,
      appBar: AppBar(
        title: Center(
          child: Text("القرآن الكريم",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
        ),
        backgroundColor: lightGreen,
        actions: [
          IconButton(
            icon: Icon(isDarkMode ? Icons.dark_mode : Icons.light_mode),
            onPressed: () => setState(() => isDarkMode = !isDarkMode),
          ),
        ],
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(
              color: lightGreen,
            ))
          : ListView.builder(
              itemCount: surahs.length,
              itemBuilder: (context, index) {
                final surah = surahs[index];
                return Card(
                  color: isDarkMode ? Colors.grey[900] : Colors.green.shade50,
                  margin:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  child: ListTile(
                    title: Text(
                      surah['name'],
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: isDarkMode ? Colors.white : Colors.black,
                      ),
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Text(
                        surah['ayahs'].map((ayah) => ayah['text']).join(" "),
                        textAlign: TextAlign.right,
                        textDirection: TextDirection.rtl,
                        style: TextStyle(
                          fontSize: 18,
                          fontFamily: 'AmiriQuran',
                          color: isDarkMode ? Colors.white : Colors.black,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
