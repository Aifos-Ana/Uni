import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../utils/constants.dart' as Constants;

class NavigationDrawer extends StatefulWidget {
  final BuildContext parentContext;

  NavigationDrawer({@required this.parentContext}) {}

  @override
  State<StatefulWidget> createState() {
    return NavigationDrawerState(parentContext: parentContext);
  }
}

class NavigationDrawerState extends State<NavigationDrawer> {
  final BuildContext parentContext;

  NavigationDrawerState({@required this.parentContext}) {}

  Map drawerItems = {};
  Map drawerIcons = {};

  @override
  void initState() {
    super.initState();

    drawerItems = {
      Constants.navPersonalArea: _onSelectPage,
      Constants.navCalendar: _onSelectPage,
      Constants.navSchedule: _onSelectPage,
      Constants.navExams: _onSelectPage,
      Constants.navStops: _onSelectPage,
      Constants.navAbout: _onSelectPage,
      Constants.navBugReport: _onSelectPage,
    };

    drawerIcons = {
      Constants.navPersonalArea: const Icon(Icons.person),
      Constants.navCalendar: const Icon(CupertinoIcons.calendar),
      Constants.navSchedule: const Icon(Icons.schedule),
      Constants.navExams: const Icon(Icons.dangerous),
      Constants.navStops: const Icon(Icons.directions_bus),
      Constants.navAbout: const Icon(Icons.info),
      Constants.navBugReport: const Icon(Icons.bug_report),
    };
  }

  // Callback Functions
  getCurrentRoute() => ModalRoute.of(parentContext).settings.name == null
      ? drawerItems.keys.toList()[0]
      : ModalRoute.of(parentContext).settings.name.substring(1);

  _onSelectPage(String key) {
    final prev = getCurrentRoute();

    Navigator.of(context).pop();

    if (prev != key) {
      Navigator.pushNamed(context, '/' + key);
    }
  }

  _onLogOut(String key) {
    Navigator.of(context)
        .pushNamedAndRemoveUntil('/' + key, (Route<dynamic> route) => false);
  }

  // End of Callback Functions

  Decoration _getSelectionDecoration(String name) {
    return BoxDecoration(
      border: Border(
          left: BorderSide(
              color: name == getCurrentRoute()
                  ? Theme.of(context).accentColor
                  : Theme.of(context).primaryColor,
              width: 3.0)),
      color: name == getCurrentRoute()
          ? Theme.of(context).dividerColor
          : Theme.of(context).primaryColor,
    );
  }

  Widget createLogoutBtn() {
    return OutlinedButton(
      onPressed: () => _onLogOut(Constants.navLogOut),
      style: OutlinedButton.styleFrom(
        elevation: 0,
        padding: const EdgeInsets.all(0.0),
      ),
      child: Container(
        padding: const EdgeInsets.all(15.0),
        child: Text(Constants.navLogOut,
            style: Theme.of(context)
                .textTheme
                .headline6
                .apply(color: Theme.of(context).accentColor)),
      ),
    );
  }

  Widget createDrawerNavigationOption(String d) {
    return Container(
        decoration: _getSelectionDecoration(d),
        child: Padding(
          padding: EdgeInsets.only(bottom: 3.0, left: 20.0),
          child: ListTile(
            leading: drawerIcons[d],
            iconColor: Theme.of(context).toggleableActiveColor,
            title: Container(
              key: Key('drawer_' + d),
              child: Text(d,
                  style: TextStyle(
                      fontSize: 18.0,
                      color: Theme.of(context).accentColor,
                      fontWeight: FontWeight.normal)),
            ),
            dense: true,
            contentPadding: EdgeInsets.all(0.0),
            onTap: () => drawerItems[d](d),
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> drawerOptions = [];

    for (var key in drawerItems.keys) {
      drawerOptions.add(createDrawerNavigationOption(key));
    }

    return Drawer(
        child: Column(
      children: <Widget>[
        Expanded(
            child: Container(
          padding: EdgeInsets.only(top: 55.0),
          child: ListView(
            children: drawerOptions,
          ),
        )),
        Row(children: <Widget>[Expanded(child: createLogoutBtn())])
      ],
    ));
  }
}
