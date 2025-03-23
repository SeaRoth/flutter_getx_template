class LoadingModel {
  final String loadingText;
  final String loadingImage;
  final Future<void> Function()? loadingFunctionToRun;

  LoadingModel({
    required this.loadingText,
    required this.loadingImage,
    required this.loadingFunctionToRun,
  });
}
