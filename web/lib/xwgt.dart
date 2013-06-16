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
    
    db = new IndexedDbStore("vet_anesthesia", 'pt');
    db.open()
    .then((_) => db.exists(WGT_KEY))
    .then((exists){
      if(exists) {
          db.getByKey(WGT_KEY)
          .then((value){
            wgtstr = value;
          });
      } else {
        db.save(wgtstr,WGT_KEY);
      }
    });
    if(wgtstr!=""){
      wgt = double.parse(wgtstr);
    } else {
      wgt = 0.0;
    }
  }
  
  void changed() {
    wgt = double.parse(wgtstr, handleError);
    var temp = wgt*10.round();
    wgt = temp.round().toDouble()/10;
    wgtstr = "$wgt";
    db.open()
    .then((_) => db.save(wgtstr, WGT_KEY));
  }
  
  double handleError(s){
    db.open()
    .then((_) {
      db.getByKey(WGT_KEY)
      .then((value){
        wgtstr = value;
      });
    });
    return double.parse(wgtstr);
  }
}
