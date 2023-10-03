import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:proveditor_fe/login_page.dart';
import 'dart:developer';
import 'glass_text_button.dart';

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
        constraints: const BoxConstraints(maxHeight: 1080, maxWidth: 2400),
        decoration: const BoxDecoration( image: DecorationImage(image: AssetImage("assets/map1.jpeg"), fit: BoxFit.cover) ),
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
                title: const Text("Menu", textScaleFactor: 2, style: TextStyle(color: Colors.cyan ) ),
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
                    onChanged: (String value) { getProvince(value); },
                    onSubmitted: (String value) { getProvince(value); },  // when enter button is clicked
                  ),
                  Container( color: const Color.fromARGB(100, 136, 171, 201), alignment: Alignment.center, child: provinceList ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void getProvince( String provinceName ) async {

    const String url = 'http://localhost:9200/province/_search';
    final String body = '{ "query": { "prefix": { "name": { "value": "$provinceName" } } } }';
    const Map<String, dynamic> headers = {'Content-Type': 'application/json'};

    try {

      final response = await dio.post(
          url,
          data: body,
          options: Options( headers: headers )
      );

      if ( response.statusCode == 200 ) {
        log( "### THERE ARE: ${response.data['hits']['total']['value']} PROVINCES mathichg query: $provinceName");
        
        provinceViewList.clear();
        for ( final prov in response.data['hits']['hits'] ) {

          String provinceName = prov['_source']['name'];
          String country = prov['_source']['country']['name'];
          int pop = prov['_source']['pop'];

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

class ProvinceView extends StatelessWidget {
  const ProvinceView({super.key, this.name = "ERROR", this.country = "ERROR", this.pop = -1});

  final String name;
  final String country;
  final int pop;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Container(
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: const Color.fromARGB(200, 100, 100, 250)),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(width: 20),
            const Icon(Icons.map_outlined),
            const SizedBox(width: 20),
            Column(
              children: [
                const SizedBox(height: 10),
                Text(name, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                Text("Country: $country"),
                Text("Pop: $pop"),
                const SizedBox(height: 10),
              ],
            ),
            const SizedBox(width: 20),
          ],
        ),
      ),
    );
  }
}

class ProvinceList extends StatelessWidget {
  const ProvinceList({super.key, required this.provinceList });

  final List<ProvinceView> provinceList;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: provinceList,
      );
  }
}