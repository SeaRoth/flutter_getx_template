

part of 'app_pages.dart';
abstract class Routes {
  static const routeHome = _Paths.pathHome;

  static const routeRewards = _Paths.pathHome + _Paths.pathRewards;
  static const routeTasks = _Paths.pathHome + _Paths.pathTasks;
  static const routeProfile = _Paths.pathHome + _Paths.pathProfile;
}

abstract class _Paths {
  static const pathHome = '/home';
  static const pathRewards = '/rewards';
  static const pathTasks = '/tasks';
  static const pathProfile = '/profile';
}