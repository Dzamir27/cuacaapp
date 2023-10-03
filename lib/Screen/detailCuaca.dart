import 'dart:convert';

import 'package:cuacaapps/services/api_static.dart';
import 'package:flutter/material.dart';

class DetailKota extends StatefulWidget {
  final String id;
  final String propinsi;
  final String kota;
  final String kecamatan;
  final String foto;

  const DetailKota({
    Key? key,
    required this.id,
    required this.propinsi,
    required this.kota,
    required this.kecamatan,
    required this.foto,
  }) : super(key: key);
  // const DetailKota({super.key});

  @override
  State<DetailKota> createState() => _DetailKotaState();
}

class _DetailKotaState extends State<DetailKota> {
  late Future myFuture;
  List kotaList = [];
  var kotaTampung = {};

  @override
  void initState() {
    myFuture = showDataKota();
    super.initState();
  }

  showDataKota() async {
    var res = await ApiStatic().getDataCuaca("cuaca/${widget.id}.json");
    var jsonData = json.decode(res.body);
    // print(jsonData);
    List datas = [];
    for (var u in jsonData) {
      kotaTampung = {
        "jamCuaca": u["jamCuaca"],
        "kodeCuaca": u["kodeCuaca"],
        "cuaca": u["cuaca"],
        "humidity": u["humidity"],
        "tempC": u["tempC"],
        "tempF": u["tempF"],
      };
      kotaList.add(kotaTampung);
    }
    return datas;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.blue.shade200,

      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Colors.blue.shade400,
        title: Text(
          widget.kota,
          style: TextStyle(fontFamily: 'PoppinsSemiBold', color: Colors.white),
        ),
      ),
      body: SafeArea(
          child: FutureBuilder(
              future: myFuture,
              builder: (context, snapshot) {
                if (snapshot.hasData == false) {
                  print(snapshot);
                  return Container(
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                } else {
                  return Container(
                    child: Column(
                      children: [
                        Padding(
                            padding: EdgeInsets.only(bottom: 1),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                        image: DecorationImage(
                                            image: AssetImage(
                                                "assets/img/${widget.foto.toString()}.jpg"),
                                            fit: BoxFit.fill,
                                            opacity: 40)),
                                    child: Column(
                                      children: [
                                        Container(
                                          padding: EdgeInsets.only(top: 20),
                                          child: Text(
                                            widget.propinsi,
                                            style: TextStyle(
                                                fontSize: 30,
                                                color: Colors.white,
                                                fontFamily: 'PoppinsSemiBold'),
                                          ),
                                        ),
                                        Container(
                                          padding: EdgeInsets.only(top: 10),
                                          child: Text(
                                            widget.kota,
                                            style: TextStyle(
                                                fontFamily: 'PoppinsSemiBold',
                                                color: Colors.white),
                                          ),
                                        ),
                                        Container(
                                          padding: EdgeInsets.only(top: 10),
                                          child: Text(
                                            widget.kecamatan,
                                            style: TextStyle(
                                                fontFamily: 'PoppinsSemiBold',
                                                color: Colors.white),
                                          ),
                                        ),
                                        Image.asset('assets/img/wave.png')
                                      ],
                                    ),
                                  ),
                                ])),
                        Expanded(
                          child: GridView.builder(
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              gridDelegate:
                                  const SliverGridDelegateWithMaxCrossAxisExtent(
                                      maxCrossAxisExtent: 300,
                                      crossAxisSpacing: 10,
                                      mainAxisSpacing: 10,
                                      mainAxisExtent: 270),
                              itemCount: kotaList.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: EdgeInsets.all(13.0),
                                  child: InkWell(
                                    onTap: () {},
                                    child: Container(
                                      width: 230,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          color: Colors.blue.shade400),
                                      child: Stack(children: [
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.stretch,
                                          children: [
                                            Padding(
                                              padding: EdgeInsets.only(
                                                  top: 8, left: 20, right: 20),
                                              child: Container(
                                                height: 120,
                                                width: 140,
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                  child: SizedBox.fromSize(
                                                    size: Size.fromRadius(48),
                                                    child: Image.asset(
                                                      "assets/img/${kotaList[index]["kodeCuaca"]}.png",
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.only(
                                                  top: 1, left: 69),
                                              child: Text(
                                                "${kotaList[index]["tempC"]}°",
                                                style: TextStyle(
                                                    fontSize: 30,
                                                    color: Colors.white),
                                              ),
                                            ),
                                            kotaList[index]["cuaca"] == ''
                                                ? Padding(
                                                    padding: EdgeInsets.only(
                                                        top: 7, left: 10),
                                                    child: Text(
                                                        "Belum Diketahui",
                                                        style: TextStyle(
                                                            fontFamily:
                                                                'Poppins',
                                                            color: Colors.white,
                                                            fontSize: 18)),
                                                  )
                                                : Padding(
                                                    padding: EdgeInsets.only(
                                                        top: 7, left: 10),
                                                    child: Text(
                                                        kotaList[index]
                                                            ["cuaca"],
                                                        style: TextStyle(
                                                            fontFamily:
                                                                'Poppins',
                                                            color: Colors.white,
                                                            fontSize: 18)),
                                                  ),
                                            Padding(
                                              padding: EdgeInsets.only(
                                                  top: 5, left: 10),
                                              child: Text(
                                                "${kotaList[index]["jamCuaca"]}",
                                                style: TextStyle(
                                                    fontFamily: 'Poppins',
                                                    color: Colors.white,
                                                    fontSize: 15),
                                              ),
                                            )
                                          ],
                                        ),
                                      ]),
                                    ),
                                  ),
                                );
                              }),
                        ),
                      ],
                    ),
                  );
                }
              })),
    );
  }
}
