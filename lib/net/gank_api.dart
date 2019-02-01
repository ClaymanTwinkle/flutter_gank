import 'package:flutter_gank/net/http_util.dart';
import 'dart:convert';

class GankApi {
  static const String _AUTHORITY = "gank.io";

  static Future<Map<String, dynamic>> getToday() {
    return HttpUtil.get(_AUTHORITY, "/api/today").then((String value) {
      print(value);
      return json.decode(value);
    });
  }

  /// 根据类型获取数据
  /// @type 福利 | Android | iOS | 休息视频 | 拓展资源 | 前端 | all
  /// @page 第几页：数字，大于0
  /// @count 请求个数： 数字，大于0
  static Future<Map<String, dynamic>> getDataByType(
      String type, int page, int count) {
    return HttpUtil.get(_AUTHORITY, "/api/data/$type/$count/$page")
        .then((String value) {
      print(value);
      return json.decode(value);
    });
  }

  static Future<Map<String, dynamic>> getXianDuCategories() {
    return HttpUtil.get(_AUTHORITY, "/api/xiandu/categories")
        .then((String value) {
      print(value);
      return json.decode(value);
    });
  }

  static Future<Map<String, dynamic>> getXianDuSubCategory(String enName) {
    return HttpUtil.get(_AUTHORITY, "/api/xiandu/category/$enName")
        .then((String value) {
      print(value);
      return json.decode(value);
    });
  }

  static Future<Map<String, dynamic>> getXianDuPage(
      String id, int page, int count) {
    return HttpUtil.get(
            _AUTHORITY, "/api/xiandu/data/id/$id/count/$count/page/$page")
        .then((String value) {
      print(value);
      return json.decode(value);
    });
  }
}
