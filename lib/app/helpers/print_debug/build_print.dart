import 'package:flutter/foundation.dart';

void myPrint(String myMessage) {
  if (kDebugMode) {
    myPrint(myMessage);
  }
}