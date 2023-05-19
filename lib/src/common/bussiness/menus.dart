import 'dart:convert';

import 'package:libero/src/http/webservice.dart';
import 'package:libero/src/model/menumodel.dart';

import '../apiendpoint.dart';

class ClMenu {
  Future<List<MenuModel>> loadMenuList(context, param) async {
    Map<dynamic, dynamic> results = {};
    await Webservice().loadHttp(context, apiLoadMenuListUrl,
        {'condition': jsonEncode(param)}).then((v) => {results = v});
    List<MenuModel> menuList = [];
    if (results['isLoad']) {
      menuList = [];
      for (var item in results['menus']) {
        menuList.add(MenuModel.fromJson(item));
      }
      return menuList;
    }
    return [];
  }
}
