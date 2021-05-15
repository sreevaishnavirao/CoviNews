import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_maps/maps.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:clay_containers/clay_containers.dart';

class CovidStats extends StatefulWidget {
  CovidStats({Key key}) : super(key: key);

  @override
  _CovidStatsState createState() => _CovidStatsState();
}

class _CovidStatsState extends State<CovidStats> {
  MapShapeSource _dataSource;
  List<MapModel> _mapData;
  Map da;
  MapZoomPanBehavior _zoomPanBehavior;
  int selectedIndex = 0;
  String headd = 'India';

  String confirmed = '...', active = '...', recovered = '...', deaths = '...';

  Future<Null> getCovStats() async {
    var url = Uri.parse('https://api.covid19india.org/data.json');
    var response = await http.get(url);
    Map data = jsonDecode(response.body);

    // print(data['statewise'][1]['state']);
    setState(() {
      da = data;
      confirmed = data['statewise'][0]['confirmed'];
      active = data['statewise'][0]['active'];
      recovered = data['statewise'][0]['recovered'];
      deaths = data['statewise'][0]['deaths'];
    });
  }

  @override
  void initState() {
    _mapData = _getMapData();
    _dataSource = MapShapeSource.asset('assets/india.json',
        shapeDataField: 'st_nm',
        dataCount: _mapData.length,
        primaryValueMapper: (int index) => _mapData[index].state,
        dataLabelMapper: (int index) => _mapData[index].stateCode,
        shapeColorValueMapper: (int index) => Colors.black87);
    _zoomPanBehavior = MapZoomPanBehavior(
      zoomLevel: 1.3,
    );

    getCovStats();
    
    super.initState();
  }

  void onc(int index) {
    int temp;

    if (index > 7 && index < 17) {
      temp = index;
    } else if (index >= 30) {
      temp = index + 2;
    } else {
      temp = index + 1;
    }

    setState(() {
      selectedIndex = index;
      headd = _mapData[index].state;
      confirmed = da['statewise'][temp]['confirmed'];
      active = da['statewise'][temp]['active'];
      recovered = da['statewise'][temp]['recovered'];
      deaths = da['statewise'][temp]['deaths'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 4.0),
        
        padding: EdgeInsets.all(0.0),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(15)),
            color: Colors.grey[900]),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: ClayContainer(
                height: 280,
                emboss: true,
                color: Colors.grey[900],
                borderRadius: 30,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      headd.toUpperCase(),
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.5,
                          fontSize: 20),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          height: 110,
                          width: 150,
                          decoration: BoxDecoration(
                              color: Colors.amberAccent.withOpacity(0.7),
                              borderRadius: BorderRadius.all(Radius.circular(15)),
                              gradient: LinearGradient(
                                begin: Alignment.topRight,
                                end: Alignment.bottomLeft,
                                colors: [
                                  Colors.black,
                                  Colors.grey[600],
                                ],
                              )),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Image(
                                image: AssetImage("assets/patient.png"),
                                height: 50,
                                width: 60,
                                color: Colors.amber,
                              ),
                              Text(
                                confirmed,
                                style: TextStyle(
                                    fontWeight: FontWeight.normal,
                                    letterSpacing: 1.5,
                                    fontSize: 20),
                              ),
                              Text(
                                "CONFIRMED",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 2,
                                    color: Colors.amber,
                                    fontSize: 12),
                              )
                            ],
                          ),
                        ),
                        Container(
                          height: 110,
                          width: 150,
                          decoration: BoxDecoration(
                              color: Colors.amberAccent.withOpacity(0.7),
                              borderRadius: BorderRadius.all(Radius.circular(15)),
                              gradient: LinearGradient(
                                begin: Alignment.topRight,
                                end: Alignment.bottomLeft,
                                colors: [
                                  Colors.black87,
                                  Colors.grey[600],
                                ],
                              )),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Image(
                                image: AssetImage("assets/cough.png"),
                                height: 50,
                                color: Colors.lightBlue[400],
                                width: 60,
                              ),
                              Text(
                                active,
                                style: TextStyle(
                                    fontWeight: FontWeight.normal,
                                    letterSpacing: 1.5,
                                    fontSize: 20),
                              ),
                              Text(
                                "ACTIVE",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 2,
                                    color: Colors.lightBlue[400],
                                    fontSize: 12),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          height: 110,
                          width: 150,
                          decoration: BoxDecoration(
                              color: Colors.amberAccent.withOpacity(0.7),
                              borderRadius: BorderRadius.all(Radius.circular(15)),
                              gradient: LinearGradient(
                                begin: Alignment.topRight,
                                end: Alignment.bottomLeft,
                                colors: [
                                  Colors.black87,
                                  Colors.grey[600],
                                ],
                              )),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Image(
                                image: AssetImage("assets/mask.png"),
                                height: 50,
                                width: 60,
                                color: Colors.lightGreen[500],
                              ),
                              Text(
                                recovered,
                                style: TextStyle(
                                    fontWeight: FontWeight.normal,
                                    letterSpacing: 1.5,
                                    fontSize: 20),
                              ),
                              Text(
                                "RECOVERED",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 2,
                                    color: Colors.lightGreen[500],
                                    fontSize: 12),
                              )
                            ],
                          ),
                        ),
                        Container(
                          height: 110,
                          width: 150,
                          decoration: BoxDecoration(
                              color: Colors.amberAccent.withOpacity(0.7),
                              borderRadius: BorderRadius.all(Radius.circular(15)),
                              gradient: LinearGradient(
                                begin: Alignment.topRight,
                                end: Alignment.bottomLeft,
                                colors: [
                                  Colors.black87,
                                  Colors.grey[600],
                                ],
                              )),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Image(
                                image: AssetImage("assets/memorial.png"),
                                height: 50,
                                width: 60,
                                color: Colors.redAccent,
                              ),
                              
                              Text(
                                deaths,
                                style: TextStyle(
                                    fontWeight: FontWeight.normal,
                                    letterSpacing: 1.5,
                                    fontSize: 20),
                              ),
                              Text(
                                "DEATHS",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 2,
                                    color: Colors.redAccent,
                                    fontSize: 12),
                              )
                            ],
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),

//????????????MAPPPPPPP??//

            Expanded(
              child: Container(
                padding: EdgeInsets.only(top: 1),
                child: SfMaps(
                  layers: [
                    MapShapeLayer(
                      source: _dataSource,
                      showDataLabels: true,
                      shapeTooltipBuilder: (BuildContext context, int index) {
                        return Padding(
                          padding: EdgeInsets.all(7),
                          child: Text(
                            _mapData[index].state,
                            style: TextStyle(color: Colors.white),
                          ),
                        );
                      },
                      tooltipSettings: MapTooltipSettings(color: Colors.black),
                      selectedIndex: selectedIndex,
                      onSelectionChanged: onc,
                      // loadingBuilder: (BuildContext context) {
                      //   return Container(
                      //     height: 25,
                      //     width: 25,
                      //     child: const CircularProgressIndicator(
                      //       strokeWidth: 3,
                      //     ),
                      //   );
                      // },
                      zoomPanBehavior: _zoomPanBehavior,
                      selectionSettings: MapSelectionSettings(
                        color: Colors.grey,
                        strokeColor: Colors.red[900],
                        strokeWidth: 2,
                      ),
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

  static List<MapModel> _getMapData() {
    return <MapModel>[
      MapModel('Andaman and Nicobar Islands', 'AN'),
      MapModel('Andhra Pradesh', 'AP'),
      MapModel('Arunanchal Pradesh', 'AR'),
      MapModel('Assam', 'AS'),
      MapModel('Bihar', 'BR'),
      MapModel('Chandigarh', 'CH'),
      MapModel('Chhattisgarh', 'CT'),
      MapModel('Dadra and Nagar Haveli', 'DN'),
      MapModel('Daman and Diu', 'DD'),
      MapModel('Delhi', 'DL'),
      MapModel('Goa', 'GA'),
      MapModel('Gujarat', 'GJ'),
      MapModel('Haryana', 'HR'),
      MapModel('Himachal Pradesh', 'HP'),
      MapModel('Jammu and Kashmir', 'JK'),
      MapModel('Jharkhand', 'JH'),
      MapModel('Karnataka', 'KA'),
      MapModel('Kerala', 'KL'),
      MapModel('Lakshadweep', 'LD'),
      MapModel('Madhya Pradesh', 'MP'),
      MapModel('Maharashtra', 'MH'),
      MapModel('Manipur', 'MN'),
      MapModel('Meghalaya', 'ML'),
      MapModel('Mizoram', 'MZ'),
      MapModel('Nagaland', 'NL'),
      MapModel('Odisha', 'OD'),
      MapModel('Puducherry', 'PY'),
      MapModel('Punjab', 'PB'),
      MapModel('Rajasthan', 'RJ'),
      MapModel('Sikkim', 'SK'),
      MapModel('Tamil Nadu', 'TN'),
      MapModel('Telangana', 'TG'),
      MapModel('Tripura', 'TR'),
      MapModel('Uttar Pradesh', 'UP'),
      MapModel('Uttarakhand', 'UT'),
      MapModel('West Bengal', 'WB'),
    ];
  }
}

class MapModel {
  MapModel(this.state, this.stateCode);

  String state;

  String stateCode;
}
