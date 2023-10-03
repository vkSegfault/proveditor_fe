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
          color: const Color.fromARGB(200, 100, 100, 250),
          boxShadow: const [ BoxShadow(color: Color.fromARGB(198, 10, 10, 250), spreadRadius: 2, blurRadius: 2, offset: Offset(2, 2)) ]
        ),
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