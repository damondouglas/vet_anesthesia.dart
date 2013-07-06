library app;

import 'package:web_ui/web_ui.dart';
import 'dart:html';

int precision = 2;
final InputElement model = query("#model");

void main() {
  model.onInput.listen((Event e){
     var xtable = query("div[is='x-table']").xtag;
     if(xtable != null) xtable.update(model.value);
  });
}