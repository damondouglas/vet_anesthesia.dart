library xmedsafeinput;

import 'package:web_ui/web_ui.dart';
import 'dart:html';
import 'dart:math';
import 'package:lawndart/lawndart.dart';
import 'dart:async';

class MedSafeInput extends WebComponent {
  @observable
  double inputval = 0.0;
  @observable
  String inputstr = "";
  String placeholder = "Weight (kg)";
  int precision = -1;
  String store = "vet_anesthesia.pt.wgt";
  IndexedDbStore db;
  String storeKey = "";
  String modelid = "";
  
  void inserted() {

    center();
    window.onResize.listen((data){
      center();
    });
    
    if(store!=""){
      var storedtl = store.split(".");
      db = new IndexedDbStore(storedtl[0],storedtl[1]);
      storeKey = storedtl[2];
      db.open().then((_){
        db.exists(storeKey).then((exists){
          if(exists) {
            db.getByKey(storeKey).then((value){
              inputstr = value;
              changed();
            });
          } else {
            db.save(inputstr, storeKey).then((_){
              changed();
            });      
          }
        });
      });
    }

  }
  
  void paint() {
    inputstr = 
        precision != -1 ? 
            inputval != 0.0 ? 
                inputval - inputval.toInt() != 0 ?
                  ((inputval*pow(10,precision)).round()/pow(10,precision)).toString()
                : inputval.toInt().toString()
            : "" 
        : inputval.toString();
    if(db != null && db.isOpen) {
      db.save(inputstr, storeKey).then((_){});
    }
  }
  
  void center() {
    var container = query("div[is='x-medsafeinput']");
    int containerWidth = container.offsetWidth;
    int width = window.innerWidth;
    double adjust = (width - containerWidth)/2;
    container.style.left = "${adjust.toInt()}px";
  }
  
  void changed(){
    inputval = 
        inputstr != "" ?
          double.parse(inputstr,(_)=> inputval)
        : 0.0;
    paint();
    var model = query("#$modelid");
    model.value = inputstr;
    model.dispatchEvent(new Event('input'));
  }
}