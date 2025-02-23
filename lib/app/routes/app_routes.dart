

part of 'app_pages.dart';
abstract class Routes {
  static const routeHome = _Paths.pathHome;

  static const routeMain = _Paths.pathHome + _Paths.pathMain;
  static const routeDetails = _Paths.pathHome + _Paths.pathDetails;
  static const routeBlank = _Paths.pathHome + _Paths.pathBlank;
  static const routeFriends = _Paths.pathHome + _Paths.pathFriends;
  static const routeSettings = _Paths.pathHome + _Paths.pathSettings;
}

abstract class _Paths {
  static const pathHome = '/home';
  static const pathMain = '/main';
  static const pathDetails = '/details';
  static const pathBlank = '/blank';
  static const pathSettings = '/settings';
  static const pathFriends = '/friends';
}