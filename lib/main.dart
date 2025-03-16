import 'package:blinkit_app/aapi_assignment.dart';
import 'package:blinkit_app/country_code.dart';

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: PostListScreen()
    );
  }
}

class UrlLauncherScreen extends StatefulWidget {
  @override
  _UrlLauncherScreenState createState() => _UrlLauncherScreenState();
}

class _UrlLauncherScreenState extends State<UrlLauncherScreen> {
  final TextEditingController _urlController = TextEditingController();
  final String urladd = "https://wa.me/";
  //final List<String> _presetUrls = ["91", "92", "93"];

  //String? _selectedUrl;
  late String countrycode = "";

  Map<String, String>? selectedCountry;
  Future<void> _launchURL() async {
    final String url = _urlController.text.trim();
    if (url.isNotEmpty && countrycode.isNotEmpty) {
      if (url.isEmpty) return;
      final Uri uri = Uri.parse(urladd + countrycode + url);
      print(uri);
      if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not launch $url')),
        );
      }
    }
    if (countrycode.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please Select Country Code')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please Enter Number')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Direct Chat'),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 60,
                  width: 200,
                  child: DropdownButton<Map<String, String>>(
                    value: selectedCountry,
                    hint: Center(child: const Text("Choose a country")),
                    isExpanded: true,
                    items: CountryCode.countries.map((country) {
                      return DropdownMenuItem(
                        value: country,
                        child: Text(
                            "${country['name']} (${country['dial_code']})"),
                      );
                    }).toList(),
                    onChanged: (newValue) {
                      setState(() {
                        selectedCountry = newValue;
                        var codec = selectedCountry!["dial_code"];
                        var p = codec?.split("+");
                        var countrycode1 = p![1];
                        countrycode = countrycode1;

                        print(countrycode);

                        // print(codec);
                        // print(selectedCountry);
                      });
                    },
                  ),
                ),
                Flexible(
                  fit: FlexFit.loose,
                  child: SizedBox(
                    height: 54,
                    width: 600,
                    child: TextField(
                        controller: _urlController,
                        decoration: const InputDecoration(
                          labelText: 'Enter Number',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.phone),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            FloatingActionButton(
              onPressed: _launchURL,
              backgroundColor: Colors.green,
              child: Text(
                "Open",
              ),
            ),
          ],
        ),
      ),
    );
  }
}
