import 'package:another_flushbar/flushbar_helper.dart';
import 'package:boilerplate/data/sharedpref/constants/preferences.dart';
import 'package:boilerplate/stores/language/language_store.dart';
import 'package:boilerplate/stores/theme/theme_store.dart';
import 'package:boilerplate/ui/examples/full_map.dart';
import 'package:boilerplate/ui/examples/main.dart';
import 'package:boilerplate/ui/meetup/meetup.dart';
import 'package:boilerplate/ui/savedplaces/savedplaces.dart';
import 'package:boilerplate/utils/locale/app_localization.dart';
import 'package:boilerplate/utils/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:material_dialog/material_dialog.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  //stores:---------------------------------------------------------------------
  late ThemeStore _themeStore;
  late LanguageStore _languageStore;
  ScrollController scrollController = new ScrollController();

  List<dynamic> routes = [
    {
      "title": "Let's meet up!",
      "description": "Find the location where we will meet up",
      "widget": MeetUp(),
      "icon": Icons.directions,
      "color": Color(0xff1ea4e9)
    },
    {
      "title": "Saved Places",
      "description": "Locations you saved",
      "widget": SavedPlaces(),
      "icon": Icons.place,
      "color": Color(0xff4ce166)
    },
    {
      "title": "Maps",
      "description": "A map for u",
      "widget": FullMapPage(),
      "icon": Icons.map_outlined,
      "color": Color(0xffff4a4a)
    },
    {
      "title": "Examples",
      "widget": MapsDemo(),
      "description": "Wemap examples",
      "icon": Icons.file_copy,
      "color": Color(0xff44c868)
    },
    {
      "title": "About",
      "widget": Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text("Group 21"),
              Text("18020651 - Nguyễn Văn Huy"),
              Text("18021087 - Nguyễn Thanh Sơn"),
              Text("18020979 - Ngô Sách Nhật")
            ],
          ),
        ),
      ),
      "description": "About this app",
      "icon": Icons.info,
      "color": Colors.cyan
    },
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // initializing stores
    _languageStore = Provider.of<LanguageStore>(context);
    _themeStore = Provider.of<ThemeStore>(context);

    // check to see if already called api
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBody(),
    );
  }

  // app bar methods:-----------------------------------------------------------
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: Text("MeetUp"),
      actions: _buildActions(context),
      backgroundColor: _themeStore.darkMode ? Colors.black : Colors.white,
    );
  }

  List<Widget> _buildActions(BuildContext context) {
    return <Widget>[
      _buildLanguageButton(),
      _buildThemeButton(),
      _buildLogoutButton(),
    ];
  }

  Widget _buildThemeButton() {
    return Observer(
      builder: (context) {
        return IconButton(
          onPressed: () {
            _themeStore.changeBrightnessToDark(!_themeStore.darkMode);
          },
          icon: Icon(
            _themeStore.darkMode ? Icons.brightness_5 : Icons.brightness_3,
          ),
        );
      },
    );
  }

  Widget _buildLogoutButton() {
    return IconButton(
      onPressed: () {
        SharedPreferences.getInstance().then((preference) {
          preference.setBool(Preferences.is_logged_in, false);
          Navigator.of(context).pushReplacementNamed(Routes.login);
        });
      },
      icon: Icon(
        Icons.power_settings_new,
      ),
    );
  }

  Widget _buildLanguageButton() {
    return IconButton(
      onPressed: () {
        _buildLanguageDialog();
      },
      icon: Icon(
        Icons.language,
      ),
    );
  }

  // body methods:--------------------------------------------------------------
  Widget _buildBody() {
    return Stack(
      children: <Widget>[
        _handleErrorMessage(),
        _buildMainContent(),
      ],
    );
  }

  Widget _buildMainContent() {
    return Observer(
      builder: (context) {
        return Material(
            child: SingleChildScrollView(
          controller: scrollController,
          child: Column(
            children: [
              Container(
                height: 200,
                child: Image(
                  image: AssetImage("assets/icons/ic_launcher.png"),
                ),
              ),
              _buildListView()
            ],
            mainAxisAlignment: MainAxisAlignment.spaceAround,
          ),
        ));
      },
    );
  }

  Widget _buildListView() {
    return ListView.builder(
      controller: scrollController,
      // scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemCount: 5,
      itemBuilder: (context, position) {
        return _buildListItem(position);
      },
    );
  }

  // Widget _buildListItem(int position) {
  //   return ListTile(
  //     // dense: true,
  //     minLeadingWidth: 60,
  //     contentPadding: EdgeInsets.only(left: 50),
  //     leading: Icon(routes.elementAt(position)["icon"]),
  //     title: Text(
  //       routes.elementAt(position)["title"],
  //       maxLines: 1,
  //       overflow: TextOverflow.ellipsis,
  //       softWrap: false,
  //       style: Theme.of(context).textTheme.title,
  //     ),
  //     subtitle: Text(
  //       routes.elementAt(position)["description"],
  //       maxLines: 1,
  //       overflow: TextOverflow.ellipsis,
  //       softWrap: false,
  //     ),
  //     onTap: () {
  //       Navigator.push(
  //         context,
  //         MaterialPageRoute(
  //             builder: (context) => routes.elementAt(position)["widget"]),
  //       );
  //     },
  //   );
  // }

  Widget _buildListItem(int position) {
    return GestureDetector(
      child: Container(
          margin: EdgeInsets.all(20),
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
              color: routes.elementAt(position)["color"],
              borderRadius: BorderRadius.circular(10)),
          width: MediaQuery.of(context).size.width * 0.8,
          child: ListTile(
            leading: Icon(
              routes.elementAt(position)["icon"],
              size: 40,
              color: Colors.white,
            ),
            minLeadingWidth: 50,
            title: Text(
              routes.elementAt(position)["title"],
              style: TextStyle(fontSize: 20, color: Colors.white),
            ),
            subtitle: Text(
              routes.elementAt(position)["description"],
              style: TextStyle(color: Colors.white54),
            ),
          )),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => routes.elementAt(position)["widget"]),
        );
      },
    );
  }

  Widget _handleErrorMessage() {
    return Observer(
      builder: (context) {
        if (false) {
          return _showErrorMessage("Error");
        }
        return SizedBox.shrink();
      },
    );
  }

  // General Methods:-----------------------------------------------------------
  _showErrorMessage(String message) {
    Future.delayed(Duration(milliseconds: 0), () {
      if (message.isNotEmpty) {
        FlushbarHelper.createError(
          message: message,
          title: AppLocalizations.of(context).translate('home_tv_error'),
          duration: Duration(seconds: 3),
        )..show(context);
      }
    });

    return SizedBox.shrink();
  }

  _buildLanguageDialog() {
    _showDialog<String>(
      context: context,
      child: MaterialDialog(
        borderRadius: 5.0,
        enableFullWidth: true,
        title: Text(
          AppLocalizations.of(context).translate('home_tv_choose_language'),
          style: TextStyle(
            color: Colors.white,
            fontSize: 16.0,
          ),
        ),
        headerColor: Theme.of(context).primaryColor,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        closeButtonColor: Colors.white,
        enableCloseButton: true,
        enableBackButton: false,
        onCloseButtonClicked: () {
          Navigator.of(context).pop();
        },
        children: _languageStore.supportedLanguages
            .map(
              (object) => ListTile(
                dense: true,
                contentPadding: EdgeInsets.all(0.0),
                title: Text(
                  object.language!,
                  style: TextStyle(
                    color: _languageStore.locale == object.locale
                        ? Theme.of(context).primaryColor
                        : _themeStore.darkMode
                            ? Colors.white
                            : Colors.black,
                  ),
                ),
                onTap: () {
                  Navigator.of(context).pop();
                  // change user language based on selected locale
                  _languageStore.changeLanguage(object.locale!);
                },
              ),
            )
            .toList(),
      ),
    );
  }

  _showDialog<T>({required BuildContext context, required Widget child}) {
    showDialog<T>(
      context: context,
      builder: (BuildContext context) => child,
    ).then<void>((T? value) {
      // The value passed to Navigator.pop() or null.
    });
  }
}
