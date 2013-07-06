library xheader;

import 'package:web_ui/web_ui.dart';
import 'dart:html';
import 'xmedsafeinput.dart';

int precision = 2;
String cellwidth = "60px";

class Header extends WebComponent {
  void inserted() {
    paint();
    window.onResize.listen((_){
      paint();
    });
  }
  
  void paint() {
    var theader = query("div[is='x-header'] table");
    var height = theader.offsetHeight;
    var width = theader.offsetWidth;
    var windowwidth = window.innerWidth;
    //container.style.top = "${height+5}px";
    theader.style.top = "${height+4}px";
    theader.style.left = "${((windowwidth-width)/2).toInt()}px";
    
    var wip = query("div[is='x-medsafeinput']");
    
    var container = query("div[is='x-header']");
    container.style.height = "${height+theader.offsetTop}px";
    container.style.width = "${windowwidth}px";
  }
  
  void changed() {

  }
}