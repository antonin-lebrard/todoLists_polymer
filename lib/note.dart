@HtmlImport('note.html')
library perso_poly.lib.note;

import 'dart:html';

import 'package:polymer/polymer.dart';
import 'package:web_components/web_components.dart';

import 'contactServer.dart';

@PolymerRegister('note-block')
class Note extends PolymerElement {
  @property String note_name = "untitled";
  @property String type = "untyped";

  Note.created() : super.created();

  attached() {
    super.attached();
    print("note attached");
    this.querySelector('#google').onClick.listen((_){
      String google = "https://www.google.com/search?q=";
      window.open(google + this.note_name, 'Search ${this.note_name} on google');
    });
    this.querySelector('#del').onClick.listen((_){
      this.style.display = "none";
      contactServer.delNote(type, note_name);
    });
  }
  detached() {
    super.detached();
  }
  attributeChanged(String name, String oldValue, String newValue) {
    super.attributeChanged(name, oldValue, newValue);
  }
  ready() {
    print("note ready");
  }
}
