import 'package:web_ui/web_ui.dart';
import 'dart:html';

final xwgt = query("#xwgt");

void main() {
  useShadowDom = true;
  style();
  window.onResize.listen((data){
    style();
  });
  window.onDeviceOrientation.listen((data){
    style();
  });
}

void style() {
  
  int width = 200;
  int left = ((window.innerWidth - width)/2).toInt();
  
  xwgt.style
  ..position = "fixed"
  ..width = "${width}px"
  ..top = "0"
  ..left = "${left}px";
}



