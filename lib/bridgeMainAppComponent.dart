library perso_poly.lib.bridgeMainAppComponent;

import 'dart:html';

import 'component.dart';
import 'componentAdd.dart';
import 'note.dart';

class BridgeMainAppComponent {
  Element whereToInsert;

  List<Element> components = new List<Element>();

  BridgeMainAppComponent(this.whereToInsert){
    Element cA = new Element.tag("component-add");
    (cA as ComponentAdd).bridge = this;
    whereToInsert.children.add(cA);
  }

  applySearch(String value){
    List res = this.search(value, false, true);
    components.forEach((c){
      if (!res.contains(c))
        c.style.display = 'none';
      else
        c.style.display = '';
    });
  }

  List<Element> search(String name, [beginWith=true, contains=false, caseSensitive=false]){
    if (name.length==0)
      return components;
    List<Element> l = new List();
    components.forEach((c) {
      String compoName = (caseSensitive ? c.attributes["component_name"] : c.attributes["component_name"].toLowerCase());
      String searchValue = (caseSensitive ? name : name.toLowerCase());
      if (contains) {
        if (compoName.contains(searchValue))
          l.add(c);
      } else if (beginWith) {
        if (compoName.startsWith(searchValue))
          l.add(c);
      } else {
        if (compoName == searchValue)
          l.add(c);
      }
    });
    return l;
  }

  addComponent(String type){
    Element c = new Element.tag("component-block");
    c.attributes["component_name"] = type;
    whereToInsert.children.insert(whereToInsert.children.length - 1, c);
    components.add(c);
  }

  constructPrevComponents(Map<String, List<String>> content){
    content.forEach((String type, List<String> noteNames){
      Element compo = new Element.tag("component-block");
      compo.attributes["component_name"] = type.substring(0, 1).toUpperCase() + (type.length>1?type.substring(1):"");
      whereToInsert.children.insert(whereToInsert.children.length - 1, compo);
      (compo as Component).restoreNotes(noteNames);
    });
  }
}