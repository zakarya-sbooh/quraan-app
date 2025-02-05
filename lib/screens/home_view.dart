import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:quraanapp/components/side_menu.dart';
import 'package:quraanapp/constants/color.dart';
import 'package:quraanapp/screens/surah_view.dart';

class HomeView extends StatefulWidget {
  static String id = "HomeView";

  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  List<dynamic> surahs = [];
  List<dynamic> filteredSurahs = [];
  bool isLoading = true;
  TextEditingController searchController = TextEditingController();
  bool isDarkMode = false;

  @override
  void initState() {
    super.initState();
    _fetchSurahs();
  }

  Future<void> _fetchSurahs() async {
    final url = Uri.parse('https://api.alquran.cloud/v1/surah');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        surahs = data['data'];
        filteredSurahs = surahs;
        isLoading = false;
      });
    } else {
      throw Exception("Failed to load surahs");
    }
  }

  void _filterSurahs(String query) {
    setState(() {
      filteredSurahs = surahs
          .where((surah) =>
              surah['name'].toString().contains(query) ||
              surah['englishName']
                  .toString()
                  .toLowerCase()
                  .contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: isDarkMode ? Colors.black : offWhite,
      appBar: AppBar(
        title: TextField(
          controller: searchController,
          onChanged: _filterSurahs,
          decoration: InputDecoration(
            hintText: 'ابحث عن سورة...',
            hintStyle: TextStyle(color: black),
            border: InputBorder.none,
            icon: Icon(Icons.search, color: black),
          ),
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: lightGreen,
        actions: [
          IconButton(
            icon: Icon(isDarkMode ? Icons.dark_mode : Icons.light_mode),
            onPressed: () => setState(() => isDarkMode = !isDarkMode),
          ),
        ],
      ),
      drawer: SideMenu(),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(
              color: lightGreen,
            ))
          : Padding(
              padding: const EdgeInsets.all(10.0),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 2.5,
                ),
                itemCount: filteredSurahs.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SurahView(
                              surahNumber: filteredSurahs[index]['number']),
                        ),
                      );
                    },
                    child: Card(
                      color:
                          isDarkMode ? Colors.grey[900] : Colors.green.shade100,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 4,
                      child: Center(
                        child: Text(
                          filteredSurahs[index]['name'],
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: isDarkMode ? Colors.white : Colors.black,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
    );
  }
}
