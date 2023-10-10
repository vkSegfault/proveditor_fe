import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:proveditor_fe/login_page.dart';
import 'dart:developer';
import 'glass_text_button.dart';
import 'province.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({ super.key });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Province Editor",  // name of Tab (Browser) or App Window (Desktop)
      debugShowCheckedModeBanner: false,
      theme: ThemeData( primaryColor: Colors.blueGrey ),
      home: const HomePage(title: "Province Editor")
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  // for Dio package
  final Dio dio = Dio();
  // for Dio package

  String responseJson = "";
  Map<String, dynamic>  responseJsonMap = {};
  ProvinceView provinceView = const ProvinceView( name: "DEBUG", country: "DEBUG", pop: -1 );
  List<ProvinceView> provinceViewList = List.empty(growable: true);
  late ProvinceList provinceList = ProvinceList( provinceList: provinceViewList );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black12,
      appBar: AppBar( title: const Text("Province Editor"), centerTitle: true, backgroundColor: const Color.fromARGB(255, 165, 149, 99), ),
      body: Container(
        constraints: const BoxConstraints(maxHeight: 1500, maxWidth: 2400, minHeight: 1000),
        decoration: const BoxDecoration( image: DecorationImage(image: AssetImage("assets/map1.jpeg"), fit: BoxFit.fill) ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Flexible(
              flex: 1,
              child: ExpansionTile(
                backgroundColor: Colors.black54,
                collapsedBackgroundColor: Colors.black54,
                collapsedIconColor: Colors.white,
                title: const Row(children: [
                  Icon(Icons.settings),
                  SizedBox(width: 10,),
                  Text("Menu", textScaleFactor: 2, style: TextStyle(color: Colors.cyan ) )
                ],),
                controlAffinity: ListTileControlAffinity.trailing,
                children: [
                  ListTile(title: GlassTextButton(text: "Import", f: import, height: 60) ),
                  ListTile(title: GlassTextButton(text: "Export", f: export, height: 60) ),
                  ListTile(title: GlassTextButton(text: "Elasticsearch Indexing", f: elasticIndexing, height: 60, width: 200) ),
                  ListTile(title: ElevatedButton(
                    // switch to LoginPage
                    onPressed: () { Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) { 
                        return const LoginPage(); 
                      } ) 
                    ); },
                    child: const Text("Login"),),
                  )
                ],
              ),
            ),
            Flexible(
              flex: 5,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SearchBar(
                      leading: const Icon(Icons.search),
                      backgroundColor: MaterialStateProperty.all(const Color.fromARGB(255, 194, 199, 231)), 
                      shadowColor: MaterialStateProperty.all(Colors.cyan),
                      overlayColor: MaterialStateProperty.all(const Color.fromARGB(255, 190, 190, 156)),
                      elevation: MaterialStateProperty.all(10.0),
                      side: MaterialStateProperty.all(const BorderSide(color: Colors.pinkAccent)),
                      hintText: 'Search Province...',
                      hintStyle: MaterialStateProperty.all(const TextStyle(color: Colors.black54, fontWeight: FontWeight.bold)),
                      onChanged: (String value) { getResult(value); },
                      onSubmitted: (String value) { getResult(value); },  // when enter button is clicked
                    ),
                    Container(
                      decoration: BoxDecoration(color: const Color.fromARGB(100, 136, 171, 201), borderRadius: BorderRadius.circular(10)),
                      margin: const EdgeInsets.symmetric( horizontal: 15, vertical: 15 ),
                      alignment: Alignment.center,
                      child: provinceList
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void getResult( String query ) async {

    const String url = 'http://localhost:9200/province/_search';
    final String body = '{ "query": { "bool": { "should": [ { "prefix": {"name": "$query" } }, { "prefix": { "country.name": "$query" } } ] } } }';
    const Map<String, dynamic> headers = {'Content-Type': 'application/json'};

    try {

      final response = await dio.post(
          url,
          data: body,
          options: Options( headers: headers )
      );

      if ( response.statusCode == 200 ) {
        log( "### THERE ARE: ${response.data['hits']['total']['value']} PROVINCES mathichg query: $query");
        
        provinceViewList.clear();
        for ( final prov in response.data['hits']['hits'] ) {

          String provinceName = prov['_source']['name'];

          String country;
          int pop;
          try {
            // if DB if dropped, new one won't probbaly has [country] or [pop]
            country = prov['_source']['country']['name'];
            pop = prov['_source']['pop'];
          } catch(e) {
            country = "## NOT PROVIDED ##";
            pop = -1;
          }

          log( provinceName );
          setState(() {
            provinceViewList.add(ProvinceView( name: provinceName, country: country, pop: pop));
          });
        }
        provinceList = ProvinceList(provinceList: provinceViewList);
      }

    } catch(e) {
      log(e.toString());
    }

  }

  void import() async {
    log("Import button clicked");
    String url = 'http://localhost:8080/api/v1/province/import';

    try {
      final response = await dio.get(url);
      if( response.statusCode == 200 ) {
        log("Importing succeeded");
      }

    } catch(e) {
      log(e.toString());
    }

  }

  void export() async {
    log("Export button clicked");
    const String url = 'http://localhost:8080/api/v1/province/export';

    try {
      final response = await dio.get(url);
      if( response.statusCode == 200 ) {
        log("Exporting succeeded");
      }

    } catch(e) {
      log(e.toString());
    }
  }

  void elasticIndexing() async {
    log("Elastichsearch Indexing button clicked");
    const String url = 'http://localhost:8080/api/v1/province/elastic/indexing';

    try {
      final response = await dio.get(url);
      if( response.statusCode == 200 ) {
        log("Elastichsearch Indexing succeeded");
      }

    } catch(e) {
      log(e.toString());
    }
  }

}