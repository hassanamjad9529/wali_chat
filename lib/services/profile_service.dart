import 'package:get/get.dart';

class ProfileService extends GetxService {
  // Observable list of dummy profiles
  final RxList<Map<String, dynamic>> allProfiles = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();

    // Dummy profile data (can be replaced with API later)
    allProfiles.value = [
      {'id': '1', 'name': 'Aisha', 'sect': 'Sunni', 'prayerLevel': 'Regular', 'age': 25},
      {'id': '2', 'name': 'Omar', 'sect': 'Shia', 'prayerLevel': 'Occasional', 'age': 30},
      {'id': '3', 'name': 'Fatima', 'sect': 'Sunni', 'prayerLevel': 'Devout', 'age': 22},
      {'id': '4', 'name': 'Yusuf', 'sect': 'Sunni', 'prayerLevel': 'Regular', 'age': 28},
      {'id': '5', 'name': 'Zainab', 'sect': 'Shia', 'prayerLevel': 'Devout', 'age': 27},
      {'id': '6', 'name': 'Ali', 'sect': 'Sunni', 'prayerLevel': 'Occasional', 'age': 35},
      {'id': '7', 'name': 'Waleed', 'sect': 'Shia', 'prayerLevel': 'Regular', 'age': 29},
      {'id': '8', 'name': 'Maryam', 'sect': 'Sunni', 'prayerLevel': 'Devout', 'age': 24},
      {'id': '9', 'name': 'Khadija', 'sect': 'Shia', 'prayerLevel': 'Occasional', 'age': 31},
      {'id': '10', 'name': 'Ibrahim', 'sect': 'Sunni', 'prayerLevel': 'Regular', 'age': 26},
    ];
  }
}
