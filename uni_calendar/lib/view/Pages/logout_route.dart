import 'package:flutter/material.dart';
import 'package:uni_calendar/controller/logout.dart';
import 'package:uni_calendar/view/Pages/login_page_view.dart';

class LogoutRoute {
  LogoutRoute._();
  static MaterialPageRoute buildLogoutRoute() {
    return MaterialPageRoute(builder: (context) {
      logout(context);
      return LoginPageView();
    });
  }
}
