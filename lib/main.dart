import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(QuoteApp());
}

class QuoteApp extends StatefulWidget {
  @override
  _QuoteAppState createState() => _QuoteAppState();
}

class _QuoteAppState extends State<QuoteApp> {
  String quote = "";
  String author = "";
  List<String> displayedQuotes = [];

  Future<void> fetchRandomQuote() async {
    final response = await http.get(Uri.parse("https://zenquotes.io/api/random/"));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        quote = data[0]['q'];
        author = data[0]['a'];
        displayedQuotes.add('$quote - $author');
      });
    } else {
      throw Exception('Failed to load a quote');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchRandomQuote();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Random Quotes App'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Quote:',
                style: TextStyle(fontSize: 20),
              ),
              Text(
                quote,
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 20),
              Text(
                'Author:',
                style: TextStyle(fontSize: 20),
              ),
              Text(
                author,
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: fetchRandomQuote,
                child: Text('Refresh'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text('Displayed Quotes'),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: displayedQuotes.map((quote) {
                            return ListTile(
                              title: Text(quote),
                            );
                          }).toList(),
                        ),
                        actions: <Widget>[
                          ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text('Close'),
                          ),
                        ],
                      );
                    },
                  );
                },
                child: Text('List of Quotes'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
