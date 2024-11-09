import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_expanded_tile/flutter_expanded_tile.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final String url = 'https://digi-api.com/api/v1/digimon?pageSize=20';

  Future<List<dynamic>> fetchData() async {

      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseBody = json.decode(response.body);
        return responseBody['content'] ?? [];
      } else {
        throw Exception("Failed to load data");
      }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Unit 7 - API Calls"),
        backgroundColor: Colors.orangeAccent,
      ),
      body: FutureBuilder<List<dynamic>>(
        future: fetchData(),
        builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const CircularProgressIndicator();
          }

          if (snapshot.hasError) {
            return Text('Oh no! Error! ${snapshot.error}');
          }

          if (!snapshot.hasData) {
            return const Text('Nothing to show');
          }

          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final item = snapshot.data![index];
              final controller = ExpandedTileController();

              return ExpandedTile(
                controller: controller,
                title: Text(
                  item['name'] ?? 'No name available',
                  style: TextStyle(
                          fontSize: 24.0,
                        ),
                  ),
                leading: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.deepOrange, width: 2)
                  ),
                  child: item['image'] != null 
                      ? Image.network(
                          item['image'],
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,              
                        )
                      : const Icon(Icons.image_not_supported),
                ),
                theme: ExpandedTileThemeData(
                  headerColor: const Color.fromARGB(255, 241, 239, 236),
                ),
                content: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Text(
                        item['href'] ?? 'No title',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
