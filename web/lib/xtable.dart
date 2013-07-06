import 'package:web_ui/web_ui.dart';
import 'dart:html';

class Table extends WebComponent {
  @observable
  String refpointid = "";
  
  Map _medication = 
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
     },
     "POST OP":
     {
       "Rimadyl":
       {
       "l":_dosebased(4.0,50.0),
       "h":_dosebased(4.0,50.0)
       }
     },
     "AB":
     {
       "Cefazolin":
       {
       "l":_dosebased(22.0,100.0),
       "h":_dosebased(22.0,100.0)
       },
       "Ampicillin":
       {
       "l":_dosebased(20.0,250.0),
       "h":_dosebased(20.0,250.0)
       }
     },
     "INDUCE":
     {
       "Propofol":
       {
       "l":_dosebased(4.0,10.0),
       "h":_dosebased(6.0,10.0)
       }
     },
     "IVF":
     {
       "CAT 1st hour":
       {
       "l":_dosebased(5.0,1.0),
       "h":_dosebased(5.0,1.0)
       },
       "DOG 1st hour":
       {
       "l":_dosebased(10.0,1.0),
       "h":_dosebased(10.0,1.0)
       }
     },
     "BLOCK":
     {
       "Bupivacaine":
       {
       "l":_dosebased(1.0,5.0),
       "h":_dosebased(2.0,5.0)
       },
       "Lidocaine":
       {
       "l":_dosebased(1.0,20.0),
       "h":_dosebased(2.0,20.0)
       }
     },
     "911":
     {
       "Atipamazole":
       {
       "l":_dosebased(0.012,5.0),
       "h":_dosebased(0.021,5.0)
       },
       "Atropine":
       {
       "l":_dosebased(0.02,0.54),
       "h":_dosebased(0.04,0.54)
       },
       "Glycopyrrolate":
       {
       "l":_dosebased(0.01,0.2),
       "h":_dosebased(0.01,0.2)
       },
       "Epinephrine":
       {
       "l":_dosebased(0.1,1.0),
       "h":_dosebased(0.2,1.0)
       },
       "Lidocaine CAT":
       {
       "l":_dosebased(0.25,20.0),
       "h":_dosebased(0.5,20.0)
       },
       "Lidocaine DOG":
       {
       "l":_dosebased(2.0,20.0),
       "h":_dosebased(4.0,20.0)
       },
       "Ephedrine":
       {
       "l":_dosebased(0.1,5.0),
       "h":_dosebased(0.2,5.0)
       },
       "Hetastarch":
       {
       "l":_dosebased(2.5,1.0),
       "h":_dosebased(5.0,1.0)
       }
     }
    };
  void inserted() {
    var table = query("div[is='x-table'] table");
    _medication.keys.forEach((hdr){
      var tr = new TableRowElement();
      var td = new TableCellElement();
      td.colSpan = 3;
      td.style.fontWeight = "bold";
      td.style.backgroundColor = "#cecece";
      td.innerHtml = hdr;
      tr.append(td);
      table.append(tr);
      Map medmap = _medication[hdr];
      medmap.keys.forEach((String med){
        tr = new TableRowElement();
        var medtd = new TableCellElement();
        var ltd = new TableCellElement();
        var htd = new TableCellElement();
        medtd.classes.add("med");
        ltd.classes.add("l");
        htd.classes.add("h");
        medtd.innerHtml = med;
        tr.id = med.replaceAll(" ", "");
        tr.append(medtd);
        tr.append(ltd);
        tr.append(htd);
        table.append(tr);    
      });
    });
    paint();
    window.onResize.listen((data){
      paint();
    });
    
    window.onScroll.listen((_){
      /*
      var y = window.scrollY;
      var xtable = query("div[is='x-table']");
      var t = xtable.offsetHeight - y;
      xtable.style.top = "${t}px";
      */
    });
    
  }
  
  void paint(){
    var xtable = query("div[is='x-table']");
    var previous = query("$refpointid");

    if(previous != null) {
      var height = previous.offsetHeight;
      xtable.style.top = "${height}px";
    }
    var windowwidth = window.innerWidth;
    var width = xtable.offsetWidth;
    xtable.style.left = "${((windowwidth - width)/2).toInt()}px";
    
  }
  
  void update(String wgtstr) {
    var table = query("div[is='x-table'] table");
    var wgt = 
        wgtstr != "" ?
          double.parse(wgtstr,(_)=> 0.0)
        : 0.0;
    
    _medication.keys.forEach((hdr){
      Map medmap = _medication[hdr];
      medmap.forEach((String med,medfunc){
        String low = "";
        String high = "";
        if(wgt>0) {
          var l = medfunc["l"](wgt);
          var h = medfunc["h"](wgt);
          
          low = 
              l - l.toInt() > 0 ?
                ((l*100).toInt()/100).toString()
              : l.toInt().toString();
                
          high =
              h - h.toInt() > 0 ?
                ((h*100).toInt()/100).toString()
              : h.toInt().toString();
        }
        
        med = med.replaceAll(" ", "");
        query("#$med .l").innerHtml = low;
        query("#$med .h").innerHtml = high;
      });
    });
  }
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