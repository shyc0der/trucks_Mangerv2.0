import 'package:get/get.dart';
import 'package:trucks_manager/src/models/user_model.dart';

import '../ui/widgets/user_widget.dart';

class UserModule extends GetxController {
  final UserModel userModel = UserModel();
  Rx<UserModel> currentUser = Rx(UserModel());
  RxList<UserModel> users = <UserModel>[].obs;
  RxBool isSuperUser = false.obs;
  RxBool isSuperCustomer = false.obs;

  Future<UserModel> getUserById(String userId) async {
    final userMap = await userModel.fetchDataById(userId);
    return UserModel.fromMap({'id': userMap.id, ...(userMap.data() ?? {})});
  }

  Future<void> setCurrentUser(String userId) async {
    final user = await getUserById(userId);
    currentUser.value = user;
    isSuperUser.value = user.role == UserWidgetType.admin ||
        user.role == UserWidgetType.manager;
    isSuperUser.value = user.role == UserWidgetType.customer;
  }

  Stream<List<UserModel>> fetchUsers() {
    return userModel.fetchStreamsData().map<List<UserModel>>((streams) {
      return streams.docs
          .map<UserModel>(
              (doc) => UserModel.fromMap({'id': doc.id, ...doc.data() as Map}))
          .toList();
    });
  }

  bool isCustomer = false;
  Stream<List<UserModel>> fetchUsersWhere(isCustomer) {
    if (isCustomer == true) {
      return userModel
          .fetchStreamsDataWhere('role', isEqualTo: 'customer')
          .map<List<UserModel>>((streams) {
        return streams.docs
            .map<UserModel>((doc) =>
                UserModel.fromMap({'id': doc.id, ...doc.data() as Map}))
            .toList();
      });
    }
    return userModel.fetchStreamsDataWhere('role', isNotEqualTo: 'customer').map<List<UserModel>>((streams) {
      return streams.docs
          .map<UserModel>(
              (doc) => UserModel.fromMap({'id': doc.id, ...doc.data() as Map}))
          .toList();
    });
  }

  Future<List<UserModel>> fetchListUsers() async {
    final user = await userModel.fetchData();

    final useList = user
        .map((doc) => UserModel.fromMap({'id': doc.id, ...doc.data()}))
        .toList();

    return useList;
  }
}
