import 'dart:async';
import 'dart:convert';

import 'package:LoginUI/model/UserProfile.dart';
import 'package:LoginUI/ui/base/BaseStatefulState.dart';
import 'package:LoginUI/ui/dashboard/DashboardPage.dart';
import 'package:LoginUI/ui/login/LoginPage.dart';
import 'package:LoginUI/ui/repolist/RepoListPage.dart';
import 'package:LoginUI/ui/searchusers/UserSearchPage.dart';
import 'package:LoginUI/utils/SharedPrefs.dart';
import 'package:flutter/material.dart';

class DashboardPageState extends BaseStatefulState<DashboardPage> {
  Widget appBarTitle = new Text("Your Dashboard");
  UserProfile currentUserProfile;
  String accessToken;
  StreamSubscription<UserProfile> subscriptionMyProfile;

  @override
  void initState() {
    super.initState();
    SharedPrefs().getToken().then((token) {
      accessToken = token;
      getMyUserProfile();
    });
  }

  @override
  void dispose() {
    super.dispose();
    subscriptionMyProfile?.cancel();
  }

  toolbarAndroid() {
    return new AppBar(
      centerTitle: false,
      title: appBarTitle,
    );
  }

  getDrawer() {
    return new Drawer(
      // Add a ListView to the drawer. This ensures the user can scroll
      // through the options in the Drawer if there isn't enough vertical
      // space to fit everything.
      child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Expanded(
                    flex: 1,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                            child: new CircleAvatar(
                          backgroundImage: new NetworkImage(
                              currentUserProfile.avatarUrl),
                          radius: 40.0,
                        )),
                      ],
                    )),
                Expanded(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text("${currentUserProfile.name}",
                            style: new TextStyle(color: Colors.white)),
                        Text("${currentUserProfile.login}",
                            style: new TextStyle(color: Colors.white)),
                        Text("${currentUserProfile.bio}",
                            style: new TextStyle(color: Colors.white)),
                        Text("${currentUserProfile.company}",
                            style: new TextStyle(color: Colors.white))
                      ],
                    ))
                  ],
                )
              ],
            ),
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
          ),
          ListTile(
            title: Text('User Search'),
            onTap: () {
              navigateTo(UserSearchPage());
            },
          ),
          ListTile(
            title: Text('My Repo List'),
            onTap: () {
              navigateTo(RepoListPage());
            },
          ),
          ListTile(
            title: Text('Logout!'),
            onTap: () {
              logoutUser();
            },
          )
        ],
      ),
    );
  }

  void navigateTo(StatefulWidget statefulWidget) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => statefulWidget),
    );
  }

  void logoutUser() {
    SharedPrefs().clear().then((onClear) {
      navigateTo(LoginPage());
    });
  }

  @override
  Widget prepareWidget(BuildContext context) {
    return new Scaffold(
        key: scaffoldKey,
        drawer: getDrawer(),
        body: new Stack(
          children: <Widget>[toolbarAndroid()],
        ));
  }

  void getMyUserProfile() {
    var stream = SharedPrefs().getCurrentUserProfile().asStream();
    subscriptionMyProfile = stream.listen((profile) {
      this.setState(() {
        currentUserProfile = profile;
      });
    });
  }
}