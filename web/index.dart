// Copyright (c) 2015, <your name>. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.
library my_project.web.index;

import 'package:perso_poly/main_app.dart';
import 'package:perso_poly/component.dart';
import 'package:perso_poly/note.dart';
import 'package:polymer/polymer.dart';

import 'dart:html';
//import '../lib/html_helpers/dialogue_box.dart';
import 'dart:async';

/// [MainApp] used!
main() async {
  await initPolymer();


  /*new Timer(new Duration(seconds:5), (){
    CanvasElement canvas = querySelector('#canvas');
    canvas.width = window.innerHeight;
    canvas.height = window.innerHeight;
    window.onResize.listen((_){ canvas..width=window.innerWidth..height=window.innerHeight; });
    new DialogueBox("To create a Username or to 'login' use this box", querySelector('#username'), canvas)..draw();
  });*/
}
