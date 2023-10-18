import 'package:flutter/material.dart';

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
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: const Color.fromARGB(199, 181, 223, 104),
          boxShadow: const [ BoxShadow(color: Color.fromARGB(197, 88, 172, 39), spreadRadius: 2, blurRadius: 2, offset: Offset(2, 2)) ]
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // const SizedBox(width: 20),
            // const Icon(Icons.map_outlined),
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
            OutlinedButton(onPressed: makeEditableFields, style: TextButton.styleFrom( side: const BorderSide(color: Colors.black26, width: 2) ), child: const Icon( Icons.edit ) ),
            const SizedBox(width: 20),
          ],
        ),
      ),
    );
  }

  void makeEditableFields() {
    print("Edit Button clicked");
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

class ProvinceView2 extends StatefulWidget {
  const ProvinceView2({super.key, this.name = "ERROR", this.country = "ERROR", this.pop = -1});

  final String name;
  final String country;
  final int pop;

  @override
  State<ProvinceView2> createState() => _ProvinceView2State();
}

class _ProvinceView2State extends State<ProvinceView2> {

  Widget row = const Row();

  @override
  void initState() {
    super.initState();

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
                Text( "Country: " + widget.country ),
                Text( "Pop: " + widget.pop.toString() ),
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
                TextField( onSubmitted: (str) { widget.country = str }, controller: TextEditingController(text: widget.country), decoration: InputDecoration( border: OutlineInputBorder( borderRadius: BorderRadius.circular(10) ), hintText: widget.country ) , style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold), )
              ),
              SizedBox( width: 200, height: 50, child: 
                TextField( onSubmitted: (str) {}, controller: TextEditingController(text: widget.pop.toString() ), decoration: InputDecoration( border: OutlineInputBorder( borderRadius: BorderRadius.circular(10) ), hintText: widget.pop.toString() ) , style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold), )
              ),
              // Text( "Country: " + widget.country ),
              // Text( "DUPA: " + widget.pop.toString() ),
              const SizedBox(height: 10),
            ],
          ),
          const SizedBox(width: 20),
          OutlinedButton(onPressed: makeEditableFields, style: TextButton.styleFrom( side: const BorderSide(color: Colors.black26, width: 2) ), child: const Icon( Icons.save ) ),
          const SizedBox(width: 20),
        ],
      );
    });

  }

  void saveEditedFields() {

  }
}

class ProvinceList2 extends StatefulWidget {
  const ProvinceList2({super.key, required this.provinceList });

  final List<ProvinceView2> provinceList;

  @override
  State<ProvinceList2> createState() => _ProvinceList2State();
}

class _ProvinceList2State extends State<ProvinceList2> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: widget.provinceList,
      );
  }
}

// class ProvinceList2 extends StatelessWidget {
//   const ProvinceList2({super.key, required this.provinceList });

//   final List<ProvinceView2> provinceList;

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: provinceList,
//       );
//   }
// }