import 'package:example_app/model/user_model.dart';
import 'package:example_app/services/api_services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Map<String, dynamic>> likedUser = [];
  bool showlikeduser = false;
  late ApiHandler apihandler;
  @override
  void initState() {
    apihandler = Get.put(ApiHandler());
    getuserFormLocal();
    super.initState();
  }

  saveUser(Map<String, dynamic> userData) async {
    final storage = GetStorage();
    likedUser.add(userData);
    await storage.write('user', likedUser);
    setState(() {});
  }

  getuserFormLocal() async {
    await apihandler.getUser();
    final data = GetStorage().read<List<dynamic>>('user');

    //<Map<String, dynamic>>();
    setState(() {
      likedUser.addAll(List<Map<String, dynamic>>.from(data ?? []));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
        actions: [
          Center(
            child: InkWell(
                onTap: () {
                  setState(() {
                    showlikeduser = !showlikeduser;
                  });
                },
                child: Text('Liked users ' + likedUser.length.toString() + '  ')),
          ),
          TextButton(
            child: const Text(
              'Get  user',
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () async {
              await apihandler.getUser();
            },
          ),
        ],
      ),
      body: GetBuilder<ApiHandler>(
          init: apihandler,
          builder: (controller) {
            return (showlikeduser && likedUser.isNotEmpty)
                ? ListView.builder(
                    shrinkWrap: true,
                    itemCount: likedUser.length,
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    itemBuilder: (_, index) {
                      final user = UserModel.fromJson((likedUser[index].values.first));
                      return Padding(
                        padding: const EdgeInsets.only(
                          bottom: 10,
                        ),
                        child: ListTile(
                          trailing: IconButton(
                              onPressed: () async {
                                // for (var element in likedUser) {element.keys.toList().contains(element) == controller.listOfUser[index]!.id.toString()}

                                // await saveUser({
                                //   controller.listOfUser[index]!.id.toString():
                                //       controller.listOfUser[index]!.toJson()
                                // });
                              },
                              icon: const Icon(Icons.thumb_down
                                  // color:  ?Colors.amber : Colors.grey,
                                  )),
                          title: Text(
                            user.name ?? '',
                            style:
                                const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 5),
                              Text(
                                'Email : ' + (user.email ?? ''),
                                style: const TextStyle(
                                    fontSize: 12, fontWeight: FontWeight.w400),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                'Phone : ' + (user.phone ?? ''),
                                style: const TextStyle(
                                    fontSize: 12, fontWeight: FontWeight.w400),
                              ),
                            ],
                          ),
                        ),
                      );
                    })
                : ListView.builder(
                    shrinkWrap: true,
                    itemCount: controller.listOfUser.length,
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    itemBuilder: (_, index) {
                      return Padding(
                        padding: const EdgeInsets.only(
                          bottom: 10,
                        ),
                        child: ListTile(
                          trailing: IconButton(
                              onPressed: () async {
                                // for (var element in likedUser) {element.keys.toList().contains(element) == controller.listOfUser[index]!.id.toString()}

                                await saveUser({
                                  controller.listOfUser[index]!.id.toString():
                                      controller.listOfUser[index]!.toJson()
                                });
                              },
                              icon: const Icon(
                                Icons.thumb_up,
                                // color:  ?Colors.amber : Colors.grey,
                              )),
                          title: Text(
                            controller.listOfUser[index]?.name ?? '',
                            style:
                                const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 5),
                              Text(
                                'Email : ' + (controller.listOfUser[index]?.email ?? ''),
                                style: const TextStyle(
                                    fontSize: 12, fontWeight: FontWeight.w400),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                'Phone : ' + (controller.listOfUser[index]?.phone ?? ''),
                                style: const TextStyle(
                                    fontSize: 12, fontWeight: FontWeight.w400),
                              ),
                            ],
                          ),
                        ),
                      );
                    });
          }),
    );
  }
}
