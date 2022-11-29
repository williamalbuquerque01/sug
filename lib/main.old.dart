import 'package:flutter/material.dart';
import 'package:html/parser.dart' as parser;
import 'package:requests/requests.dart';
//import 'package:http/http.dart' as http;


void main() => runApp(MaterialApp(
    theme: ThemeData(
      accentColor: Colors.red[800],
      scaffoldBackgroundColor: Colors.white,
      primaryColor: Colors.red[800],
    ),
    home: MyApp()));

class MyApp extends StatefulWidget {
  const MyApp({ super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  String baseUrl = 'https://sigurh.cps.sp.gov.br/';
// Strings to store the extracted Article titles
  String result1 = 'Result 1';
//  String result2 = 'Result 2';
//  String result3 = 'Result 3';
  Map<String, String> headers = {
    'user-agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/106.0.0.0 Safari/537.36'
  };

// boolean to show CircularProgressIndication
// while Web Scraping awaits
  bool isLoading = false;

  Future<List<String>> extractData() async {

    // Getting the response from the targeted url
    String hostname = Requests.getHostname(baseUrl);
    final response = await Requests.get(baseUrl);
    var cookieJar = await Requests.getStoredCookies(hostname);

    // Status Code 200 means response has been received successfully
    if (response.statusCode == 200) {

      // Getting the html document from the response
      var document = cookieJar['PHPSESSID'];
      try {

        // Scraping the first article title
        /*var responseString1 = document
            .querySelectorAll('#table_1 > tbody > tr')[0]
              .children[2];
//            .children[0]
//            .children[0];*/
        var responseString1 = document.toString();

        print(cookieJar);
//
//        // Scraping the second article title
//        var responseString2 = document
//            .getElementsByClassName('articles-list')[0]
//            .children[1]
//            .children[0]
//            .children[0];
//
//        print(responseString2.text.trim());
//
//        // Scraping the third article title
//        var responseString3 = document
//            .getElementsByClassName('articles-list')[0]
//            .children[2]
//            .children[0]
//            .children[0];
//
//        print(responseString3.text.trim());
//
        // Converting the extracted titles into
        // string and returning a list of Strings
        return [
          responseString1,
        // responseString2.text.trim(),
        // responseString3.text.trim()
        ];
      } catch (e) {
        return ['', '', 'ERROR!'];
      }
    } else {
      return ['', '', 'ERROR: ${response.statusCode}.'];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Contratos')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                // if isLoading is true show loader
                // else show Column of Texts
                isLoading
                    ? CircularProgressIndicator()
                    : Column(
                  children: [
                    Text(result1,
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.05,
                    ),
                //    Text(result2,
                //        style: TextStyle(
                //            fontSize: 20, fontWeight: FontWeight.bold)),
                //    SizedBox(
                //      height: MediaQuery.of(context).size.height * 0.05,
               //     ),
               //     Text(result3,
              //          style: TextStyle(
              //              fontSize: 20, fontWeight: FontWeight.bold)),
                 ],
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.08),
                MaterialButton(
                  onPressed: () async {

                    // Setting isLoading true to show the loader
                    setState(() {
                      isLoading = true;
                    });

                    // Awaiting for web scraping function
                    // to return list of strings
                    final response = await extractData();

                    // Setting the received strings to be
                    // displayed and making isLoading false
                    // to hide the loader
                    setState(() {
                      result1 = response[0];
                    //  result2 = response[1];
                    //  result3 = response[2];
                    //  isLoading = false;

                      isLoading = false;
                    });
                  },
                  child: Text(
                    'Scrap Data',
                    style: TextStyle(color: Colors.white),
                  ),
                  color: Colors.green,
                )
        ],
      )),
    ),
    );
  }
}