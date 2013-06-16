import 'dart:html';
import 'package:lawndart/lawndart.dart';
import 'dart:async';

double wgt = 0.0;
String wgtstr = "";
IndexedDbStore db;
String WGT_KEY = "wgt";
final TableElement table = query("#data");
final InputElement wgtinput = query("#wgtinput");

Map medication = 
{
 "PRE OP":
 {
  "Butorphanol":
    {
      "l":_dosebased(0.2,10.0),
      "h":_dosebased(0.4,10.0)
    },
  "Buprenorphine":
    {
    "l":_dosebased(0.01,0.3),
    "h":_dosebased(0.03,0.3)
    },
    "Acepromazine":
    {
      "l":_dosebased(0.05,1.0),
      "h":_flatbased(1.5)
    },
    "Midazolam 1":
    {
      "l":_dosebased(0.1,1.0),
      "h":_dosebased(0.2,1.0)
    },
    "Midazolam 5":
    {
      "l":_dosebased(0.1,5.0),
      "h":_dosebased(0.2,5.0)
    },
    "DKT":
    {
      "l":_dosebased(0.035,1.0),
      "h":_dosebased(0.065,1.0)
    },
    "Telazol":
    {
      "l":_dosebased(1.0,100.0),
      "h":_dosebased(4.0,100.0)
    }
    /*,
    "":
    {
      "l":_dosebased(,),
      "h":_dosebased(,)
    }*/
 }
};

void main() {
  
  _setupTable().then((_){
    db = new IndexedDbStore("vet_anesthesia", 'pt');
    db.open()
    .then((_) => db.exists(WGT_KEY))
    .then((exists){
      if(exists) {
        db.getByKey(WGT_KEY)
        .then((value){
          wgtinput.value = value;
          _convert(value);
        });
      } else {
        db.save(wgtstr,WGT_KEY);
      }
    });
  });
  
  
  
  wgtinput.onChange.listen(changed);
  wgtinput.onInput.listen(input);
    
}

Future _setupTable(){
  Completer completer = new Completer();
  
  
  medication.forEach((String header, Map map){
    var hd = 
        """
    <tr class="gsh"><td colspan="3">$header</td></tr>
        """;
    table.appendHtml(hd);
    map.keys.forEach((String med){
      var td = '<tr id="${med.replaceAll(" ", "")}" class="gd"><td>$med</td><td class="l"></td><td class="h"></td></tr>';
      table.appendHtml(td);
    });
  });
  
  completer.complete();
  
  return completer.future;
}

void input(e){
  print(e);
}

void changed(e) {
 wgtstr = wgtinput.value;
 print(e);
  /*
 var wgt = double.parse(wgtinput.value, (s){
    db.open()
    .then((_) => db.exists(WGT_KEY))
    .then((exists){
      if(exists) {
        db.getByKey(WGT_KEY)
        .then((value){
          wgtinput.value = value;
          _convert(value);
        });
      } else {
        db.save(wgtstr,WGT_KEY);
      }
    });
  });
  */
}

void _convert(String wgtstr){
  /*
  wgt = double.parse(wgtstr);
  var temp = wgt*10.round();
  wgt = temp.round().toDouble()/10;
  wgtstr = "$wgt";
  _refresh(wgt);
  */
}


Function _dosebased(double dose, double concentration) {
  return (wgt){
    return wgt*dose/concentration;
  };
}

Function _ratebased(double rate) {
  return (wgt){
    return wgt * rate;
  };
}

Function _flatbased(double dose) {
  return (wgt){
    return dose;
  };
}

void _refresh(wgt){
  medication.values.forEach((Map map){
    map.forEach((String med, Map f){
      String id = med.replaceAll(" ", "");
      var l = query("#$id .l");
      var h = query("#$id .h");
      double low = f["l"](wgt);
      double high = f["h"](wgt);
      l.text = wgt== 0 ? "" : low.toStringAsFixed(2);
      h.text = wgt == 0 ? "" : high.toStringAsFixed(2);
    });
  });
}


