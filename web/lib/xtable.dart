import 'package:web_ui/web_ui.dart';
import 'dart:html';

class Table extends WebComponent {

  @observable
  String _wgtstr="";
  double _wgt = 0.0;
  
  /*Map _medication = 
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
    };*/
  
  void update(String model){
    InputElement _model = query("#model");
    _wgtstr = _model.value;
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
}