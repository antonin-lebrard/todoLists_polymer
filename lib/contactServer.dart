library perso_poly.lib.contactServer;

import 'dart:async';
import 'dart:html';
import 'dart:convert';

class contactServer {
  static String user = "";
  static String server = "http://51.254.201.22:8500";

  static Future<Map<String, List<String>>> getAll(){
    if (user == "") return new Future.value("{}");
    Completer<Map<String, List<String>>> completer = new Completer();
    Map<String, String> m = new Map();
    m["user"] = user;

    HttpRequest request = new HttpRequest()..open("POST", '$server/getAll');

    request.onReadyStateChange.listen((_) {
      if (request.readyState == HttpRequest.DONE &&
      (request.status == 200 || request.status == 0)) {
        String s = request.responseText;
        print(s);
        Map<String, List<String>> content = JSON.decode(s);
        print(s);
        completer.complete(content);
      }
    });
    request.send(JSON.encode(m));
    return completer.future;
  }

  static Future<String> addType(String type){
    Map<String, String> m = new Map();
    m["list"] = type;

    HttpRequest request = new HttpRequest()..open("POST", '$server/addType');
    request.onLoad.listen((event){},onDone:(){},onError:(e){print('err'+e.toString());});
    request.send(JSON.encode(m));
  }

  static Future<String> addNote(String type, String note){
    Map<String, String> m = new Map();
    m["user"] = user;
    m["list"] = type;
    m["name"] = note;

    HttpRequest request = new HttpRequest()..open("POST", '$server/addToDo');
    request.onLoad.listen((event){},onDone:(){},onError:(e){print('err'+e.toString());});
    request.send(JSON.encode(m));
  }

  static Future<String> delNote(String type, String note){
    Map<String, String> m = new Map();
    m["user"] = user;
    m["list"] = type;
    m["name"] = note;

    HttpRequest request = new HttpRequest()..open("POST", '$server/removeToDo');
    request.onLoad.listen((event){},onDone:(){},onError:(e){print('err'+e.toString());});
    request.send(JSON.encode(m));
  }

}