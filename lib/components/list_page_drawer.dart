// import 'package:flutter/foundation.dart';
import 'package:final_project/managers/auth_manager.dart';
import 'package:final_project/pages/challenge_page.dart';
import 'package:final_project/pages/model_overview_page.dart';
import 'package:flutter/material.dart';


class ListPageDrawer extends StatelessWidget {
  // final void Function() editProfileCallback;

  const ListPageDrawer({
    // required this.editProfileCallback,
    super.key,
  });

   @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.inversePrimary,
            ),
            child: const Text(
              "Hurricane Classifier",
              style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 28.0,
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.data_thresholding_outlined),
            title: const Text("Performance Overview"),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) =>
                      const ModelOverviewPage(),
                ),
              );
              // Navigator.of(context).pop();
            },
          ),
          ListTile(
            leading: const Icon(Icons.star_border_purple500),
            title: const Text("Challenge"),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) =>
                    const ChallengePage(),
                ),
              );
              // showOnlyMineCallback();
            },
          ),
          // ListTile(
          //   leading: const Icon(Icons.people),
          //   title: const Text("Show all photos"),
          //   onTap: () {
          //     Navigator.of(context).pop();
          //     // showAllCallback();
          //   },
          // ),
          const Spacer(),
          const Divider(
            thickness: 2.0,
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text("Logout"),
            onTap: () {
              Navigator.of(context).pop();
              AuthManager.instance.signOut();
            },
          )
        ],
      ),
    );
  }
}
