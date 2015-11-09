@HtmlImport('componentAdd.html')
library perso_poly.lib.componentAdd;

import 'dart:html';

import 'package:polymer_elements/paper_input.dart';
import 'package:polymer/polymer.dart';
import 'package:web_components/web_components.dart';

import 'bridgeMainAppComponent.dart';
import 'contactServer.dart';

@PolymerRegister('component-add')
class ComponentAdd extends PolymerElement {

  ComponentAdd.created() : super.created();

  BridgeMainAppComponent bridge;

  attached() {
    super.attached();
    print("component-add attached");
    PaperInput category = this.querySelector('#category');
    category.onSubmit.listen((KeyboardEvent e)=>e.preventDefault());
    category.onKeyUp.listen((KeyboardEvent e){
      if (e.keyCode == 13) {
        bridge.addComponent(category.value);
        contactServer.addType(category.value);
        category.value = "";
      }
    });
    Element redBackground = this.querySelector('#redBackground');
    Element inputBackground = this.querySelector('#inputBackground');
    Element component = this.querySelector('#component');
    category.onFocus.listen((_){
      redBackground.style.animation = "red-fade-in 1s forwards";
      inputBackground.style.animation = "box-shadow-and-border-fade-in 1s forwards";
      component.style.animation = "box-shadow-and-border-compo-fade-in 1s forwards";
    });
    category.onBlur.listen((_){
      redBackground.style.animation = "red-fade-out 1s forwards";
      inputBackground.style.animation = "box-shadow-and-border-fade-out 1s forwards";
      component.style.animation = "box-shadow-and-border-compo-fade-out 1s forwards";
    });

  }
  detached() {
    super.detached();
  }
  attributeChanged(String name, String oldValue, String newValue) {
    super.attributeChanged(name, oldValue, newValue);
  }
  ready() {
    print("component-add ready");
  }
}
