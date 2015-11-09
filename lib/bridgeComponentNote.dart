library perso_poly.lib.bridgeComponentNote;

import 'dart:html';
import 'note.dart';

import 'contactServer.dart';

class BridgeComponentNote {
  Element whereToInsert;
  String type;

  List<Element> notes = new List<Element>();

  BridgeComponentNote(this.whereToInsert, this.type);

  applySearch(String value){
    List res = this.search(value, false, true);
    notes.forEach((n){
      if (!res.contains(n))
        n.style.display = 'none';
      else
        n.style.display = '';
    });
  }

  List<Element> search(String name, [beginWith=true, contains=false]){
    if (name.length==0)
      return notes;
    List<Element> l = new List();
    notes.forEach((s) {
      if (contains) {
        if (s.attributes["note_name"].contains(name))
          l.add(s);
      } else if (beginWith) {
        if (s.attributes["note_name"].startsWith(name))
          l.add(s);
      } else {
        if (s.attributes["note_name"] == name)
          l.add(s);
      }
    });
    return l;
  }

  addNote(String value, {restoreNote: false}){
    if (!restoreNote)
      contactServer.addNote(type, value);

    Element n = new Element.tag("note-block");
    n.attributes["note_name"] = value;
    n.attributes["type"] = type;
    whereToInsert.children.add(n);
    notes.add(n);
  }
}