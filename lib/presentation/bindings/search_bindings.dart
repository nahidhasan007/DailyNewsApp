import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/bindings_interface.dart';


class SearchBinding extends Bindings {
  @override
  void dependencies() {
    // Reusing news repository for search functionality
    Get.lazyPut<SearchController>(() => SearchController(), fenix: true);
  }
}