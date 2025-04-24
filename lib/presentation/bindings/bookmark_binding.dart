import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/bindings_interface.dart';
import 'package:newsapp/domainlayer/repostories/auth_repository.dart';

import '../../domainlayer/repostories/bookmark_repository.dart';
import '../controllers/bookmark_controller.dart';

class BookmarkBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BookmarkController>(() => BookmarkController(Get.find<BookmarkRepository>(), Get.find<AuthRepository>()), fenix: true);
  }
}