import 'package:libero/src/common/const.dart';
import 'package:flutter/material.dart';

import 'package:libero/src/common/apiendpoint.dart';
import 'package:libero/src/interface/connect/reserve/connect_reserve_menu.dart';
import 'package:libero/src/interface/connect/reserve/reserve_multiuser.dart';
import 'package:libero/src/model/organmodel.dart';
import 'package:libero/src/common/bussiness/organs.dart';
import 'package:libero/src/interface/component/form/main_form.dart';
import '../../../common/globals.dart' as globals;

class ConnectReserveOrgan extends StatefulWidget {
  const ConnectReserveOrgan({Key? key}) : super(key: key);

  @override
  _ConnectReserveOrgan createState() => _ConnectReserveOrgan();
}

class _ConnectReserveOrgan extends State<ConnectReserveOrgan> {
  late Future<List> loadData;

  List<OrganModel> organs = [];

  @override
  void initState() {
    super.initState();
    loadData = initLoadData();
  }

  Future<List> initLoadData() async {
    organs = await ClOrgan().loadOrganList(context, APPCOMANYID);

    if (organs.length == 1) {
      Navigator.push(context, MaterialPageRoute(builder: (_) {
        return ReserveMultiUser(
          organId: organs.first.organId, 
          isNoReserveType: organs.first.isNoReserveType,
        );
      }));
    }
    return organs;
  }

  @override
  Widget build(BuildContext context) {
    return MainForm(
      title: '予約店舗',
      render: Center(
        child: FutureBuilder<List>(
          future: loadData,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return GridView.count(
                  padding: EdgeInsets.all(12),
                  crossAxisCount: 2,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 16,
                  childAspectRatio: 0.95,
                  children: [
                    ...organs.map((d) => _getOrganContent(d)),
                  ]);
            } else if (snapshot.hasError) {
              return Text("${snapshot.error}");
            }

            // // By default, show a loading spinner.
            return CircularProgressIndicator();
          },
        ),
      ),
    );
  }

  Widget _getOrganContent(OrganModel organ) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (_) {
          if(organ.isNoReserveType == constCheckinReserveRiRa){
            return ReserveMultiUser(
              organId: organ.organId, 
              isNoReserveType: constCheckinReserveRiRa
            );
          } else {
            globals.selStaffType = 0;
            globals.menuSelectNumber = 1;
            globals.reserveMultiUsers = [];
            globals.connectReserveMenuList = [];
            globals.reserveTime = 10;
            globals.reserveUserCnt = 1;
            return ConnectReserveMenus(
              organId: organ.organId, 
              isNoReserveType: constCheckinReserveShift,
            );
          }
        }));
      },
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: Column(
          children: [
            Expanded(child: _getOrganImage(organ)),
            _getOrganTitle(organ)
          ],
        ),
        elevation: 4,
        shadowColor: Colors.grey,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(12))),
      ),
    );
  }

  Widget _getOrganImage(OrganModel organ) {
    String? imageUrl = organ.organImage;
    Color color = organ.isNoReserveType == constCheckinReserveRiRa 
      ? Color.fromARGB(126, 255, 107, 107) 
      : Color.fromARGB(127, 0, 114, 180);
    return Stack(
      children: [
        Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Colors.grey,
            image: imageUrl == null
                ? DecorationImage(
                    image: AssetImage('images/no_image.jpg'), fit: BoxFit.cover)
                : DecorationImage(
                    image: NetworkImage(organImageUrl + imageUrl),
                    fit: BoxFit.cover),
          ),
        ),
        Positioned(
          left: -20,
          top: 60,
          child: Container(
            alignment: Alignment.center,
            width: 115,
            height: 30,
            child: RotationTransition(
              alignment: Alignment.topLeft,
              turns: AlwaysStoppedAnimation(-45 / 360),
              child: Container(
                margin: EdgeInsets.symmetric(vertical: 5, horizontal: 0),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: color,
                ),
                child: Text(
                  organ.isNoReserveType == constCheckinReserveRiRa ? "出勤スタッフ" : "シフト枠",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.normal,
                    fontSize: 12
                  ),
                ),
              ),
            ),
          )
        )
      ],
    );
  }

  Widget _getOrganTitle(organ) {
    return Stack(
      children: [
        Container(
          margin: EdgeInsets.all(8),
          padding: EdgeInsets.all(6),
          alignment: Alignment.center,
          decoration: BoxDecoration(
              color: Color(0xFF709a49), borderRadius: BorderRadius.circular(6)),
          child: Text(
            organ.organName,
            style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
          ),
        ),
        Positioned(
          right: 16,
          top: 16,
          child: Container(
            alignment: Alignment.center,
            width: 16,
            height: 16,
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(20)),
            child: Icon(Icons.keyboard_arrow_right,
                color: Color(0xFF709a49), size: 16),
          ),
        )
      ],
    );
  }
}
