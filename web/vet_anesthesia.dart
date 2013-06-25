library app;

import 'package:web_ui/web_ui.dart';
import 'dart:html';

final xwgt = query("#xwgt");

@observable
String wgtstr = "";

void main() {
  query("#model").onInput.listen((data){
    var xtable = query("#xtable").xtag;
    if(xtable != null) xtable.update("#model");
  });
}