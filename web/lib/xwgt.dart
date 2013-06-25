library xwgt;

import 'package:web_ui/web_ui.dart';
import 'dart:html';
import 'package:lawndart/lawndart.dart';
import 'dart:async';

class Weight extends WebComponent {
  @observable
  double wgt = 0.0;
  @observable
  String wgtstr = "";
  
  IndexedDbStore db;
  String WGT_KEY = "wgt";
  
  void created() {
    buildstyle();
    window.onResize.listen((data){
      buildstyle();
    });
    window.onDeviceOrientation.listen((data){
      buildstyle();
    });
    db = new IndexedDbStore("vet_anesthesia", 'pt');
    db.open()
    .then((_) => db.exists(WGT_KEY))
    .then((exists){
      if(exists) {
          db.getByKey(WGT_KEY)
          .then((value){
            wgtstr = value;
            wgt = wgtstr!="" ? double.parse(wgtstr) : 0.0;
            _updateModel(wgtstr);
          });
      } else {
        db.save(wgtstr,WGT_KEY);
      }
    });
  }
  
  void buildstyle() {
    int width = 200;
    int left = ((window.innerWidth - width)/2).toInt();
    DivElement wgtinput = query(".wgtinput");
    if(wgtinput!=null){
      wgtinput.style
      ..position = "fixed"
      ..width = "${width}px"
      ..top = "0"
      ..left = "${left}px";
    }
  }
  
  void _updateModel(String wgtstr) {
    InputElement m = query("#model");
    m.value = wgtstr;
    Event e = new Event("input");
    m.dispatchEvent(e);
  }
  
 
  void changed() {
    try {
      wgt = double.parse(wgtstr);
      var temp = wgt*10.round();
      wgt = temp.round().toDouble()/10;
     
      temp = wgt - wgt.toInt();
      wgtstr = temp !=0 ? "$wgt" : "${wgt.toInt()}"; 
      db.open()
      .then((_) => db.save(wgtstr, WGT_KEY));
      _updateModel(wgtstr);
    } catch(e) {
      if(wgtstr==""){
        wgt = 0.0;
        db.open()
        .then((_) => db.save(wgtstr, WGT_KEY));
        _updateModel(wgtstr);
      } else {
        db.open()
        .then((_) => db.exists(WGT_KEY))
        .then((exists){
          if(exists) {
            db.getByKey(WGT_KEY)
            .then((value){
              wgtstr = value;
              wgt = wgtstr!="" ? double.parse(wgtstr) : 0.0;
            });
          }
        });
      }
      
    }
  }
}


