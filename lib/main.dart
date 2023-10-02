import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({ super.key });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Province Editor",  // name of Tab (Browser) or App Window (Desktop)
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
        decoration: const BoxDecoration( image: DecorationImage(image: AssetImage("assets/map1.jpeg"), fit: BoxFit.cover) ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SearchBar(
              leading: const Icon(Icons.search),
              backgroundColor: MaterialStateProperty.all(const Color.fromARGB(255, 194, 199, 231)), 
              shadowColor: MaterialStateProperty.all(Colors.cyan),
              overlayColor: MaterialStateProperty.all(Colors.pink),
              elevation: MaterialStateProperty.all(10.0),
              side: MaterialStateProperty.all(const BorderSide(color: Colors.pinkAccent)),
              hintText: 'Search Province...',
              hintStyle: MaterialStateProperty.all(const TextStyle(color: Colors.black54, fontWeight: FontWeight.bold)),
              onChanged: (String value) { getProvince(value); },
              onSubmitted: (String value) { getProvince(value); },  // when enter button is clicked
            ),
            Container( color: const Color.fromARGB(200, 136, 171, 201), alignment: Alignment.center, child: provinceList ),
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
        print( "### THERE ARE: ${response.data['hits']['total']['value']} PROVINCES mathichg query: $provinceName");
        
        provinceViewList.clear();
        for ( final prov in response.data['hits']['hits'] ) {

          String provinceName = prov['_source']['name'];
          String country = prov['_source']['country']['name'];
          int pop = prov['_source']['pop'];

          print( provinceName );
          setState(() {
            provinceViewList.add(ProvinceView( name: provinceName, country: country, pop: pop));
          });
        }
        provinceList = ProvinceList(provinceList: provinceViewList);
      }

    } catch(e) {
      print(e);
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
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(color: Colors.amber, height: 40, width: 40,),
        const SizedBox(width: 20),
        const Icon(Icons.map_outlined),
        const SizedBox(width: 20),
        Column(
          children: [
            Text(name, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
            Text("Country: $country"),
            Text("Pop: $pop")
          ],
        ),
      ],
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