@HtmlImport('main_app.html')
library perso_poly.lib.main_app;

import 'dart:html';
import 'dart:convert';

import 'package:polymer_elements/paper_toolbar.dart';
import 'package:polymer_elements/paper_input.dart';
import 'package:polymer/polymer.dart';
import 'package:web_components/web_components.dart';

import 'component.dart';
import 'note.dart';
import 'componentAdd.dart';
import 'bridgeMainAppComponent.dart';
import 'contactServer.dart';

@PolymerRegister('main-app')
class MainApp extends PolymerElement {

  MainApp.created() : super.created();

  BridgeMainAppComponent _bridge;

  attached() {
    super.attached();
    print("attached");
    Element e = new Element.tag("content");
    e.style..display="flex"..flexDirection="row"..flexWrap="wrap";
    this.append(e);
    _bridge = new BridgeMainAppComponent(e);

    PaperInput username = this.querySelector('#username');
    username.onKeyDown.listen((e){
      if (e.keyCode == 13) {
        if (username.value.length == 0)
          return;
        querySelectorAll('.noteStyle').forEach((Element e){
          e.style.display = "none";
        });
        getAll(username.value);
      }
    });
  }
  detached() {
    super.detached();
  }
  attributeChanged(String name, String oldValue, String newValue) {
    super.attributeChanged(name, oldValue, newValue);
  }
  ready() {
    print("ready");
  }

  void getAll(String user){
    contactServer.user = user;
    querySelectorAll('component-block').forEach((Element e){
      e.style.display = "none";
    });
    contactServer.getAll().then((Map<String, List<String>> content){
      _bridge.constructPrevComponents(content);
    });
  }
}
