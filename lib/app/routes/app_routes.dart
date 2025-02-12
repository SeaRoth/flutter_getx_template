

part of 'app_pages.dart';
abstract class Routes {
  static const routeHome = _Paths.pathHome;

  static const routeMain = _Paths.pathHome + _Paths.pathMain;
  static const routeDetails = _Paths.pathHome + _Paths.pathDetails;
  static const routeSettings = _Paths.pathHome + _Paths.pathSettings;
}

abstract class _Paths {
  static const pathHome = '/home';
  static const pathMain = '/main';
  static const pathDetails = '/details';
  static const pathSettings = '/settings';
}