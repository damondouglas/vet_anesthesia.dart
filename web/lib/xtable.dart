import 'package:web_ui/web_ui.dart';
import 'dart:html';

class Table extends WebComponent {

  @observable
  String _wgtstr="";
  double _wgt = 0.0;
  int _tablePos = 105;
  
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
     }
    };
  
  void update(String model){
    InputElement _model = query("#model");
    _wgtstr = _model.value;
    try {
      _wgt = double.parse(_wgtstr);
    } catch(e) {
      _wgt = 0.0;
    }
    buildstyle();
    window.onResize.listen((data){
      buildstyle();
    });
    window.onDeviceOrientation.listen((data){
      buildstyle();
    });
    window.onScroll.listen((data){
      scroll();
    });
  }
  
  void _drawTable(){
    Element tbody = query("#data");
    _medication.keys.forEach((head){
      var hd = 
        """
          <tr><td class="medhead" colspan="3">$head</td></tr>
        """;
      tbody.appendHtml(hd);
      Map map = _medication[head];
      map.forEach((med, fmap){
        String low = fmap["l"](_wgt).toStringAsFixed(2);
        String high = fmap["h"](_wgt).toStringAsFixed(2);
        
        var td = 
          """
            <tr>
              <td>$med</td>
              <td class="l">$low</td>
              <td class="h">$high</td>
            </tr>
          """;
          tbody.appendHtml(td);
      });
    });
  }
  
  void buildstyle(){
    DivElement th = query("#th");
    int width = 230;
    int left = ((window.innerWidth - width)/2).toInt();
    
    th.style
    ..position = "fixed"
    ..width = "${width}px"
    ..height = "55px"
    ..top = "50px"
    ..left = "${left}px";
    
    DivElement sp = query("#spacer");
    sp.style
    ..position = "fixed"
    ..height = "90px"
    ..top = "0"
    ..left = "${left}px"
    ..width = "${width}px";
    
    TableElement tht = query("#th table");
    th.style
    ..position = "fixed"
    ..width = "${width}px"
    //..top = "55px"
    ..left = "${left}px";
    
    DivElement tb = query("#tb");
    tb.style
    ..position = "fixed"
    ..width = "${width}px"
    ..top = "${_tablePos}px"
    ..left = "${left}px";
    
  }
  
  void scroll() {
    var y = window.scrollY;
    _tablePos = 105 - y;
    DivElement tb = query("#tb");
    tb.style.top = "${_tablePos}px";
    
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