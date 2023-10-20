import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

// class ProvinceView extends StatelessWidget {
//   const ProvinceView({super.key, this.name = "ERROR", this.country = "ERROR", this.pop = -1});

//   final String name;
//   final String country;
//   final int pop;

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(10),
//       child: Container(
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(10),
//           color: const Color.fromARGB(199, 181, 223, 104),
//           boxShadow: const [ BoxShadow(color: Color.fromARGB(197, 88, 172, 39), spreadRadius: 2, blurRadius: 2, offset: Offset(2, 2)) ]
//         ),
//         child: Row(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             // const SizedBox(width: 20),
//             // const Icon(Icons.map_outlined),
//             const SizedBox(width: 20),
//             Column(
//               children: [
//                 const SizedBox(height: 10),
//                 Text(name, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
//                 Text("Country: $country"),
//                 Text("Pop: $pop"),
//                 const SizedBox(height: 10),
//               ],
//             ),
//             const SizedBox(width: 20),
//             OutlinedButton(onPressed: makeEditableFields, style: TextButton.styleFrom( side: const BorderSide(color: Colors.black26, width: 2) ), child: const Icon( Icons.edit ) ),
//             const SizedBox(width: 20),
//           ],
//         ),
//       ),
//     );
//   }

//   void makeEditableFields() {
//     print("Edit Button clicked");
//   }

// }

// class ProvinceList extends StatelessWidget {
//   const ProvinceList({super.key, required this.provinceList });

//   final List<ProvinceView> provinceList;

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: provinceList,
//       );
//   }
// }

class ProvinceView2 extends StatefulWidget {
  const ProvinceView2({super.key, this.name = "ERROR", this.country = "ERROR", this.pop = -1});

  final String name;
  final String country;
  final int pop;

  @override
  State<ProvinceView2> createState() => _ProvinceView2State();
}

class _ProvinceView2State extends State<ProvinceView2> {

  final Dio dio = Dio();
  Widget row = const Row();
  String _country = "";
  int _pop = -1;

  //// to properly display list of Provinces we need to init Row inside `initState()` and `didUpdateWidget()`
  // initState() is called per Widget entering state, not per every new instance of Widget
  @override
  void initState() {
    super.initState();
    _country = widget.country;
    _pop = widget.pop;

    initializeDefaultRow();
  }

  // executed before build()
  @override
  void didUpdateWidget( ProvinceView2 oldView ) {
    super.didUpdateWidget(oldView);
    _country = widget.country;
    _pop = widget.pop;

    initializeDefaultRow();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: const Color.fromARGB(199, 181, 223, 104),
          boxShadow: const [ BoxShadow(color: Color.fromARGB(197, 88, 172, 39), spreadRadius: 2, blurRadius: 2, offset: Offset(2, 2)) ]
        ),
        child: row,
      ),
    );
  }

  void initializeDefaultRow() {
    log( "##### INIT DEAFULT ROW" );
    row = Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // const SizedBox(width: 20),
            // const Icon(Icons.map_outlined),
            const SizedBox(width: 20),
            Column(
              children: [
                const SizedBox(height: 10),
                Text( widget.name, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold), ),
                Text( "Country: " + _country ),
                Text( "Pop: " + _pop.toString() ),
                const SizedBox(height: 10),
              ],
            ),
            const SizedBox(width: 20),
            OutlinedButton(onPressed: makeEditableFields, style: TextButton.styleFrom( side: const BorderSide(color: Colors.black26, width: 2) ), child: const Icon( Icons.edit ) ),
            const SizedBox(width: 20),
          ],
        );
  }

  void makeEditableFields() {
    setState(() {
      row = Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // const SizedBox(width: 20),
          // const Icon(Icons.map_outlined),
          const SizedBox(width: 20),
          Column(
            children: [
              const SizedBox(height: 10),
              Text( widget.name, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold), ),
              SizedBox( width: 200, height: 50, child: 
                TextField( onChanged: (capturedValue) {  _country = capturedValue; },
                  controller: TextEditingController(text: _country), decoration: InputDecoration( border: OutlineInputBorder( borderRadius: BorderRadius.circular(10) ), hintText: _country ) , style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold), )
              ),
              SizedBox( width: 200, height: 50, child: 
                TextField( onChanged: (capturedValue) { _pop = int.parse(capturedValue); },
                  controller: TextEditingController(text: _pop.toString() ), decoration: InputDecoration( border: OutlineInputBorder( borderRadius: BorderRadius.circular(10) ), hintText: _pop.toString() ) , style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold), )
              ),
              const SizedBox(height: 10),
            ],
          ),
          const SizedBox(width: 20),
          OutlinedButton(onPressed: () { saveEditedFields(); }, style: TextButton.styleFrom( side: const BorderSide(color: Colors.black26, width: 2) ), child: const Icon( Icons.save ) ),
          const SizedBox(width: 20),
        ],
      );
    });

  }

  void saveEditedFields() async {
    // 1. call PUT endpoint to update province
    // e.g.: curl -X 'PUT' 'http://localhost:8080/api/v1/province/Berlin/update?countryName=Germany&pop=234' -H 'accept: */*'

    String url = 'http://localhost:8080/api/v1/province/${widget.name}/update?countryName=${_country}&pop=${_pop}';
    print( url );

    try {
      final response = await dio.put(url);
      if( response.statusCode == 200 ) {
        log( "PUT update of Province successful" );
      }
    } catch(e) {
      log(e.toString());
    }

    // 2. switch back to saved layout with updated data
    setState(() {
      initializeDefaultRow();
    });
  }
}

// class ProvinceList2 extends StatefulWidget {
//   const ProvinceList2({super.key, required this.provinceList });

//   final List<ProvinceView2> provinceList;

//   void clearList() {
//     provinceList.clear();
//   }

//   void addList( List<ProvinceView2> list ) {
//     provinceList.addAll(list);
//   }

//   @override
//   State<ProvinceList2> createState() => _ProvinceList2State();
// }

// class _ProvinceList2State extends State<ProvinceList2> {
//   @override
//   Widget build(BuildContext context) {
//     for( final p in widget.provinceList ) {
//       log( "Content of ProvinceList2: " + p.name );
//     }

//     return Column(
//       children: widget.provinceList,
//       );
//   }
// }

class ProvinceList2 extends StatelessWidget {
  const ProvinceList2({super.key, required this.provinceList });

  final List<ProvinceView2> provinceList;

  @override
  Widget build(BuildContext context) {
    for( final p in provinceList ) {
      log( "Content of ProvinceList2: " + p.name );
    }
    return Column(
      children: provinceList,
      );
  }
}