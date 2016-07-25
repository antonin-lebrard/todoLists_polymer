@HtmlImport('main_app.html')
library perso_poly.lib.main_app;

import 'dart:html';
import 'dart:convert';
import 'dart:async';

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
    PaperButton loadFromJson = this.querySelector('#load');
    loadFromJson.onClick.listen((e){
      InputElement input = querySelector("#file");
      input.onChange.listen((_){
        FileList list = input.files;
        if (list.isEmpty) return;
        File file = list.first;
        FileReader reader = new FileReader();
        reader.onLoad.listen((_){
          load(reader.result.toString(), username.value);
        });
        reader.onError.listen((_) => print("error ${reader.error.code}"));
        reader.readAsText(file);
      });
      input.click();
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
      if (content is Map)
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

  Future load(String toLoad, String curUser) async {
    Map<String, dynamic> userContent = JSON.decode(toLoad);
    if (userContent == null || userContent.isEmpty) return;
    Map<String, List<String>> loadedContent = userContent.values.first;
    if (loadedContent == null || loadedContent.isEmpty) return;
    if (curUser == "") contactServer.user = userContent.keys.first;
    else contactServer.user = curUser;
    contactServer.getAll().then((Map<String, List<String>> otherContent) async{
      Map<String, Map<String, dynamic>> diff = makeDiff(loadedContent, otherContent);
      await Future.forEach(diff.keys, (String key) async {
        Map<String, dynamic> value = diff[key];
        if (value["isToAdd"]){
          await contactServer.addType(key);
        }
        await Future.forEach(value["notes"], (String note) async {
          print("adding $note");
          await contactServer.addNote(key, note);
        });
      });
      getAll(curUser);
    });
  }

  Map<String, Map<String, dynamic>> makeDiff(Map<String, List<String>> toLoad, Map<String, List<String>> original){
    Map<String, Map<String, dynamic>> diff = new Map();
    toLoad.keys.forEach((String key){
      diff[key] = {"isToAdd": false, "notes": new List<String>()};
      if (!original.containsKey(key)){
        diff[key]["isToAdd"] = true;
        original[key] = new List<String>();
      }
      toLoad[key].forEach((String note){
        if (!original[key].contains(note)){
          diff[key]["notes"].add(note);
        }
      });
    });
    return diff;
  }

}
