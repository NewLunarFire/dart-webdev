import 'dart:html';

var a1 = [{
  "id": "TEST-1",
  "title": "Do something cool"
}, {
  "id": "TEST-2",
  "title": "Do something even cooler"  
}];

DivElement createCard(String id, String name)
{
  var div = Element.div();
  div.classes.add("card");
  div.attributes.addAll({"draggable": "true"});

  var elTitle = Element.div();
  elTitle.classes.add("card-title");
  elTitle.text = id;

  var elName = Element.div();
  elName.classes.add("card-name");
  elName.text = name;

  div.children.addAll([elTitle, elName]);
  return div;
}

void main() { 
  var body = querySelector("body");
  for (var task in a1)
    body.children.add(createCard(task["id"], task["title"]));
}
