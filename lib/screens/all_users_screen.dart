import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:wali_project/components/utils/utils.dart';
import 'package:wali_project/controllers/favorites_controller.dart';
import 'package:wali_project/screens/chat_screen.dart';
import 'package:wali_project/screens/favorite_screen.dart';

class AllUsersScreen extends StatelessWidget {
  final RxString selectedSect = 'Any'.obs;
  final RxString selectedPrayerLevel = 'Any'.obs;
  final GetStorage storage = GetStorage();
  // final RxList<String> likedProfiles = <String>[].obs;

  // AllUsersScreen() {
  //   // Register likedProfiles with a tag for shared access
  //   Get.put<RxList<String>>(likedProfiles, tag: 'likedProfiles');
  // }
  final FavoritesController favController = Get.put(FavoritesController());

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;
    final maxCardWidth = isMobile ? screenWidth : 1000.0;
    final padding = isMobile ? 12.0 : 16.0;
    final titleFontSize = isMobile ? 22.0 : 24.0;
    final listFontSize = isMobile ? 14.0 : 16.0;

    // Dummy profiles for demonstration
    final List<Map<String, dynamic>> dummyProfiles = [
      {
        'id': '1',
        'name': 'Aisha',
        'sect': 'Sunni',
        'prayerLevel': 'Regular',
        'age': 25
      },
      {
        'id': '2',
        'name': 'Omar',
        'sect': 'Shia',
        'prayerLevel': 'Occasional',
        'age': 30
      },
      {
        'id': '3',
        'name': 'Fatima',
        'sect': 'Sunni',
        'prayerLevel': 'Devout',
        'age': 22
      },
      {
        'id': '4',
        'name': 'Yusuf',
        'sect': 'Sunni',
        'prayerLevel': 'Regular',
        'age': 28
      },
      {
        'id': '5',
        'name': 'Zainab',
        'sect': 'Shia',
        'prayerLevel': 'Devout',
        'age': 27
      },
      {
        'id': '6',
        'name': 'Ali',
        'sect': 'Sunni',
        'prayerLevel': 'Occasional',
        'age': 35
      },
      {
        'id': '7',
        'name': 'Waleed',
        'sect': 'Shia',
        'prayerLevel': 'Regular',
        'age': 29
      },
      {
        'id': '8',
        'name': 'Maryam',
        'sect': 'Sunni',
        'prayerLevel': 'Devout',
        'age': 24
      },
      {
        'id': '9',
        'name': 'Khadija',
        'sect': 'Shia',
        'prayerLevel': 'Occasional',
        'age': 31
      },
      {
        'id': '10',
        'name': 'Ibrahim',
        'sect': 'Sunni',
        'prayerLevel': 'Regular',
        'age': 26
      },
    ];

    // Load liked profiles from storage
    // likedProfiles.value = (storage.read('likedProfiles') ?? []).cast<String>();

    return Scaffold(
      backgroundColor: Color(0xfff0f3f2),
      appBar: AppBar(
        foregroundColor: Colors.white,
        title: Text(
          'All Users',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Color(0xff1b60c9),
        actions: [
          IconButton(
            icon: Icon(Icons.favorite, color: Colors.red),
            onPressed: () => Get.to(() => FavoritesScreen()),
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isWeb = constraints.maxWidth >= 600;
          final content = ConstrainedBox(
            constraints: BoxConstraints(maxWidth: maxCardWidth),
            child: Padding(
              padding: EdgeInsets.all(padding * 1.5),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: padding),
                    Text(
                      'Users',
                      style: TextStyle(
                        fontSize: titleFontSize,
                        fontWeight: FontWeight.bold,
                        color: Color(0xff1b60c9),
                      ),
                    ),
                    SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: Obx(() => DropdownButtonFormField<String>(
                                value: selectedSect.value,
                                decoration: InputDecoration(
                                  labelText: 'Sect',
                                  fillColor: Colors.white,
                                  filled: true,
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                items: ['Any', 'Sunni', 'Shia']
                                    .map((sect) => DropdownMenuItem(
                                          value: sect,
                                          child: Text(sect),
                                        ))
                                    .toList(),
                                onChanged: (value) =>
                                    selectedSect.value = value!,
                              )),
                        ),
                        SizedBox(width: padding),
                        Expanded(
                          child: Obx(() => DropdownButtonFormField<String>(
                                value: selectedPrayerLevel.value,
                                decoration: InputDecoration(
                                  labelText: 'Prayer Level',
                                  fillColor: Colors.white,
                                  filled: true,
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                items:
                                    ['Any', 'Regular', 'Occasional', 'Devout']
                                        .map((level) => DropdownMenuItem(
                                              value: level,
                                              child: Text(level),
                                            ))
                                        .toList(),
                                onChanged: (value) =>
                                    selectedPrayerLevel.value = value!,
                              )),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Profiles',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    Obx(() {
                      var filteredProfiles = dummyProfiles.where((profile) {
                        bool sectMatch = selectedSect.value == 'Any' ||
                            profile['sect'] == selectedSect.value;
                        bool prayerMatch = selectedPrayerLevel.value == 'Any' ||
                            profile['prayerLevel'] == selectedPrayerLevel.value;

                        return sectMatch && prayerMatch;
                      }).toList();

                      return filteredProfiles.isEmpty
                          ? Center(
                              child: Text(
                                'No profiles match your filters or all profiles are favorited.',
                                style: TextStyle(fontSize: listFontSize),
                              ),
                            )
                          : ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: filteredProfiles.length,
                              itemBuilder: (context, index) {
                                final profile = filteredProfiles[index];
                                return GestureDetector(
                                  onTap: () {
                                    Get.to(() =>
                                        ChatScreen(name: profile['name']));
                                  },
                                  child: Container(
                                    margin: EdgeInsets.symmetric(vertical: 5),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      color: Colors.white,
                                    ),
                                    child: ListTile(
                                      leading: CircleAvatar(
                                        backgroundColor: Colors.grey[300],
                                        child: Text(profile['name'][0]),
                                      ),
                                      title: Row(
                                        children: [
                                          Text(
                                            profile['name'],
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          SizedBox(width: 5),
                                          Icon(
                                            Icons.verified,
                                            color: Colors.green,
                                            size: 16,
                                          ), // Photo Verified Tick
                                        ],
                                      ),
                                      subtitle: Text(
                                        'Age: ${profile['age']} | Sect: ${profile['sect']} | Prayer: ${profile['prayerLevel']}',
                                        style: TextStyle(
                                            fontSize: listFontSize - 2),
                                      ),
                                      trailing: Obx(() {
                                        bool isFavorited = favController
                                            .likedProfiles
                                            .any((fav) =>
                                                fav['id'] == profile['id']);
                                        return IconButton(
                                          icon: Icon(
                                            isFavorited
                                                ? Icons.favorite
                                                : Icons.favorite_border,
                                            color: isFavorited
                                                ? Colors.red
                                                : Colors.grey,
                                          ),
                                          onPressed: () {
                                            if (isFavorited) {
                                              favController.removeFavorite(
                                                  profile['id']);
                                               Utils.toastMessage(
                                                '${profile['name']} removed from favorites',
                                                
                                              );
                                            } else {
                                              _markAsFavorite(profile);
                                            }
                                          },
                                        );
                                      }),
                                    ),
                                  ),
                                );
                              },
                            );
                    }),
                  ],
                ),
              ),
            ),
          );

          return isWeb ? Center(child: content) : content;
        },
      ),
    );
  }

  void _markAsFavorite(Map<String, dynamic> profile) {
    // Check if this profile is already liked
    if (!favController.likedProfiles.any((fav) => fav['id'] == profile['id'])) {
      favController.likedProfiles.add(profile); // Add profile
      favController.saveFavorites(); // Save using the method we added

       Utils.toastMessage(
        
        '${profile['name']} marked as favorite',
      
      );
    } else {
       Utils.toastMessage(
        
        '${profile['name']} is already in favorites.',
       
      );
    }
  }
}
