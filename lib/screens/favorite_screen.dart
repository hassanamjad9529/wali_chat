import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:wali_project/components/utils/utils.dart';
import 'package:wali_project/controllers/favorites_controller.dart';

class FavoritesScreen extends StatelessWidget {
  final GetStorage storage = GetStorage();
  // final RxList<String> likedProfiles =
  //     Get.find<RxList<String>>(tag: 'likedProfiles');
final FavoritesController favController = Get.find();

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;
    final maxCardWidth = isMobile ? screenWidth : 1000.0;
    final padding = isMobile ? 12.0 : 16.0;
    final titleFontSize = isMobile ? 22.0 : 24.0;
    final listFontSize = isMobile ? 14.0 : 16.0;

    // Dummy profiles for demonstration (same as AllUsersScreen)
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

    return Scaffold(
      backgroundColor: Color(0xfff0f3f2),
      appBar: AppBar(
        foregroundColor: Colors.white,
        title: Text(
          'Favorite Profiles',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Color(0xff1b60c9),
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
                      'Favorites',
                      style: TextStyle(
                        fontSize: titleFontSize,
                        fontWeight: FontWeight.bold,
                        color: Color(0xff1b60c9),
                      ),
                    ),
                    SizedBox(height: 20),
                    Obx(() {
                     var favoriteProfiles = dummyProfiles
    .where((profile) => favController.isFavorite(profile['id']))
    .toList();


                      return favoriteProfiles.isEmpty
                          ? Padding(
                              padding: EdgeInsets.only(
                                top: MediaQuery.of(context).size.height * 0.3,
                              ),
                              child: Center(
                                child: Text(
                                  'No favorite profiles yet.',
                                  style: TextStyle(fontSize: listFontSize),
                                ),
                              ),
                            )
                          : ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: favoriteProfiles.length,
                              itemBuilder: (context, index) {
                                final profile = favoriteProfiles[index];
                                return Container(
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
                                      style:
                                          TextStyle(fontSize: listFontSize - 2),
                                    ),
                                    trailing: IconButton(
                                      icon: Icon(Icons.favorite,
                                          color: Colors.red),
                                     onPressed: () {
  favController.removeFavorite(profile['id']);
   Utils.toastMessage(
    
    '${profile['name']} removed from favorites',
    
  );
},

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
}
