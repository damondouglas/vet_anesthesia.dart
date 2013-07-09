library hop_runner;

import 'package:hop/hop.dart';
import 'package:hop/hop_tasks.dart';
import 'dart:async';
import 'dart:io';

void main() {
  
  var paths = ['web/vet_anesthesia.dart','web/lib/xheader.dart','web/lib/xmedsafeinput.dart','web/lib/xtable.dart'];
  
  addTask('analyze_libs', createAnalyzerTask(paths));
  
  runHop();
}