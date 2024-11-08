import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert'; 

class RestApiTask extends StatefulWidget {
  const RestApiTask({super.key});

  @override
  State<RestApiTask> createState() => _RestApiTaskState();
}

class _RestApiTaskState extends State<RestApiTask> {
  List<dynamic> _allPosts = [];
  List<dynamic> _filteredPosts = [];
  final TextEditingController _searchController = TextEditingController();

  Future<void> fetchData() async {
    final response = await http.get(Uri.parse('https://jsonplaceholder.typicode.com/posts'));

    if (response.statusCode == 200) {
      setState(() {
        _allPosts = json.decode(response.body);
        _filteredPosts = _allPosts;
      });
    } else {
      throw Exception('Failed to load data');
    }
  }

  void _filterPosts(String query) {
    if (query.isEmpty) {
      setState(() {
        _filteredPosts = _allPosts;
      });
    } else {
      setState(() {
        _filteredPosts = _allPosts.where((post) {
          return post['title'].toLowerCase().contains(query.toLowerCase()) ||
                 post['body'].toLowerCase().contains(query.toLowerCase());
        }).toList();
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchData();
    _searchController.addListener(() {
      _filterPosts(_searchController.text);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Rest API Task"),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Search',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _filteredPosts.length,
              itemBuilder: (context, index) {
                var data = _filteredPosts[index]; 
                return Container(
                  height: 220,
                  color: const Color.fromARGB(255, 196, 205, 209),
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  margin: EdgeInsets.all(10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('User Id: ${data['userId']}', style: TextStyle(fontSize: 18)),
                      Text('Id: ${data['id']}', style: TextStyle(fontSize: 18)),
                      Text('Title: ${data['title']}', style: TextStyle(fontSize: 18)),
                      Text('Body: ${data['body']}', style: TextStyle(fontSize: 18)),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
