import 'dart:convert';

import 'package:cuacaapps/Screen/detailCuaca.dart';
import 'package:cuacaapps/services/api_static.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  List cuacaList = [];
  var cuacaTampung = {};
  List kotaList = [];
  var kotaTampung = {};
  late Future myFuture;
  List result = [];

  String provDKI = "DKI Jakarta";
  String provJawaTengah = "Jawa Tengah";
  String provJawaBarat = "Jawa Barat";
  String provJawaTimur = "Jawa Timur";
  String provDIY = "DI Yogyakarta";
  String provPapua = "Papua";

  DKIJakarta? selectedJakarta;
  List<DKIJakarta?> jakarta = [
    DKIJakarta(id: 501195, kota: "Jakarta Pusat"),
    DKIJakarta(id: 501196, kota: "Jakarta Utara"),
    DKIJakarta(id: 501193, kota: "Jakarta Selatan"),
    DKIJakarta(id: 501191, kota: "Jakarta Timur"),
    DKIJakarta(id: 501192, kota: "Jakarta Barat"),
  ];

  JawaTengah? selectedJateng;
  List<JawaTengah?> jateng = [
    JawaTengah(id: 501258, kota: "Kab.Banyumas", kecamatan: "Purwokerto"),
    JawaTengah(id: 501262, kota: "Kota Semarang", kecamatan: "Semarang"),
    JawaTengah(id: 501266, kota: "Kota Surakarta", kecamatan: "Surakarta"),
  ];

  JawaBarat? selectedJabar;
  List<JawaBarat?> jabar = [
    JawaBarat(id: 501212, kota: "Kota Bandung", kecamatan: "Bandung"),
    JawaBarat(id: 501219, kota: "Kab. Bekasi", kecamatan: "Cikarang"),
    JawaBarat(id: 501236, kota: "Kota Tasikmalaya", kecamatan: "Tasikmalaya"),
  ];

  JawaTimur? selectedJatim;
  List<JawaTimur?> jatim = [
    JawaTimur(id: 501306, kota: "Kota Surabaya", kecamatan: "Surabaya"),
    JawaTimur(id: 5002268, kota: "Kab. Kediri", kecamatan: "Kabupaten Kediri"),
    JawaTimur(id: 501290, kota: "Kota Malang", kecamatan: "Kota Malang"),
  ];

  DIYogyakarta? selectedDIY;
  List<DIYogyakarta?> diy = [
    DIYogyakarta(id: 501190, kota: "Kota Yogyakarta", kecamatan: "Yogyakarta"),
    DIYogyakarta(id: 501189, kota: "Kab. Gunung Kidul", kecamatan: "Wonosari"),
    DIYogyakarta(id: 501187, kota: "Kab. Sleman", kecamatan: "Sleman"),
  ];

  Papua? selectedPapua;
  List<Papua?> papua = [
    Papua(id: 501447, kota: "Kota Jayapura", kecamatan: "Jayapura"),
    Papua(id: 501450, kota: "Kab. Merauke", kecamatan: "Merauke"),
    Papua(id: 501443, kota: "Kab. Asmat", kecamatan: "Agats"),
  ];

  @override
  void initState() {
    myFuture = showDataCuaca();
    showDataKota();
    super.initState();
  }

  showDataCuaca() async {
    var res = await ApiStatic().getDataCuaca("cuaca/wilayah.json");
    var jsonData = json.decode(res.body);
    // print(jsonData);
    List datas = [];
    for (var u in jsonData) {
      cuacaTampung = {
        "id": u["id"],
        "propinsi": u["propinsi"],
        "kota": u["kota"],
        "kecamatan": u["kecamatan"],
        "lat": u["lat"],
        "lon": u["lon"],
      };
      cuacaList.add(cuacaTampung);
    }
    final jsonList = cuacaList.map((item) => jsonEncode(item)).toList();
    final uniqueJsonList = jsonList.toSet().toList();
    final result1 = uniqueJsonList.map((item) => jsonDecode(item)).toList();

    setState(() {
      result = result1;
    });
    return datas;
  }

  showDataKota() async {
    var res =
        await ApiStatic().getDataCuaca("cuaca/${selectedJakarta!.id}.json");
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
        backgroundColor: Colors.blue.shade400,
        title: Center(
          child: Text(
            "Cuaca Apps",
            style:
                TextStyle(fontFamily: 'PoppinsSemiBold', color: Colors.white),
          ),
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
                      padding: EdgeInsets.only(top: 10),
                      child: GridView(
                        gridDelegate:
                            const SliverGridDelegateWithMaxCrossAxisExtent(
                                maxCrossAxisExtent: 300,
                                crossAxisSpacing: 10,
                                mainAxisSpacing: 10,
                                mainAxisExtent: 270),
                        shrinkWrap: true,
                        children: [
                          Padding(
                            padding: EdgeInsets.all(13.0),
                            child: InkWell(
                              onTap: () {
                                Get.to(DetailKota(
                                  id: selectedJakarta!.id.toString(),
                                  propinsi: provDKI,
                                  kota: selectedJakarta!.kota.toString(),
                                  kecamatan: "",
                                  foto: "jakarta",
                                ));
                              },
                              child: Container(
                                width: 230,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: Colors.blue.shade300),
                                child: Stack(children: [
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(
                                            top: 15, left: 20, right: 20),
                                        child: Container(
                                          height: 120,
                                          width: 140,
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            child: SizedBox.fromSize(
                                              size: Size.fromRadius(48),
                                              child: Image.asset(
                                                'assets/img/jakarta.jpg',
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            EdgeInsets.only(top: 8, left: 20),
                                        child: Text(
                                          "DKI Jakarta",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontFamily: "PoppinsSemiBold",
                                              fontSize: 18),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(left: 20),
                                        child: DropdownButton<DKIJakarta>(
                                          hint: Text("Pilih Kota"),
                                          value: selectedJakarta,
                                          onChanged: (value) {
                                            setState(() {
                                              selectedJakarta = value;
                                              print(selectedJakarta!.id);
                                            });
                                          },
                                          items: jakarta
                                              .map<
                                                      DropdownMenuItem<
                                                          DKIJakarta>>(
                                                  (e) => DropdownMenuItem(
                                                        value: e,
                                                        child: Text(
                                                            (e?.kota ?? '')
                                                                .toString()),
                                                      ))
                                              .toList(),
                                        ),
                                      )
                                    ],
                                  ),
                                ]),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(13.0),
                            child: InkWell(
                              onTap: () {
                                Get.to(DetailKota(
                                  id: selectedJateng!.id.toString(),
                                  propinsi: provJawaTengah,
                                  kota: selectedJateng!.kota.toString(),
                                  kecamatan:
                                      selectedJateng!.kecamatan.toString(),
                                  foto: "jateng",
                                ));
                              },
                              child: Container(
                                width: 230,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: Colors.blue.shade300),
                                child: Stack(children: [
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(
                                            top: 15, left: 20, right: 20),
                                        child: Container(
                                          height: 120,
                                          width: 140,
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            child: SizedBox.fromSize(
                                              size: Size.fromRadius(48),
                                              child: Image.asset(
                                                'assets/img/jateng.jpg',
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            EdgeInsets.only(top: 8, left: 20),
                                        child: Text(
                                          "Jawa Tengah",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontFamily: "PoppinsSemiBold",
                                              fontSize: 18),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(left: 20),
                                        child: DropdownButton<JawaTengah>(
                                          hint: Text("Pilih Kota"),
                                          value: selectedJateng,
                                          onChanged: (value) {
                                            setState(() {
                                              selectedJateng = value;
                                              print(selectedJateng!.id);
                                            });
                                          },
                                          items: jateng
                                              .map<
                                                      DropdownMenuItem<
                                                          JawaTengah>>(
                                                  (e) => DropdownMenuItem(
                                                        value: e,
                                                        child: Text(
                                                            (e?.kota ?? '')
                                                                .toString()),
                                                      ))
                                              .toList(),
                                        ),
                                      )
                                    ],
                                  ),
                                ]),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(13.0),
                            child: InkWell(
                              onTap: () {
                                Get.to(DetailKota(
                                  id: selectedJabar!.id.toString(),
                                  propinsi: provJawaBarat,
                                  kota: selectedJabar!.kota.toString(),
                                  kecamatan:
                                      selectedJabar!.kecamatan.toString(),
                                  foto: "jabar",
                                ));
                              },
                              child: Container(
                                width: 230,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: Colors.blue.shade300),
                                child: Stack(children: [
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(
                                            top: 15, left: 20, right: 20),
                                        child: Container(
                                          height: 120,
                                          width: 140,
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            child: SizedBox.fromSize(
                                              size: Size.fromRadius(48),
                                              child: Image.asset(
                                                'assets/img/jabar.jpg',
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            EdgeInsets.only(top: 8, left: 20),
                                        child: Text(
                                          "Jawa Barat",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontFamily: "PoppinsSemiBold",
                                              fontSize: 18),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(left: 20),
                                        child: DropdownButton<JawaBarat>(
                                          hint: Text("Pilih Kota"),
                                          value: selectedJabar,
                                          onChanged: (value) {
                                            setState(() {
                                              selectedJabar = value;
                                              print(selectedJabar!.id);
                                            });
                                          },
                                          items: jabar
                                              .map<DropdownMenuItem<JawaBarat>>(
                                                  (e) => DropdownMenuItem(
                                                        value: e,
                                                        child: Text(
                                                            (e?.kota ?? '')
                                                                .toString()),
                                                      ))
                                              .toList(),
                                        ),
                                      )
                                    ],
                                  ),
                                ]),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(13.0),
                            child: InkWell(
                              onTap: () {
                                Get.to(DetailKota(
                                  id: selectedJatim!.id.toString(),
                                  propinsi: provJawaTimur,
                                  kota: selectedJatim!.kota.toString(),
                                  kecamatan:
                                      selectedJatim!.kecamatan.toString(),
                                  foto: "jatim",
                                ));
                              },
                              child: Container(
                                width: 230,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: Colors.blue.shade300),
                                child: Stack(children: [
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(
                                            top: 15, left: 20, right: 20),
                                        child: Container(
                                          height: 120,
                                          width: 140,
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            child: SizedBox.fromSize(
                                              size: Size.fromRadius(48),
                                              child: Image.asset(
                                                'assets/img/jatim.jpg',
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            EdgeInsets.only(top: 8, left: 20),
                                        child: Text(
                                          "Jawa Timur",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontFamily: "PoppinsSemiBold",
                                              fontSize: 18),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(left: 20),
                                        child: DropdownButton<JawaTimur>(
                                          hint: Text("Pilih Kota"),
                                          value: selectedJatim,
                                          onChanged: (value) {
                                            setState(() {
                                              selectedJatim = value;
                                              print(selectedJatim!.id);
                                            });
                                          },
                                          items: jatim
                                              .map<DropdownMenuItem<JawaTimur>>(
                                                  (e) => DropdownMenuItem(
                                                        value: e,
                                                        child: Text(
                                                            (e?.kota ?? '')
                                                                .toString()),
                                                      ))
                                              .toList(),
                                        ),
                                      )
                                    ],
                                  ),
                                ]),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(13.0),
                            child: InkWell(
                              onTap: () {
                                Get.to(DetailKota(
                                  id: selectedDIY!.id.toString(),
                                  propinsi: provDIY,
                                  kota: selectedDIY!.kota.toString(),
                                  kecamatan: selectedDIY!.kecamatan.toString(),
                                  foto: "jogja",
                                ));
                              },
                              child: Container(
                                width: 230,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: Colors.blue.shade300),
                                child: Stack(children: [
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(
                                            top: 15, left: 20, right: 20),
                                        child: Container(
                                          height: 120,
                                          width: 140,
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            child: SizedBox.fromSize(
                                              size: Size.fromRadius(48),
                                              child: Image.asset(
                                                'assets/img/jogja.jpg',
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            EdgeInsets.only(top: 8, left: 15),
                                        child: Text(
                                          "DI Yogyakarta",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontFamily: "PoppinsSemiBold",
                                              fontSize: 18),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(left: 15),
                                        child: DropdownButton<DIYogyakarta>(
                                          hint: Text("Pilih Kota"),
                                          value: selectedDIY,
                                          onChanged: (value) {
                                            setState(() {
                                              selectedDIY = value;
                                              print(selectedDIY!.id);
                                            });
                                          },
                                          items: diy
                                              .map<
                                                      DropdownMenuItem<
                                                          DIYogyakarta>>(
                                                  (e) => DropdownMenuItem(
                                                        value: e,
                                                        child: Text(
                                                            (e?.kota ?? '')
                                                                .toString()),
                                                      ))
                                              .toList(),
                                        ),
                                      )
                                    ],
                                  ),
                                ]),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(13.0),
                            child: InkWell(
                              onTap: () {
                                Get.to(DetailKota(
                                  id: selectedPapua!.id.toString(),
                                  propinsi: provPapua,
                                  kota: selectedPapua!.kota.toString(),
                                  kecamatan:
                                      selectedPapua!.kecamatan.toString(),
                                  foto: "papua",
                                ));
                              },
                              child: Container(
                                width: 230,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: Colors.blue.shade300),
                                child: Stack(children: [
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(
                                            top: 15, left: 20, right: 20),
                                        child: Container(
                                          height: 120,
                                          width: 140,
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            child: SizedBox.fromSize(
                                              size: Size.fromRadius(48),
                                              child: Image.asset(
                                                'assets/img/papua.jpg',
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            EdgeInsets.only(top: 8, left: 20),
                                        child: Text(
                                          "Papua",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontFamily: "PoppinsSemiBold",
                                              fontSize: 18),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(left: 20),
                                        child: DropdownButton<Papua>(
                                          hint: Text("Pilih Kota"),
                                          value: selectedPapua,
                                          onChanged: (value) {
                                            setState(() {
                                              selectedPapua = value;
                                              print(selectedPapua!.id);
                                            });
                                          },
                                          items: papua
                                              .map<DropdownMenuItem<Papua>>(
                                                  (e) => DropdownMenuItem(
                                                        value: e,
                                                        child: Text(
                                                            (e?.kota ?? '')
                                                                .toString()),
                                                      ))
                                              .toList(),
                                        ),
                                      )
                                    ],
                                  ),
                                ]),
                              ),
                            ),
                          ),
                        ],
                      ));
                }
              })),
    );
  }
}

class DKIJakarta {
  int? id;
  String? kota;
  String? kecamatan;

  DKIJakarta({this.id, this.kota, this.kecamatan});
}

class JawaTengah {
  int? id;
  String? kota;
  String? kecamatan;

  JawaTengah({this.id, this.kota, this.kecamatan});
}

class JawaBarat {
  int? id;
  String? kota;
  String? kecamatan;

  JawaBarat({this.id, this.kota, this.kecamatan});
}

class JawaTimur {
  int? id;
  String? kota;
  String? kecamatan;

  JawaTimur({this.id, this.kota, this.kecamatan});
}

class DIYogyakarta {
  int? id;
  String? kota;
  String? kecamatan;

  DIYogyakarta({this.id, this.kota, this.kecamatan});
}

class Papua {
  int? id;
  String? kota;
  String? kecamatan;

  Papua({this.id, this.kota, this.kecamatan});
}

// DropdownButton<CuacaMacam>(
//                                     hint: Text("DKI Jakarta"),
//                                     style: TextStyle(
//                                         fontFamily: 'Poppins',
//                                         fontSize: 18,
//                                         color: Colors.black),
//                                     value: selectedValue,
//                                     onChanged: (value) {
//                                       setState(() {
//                                         selectedValue = value;
//                                         print(selectedValue!.id);

//                                       });
//                                     },
//                                     items: category
//                                         .map<DropdownMenuItem<CuacaMacam>>(
//                                             (e) => DropdownMenuItem(
//                                                   value: e,
//                                                   child: Text(
//                                                       (e?.name ?? '').toString()),
//                                                 ))
//                                         .toList(),
//                                   ),
