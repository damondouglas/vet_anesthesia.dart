library app;

import 'package:web_ui/web_ui.dart';
import 'dart:html';

final xwgt = query("#xwgt");

@observable
String wgtstr = "";

void main() {
  
  buildstyle();
  window.onResize.listen((data){
    buildstyle();
  });
  window.onDeviceOrientation.listen((data){
    buildstyle();
  });
  
/*  query("#model").onInput.listen((Event e){
    print(e.type);

  });*/
  
  /*query("#model").onChange.listen((data){
    print(data);
  });*/
}

void buildstyle() {
  
  int width = 200;
  int left = ((window.innerWidth - width)/2).toInt();
  
  xwgt.style
  ..position = "fixed"
  ..width = "${width}px"
  ..top = "0"
  ..left = "${left}px";
  
}