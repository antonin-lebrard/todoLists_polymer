@HtmlImport('main_app.html')
library perso_poly.lib.main_app;

import 'dart:html';
import 'dart:convert';

import 'package:polymer/polymer.dart';
import 'package:polymer_elements/paper_input.dart';
import 'package:polymer_elements/paper_button.dart';
import 'package:web_components/web_components.dart';

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
    PaperButton save2json = this.querySelector('#save');
    save2json.onClick.listen((e){
      if (username.value.length == 0)
        return;
      save(username.value);
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

  void save(String user){
    contactServer.user = user;
    contactServer.getAll().then((Map<String, List<String>> content){
      Map<String, dynamic> truSave = {user: content};
      AnchorElement a = document.createElement('a');
      a.setAttribute("href", 'data:text/plain;charset=utf-8,' + Uri.encodeComponent(JSON.encode(truSave)));
      a.setAttribute("download", "save.txt");
      Event event = new Event("click");
      a.dispatchEvent(event);
    });
  }
  
}
