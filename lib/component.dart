@HtmlImport('component.html')
library perso_poly.lib.component;

import 'dart:html';

import 'package:polymer_elements/paper_toolbar.dart';
import 'package:polymer_elements/paper_input.dart';
import 'package:polymer/polymer.dart';
import 'package:web_components/web_components.dart';

import 'bridgeComponentNote.dart';

@PolymerRegister('component-block')
class Component extends PolymerElement {
  @property String component_name = "untitled";

  Component.created() : super.created();

  BridgeComponentNote _bridge;

  attached() {
    super.attached();
    print("component attached");

    DivElement addDiv = this.querySelector('#addDiv');
    this.querySelector('#compoDiv').children.remove(addDiv);

    Element e = new Element.tag("container");
    this.querySelector('#compoDiv').append(e);
    e.append(addDiv);
    _bridge = new BridgeComponentNote(e, component_name);

    PaperInput search = this.querySelector('#search');
    search.onKeyUp.listen((KeyboardEvent e){
      _bridge.applySearch(search.value);
    });

    PaperInput add = this.querySelector('#add');
    add.onSubmit.listen((KeyboardEvent e)=>e.preventDefault());
    add.onKeyUp.listen((KeyboardEvent e){
      if (e.keyCode == 13) {
        _bridge.addNote(add.value);
        add.value = "";
      }
    });
  }
  detached() {
    super.detached();
  }
  attributeChanged(String name, String oldValue, String newValue) {
    super.attributeChanged(name, oldValue, newValue);
    if (name == "component_name") {
      this.querySelector('#add').attributes["label"] = "$component_name to add";
      if (_bridge != null) _bridge.type = component_name;
    }
  }
  ready() {
    print("component ready");
    this.querySelector('#add').attributes["label"] = "$component_name to add";
  }
  restoreNotes(List<String> notes){
    notes.forEach((String note){
      _bridge.addNote(note, restoreNote: true);
    });
  }
}
