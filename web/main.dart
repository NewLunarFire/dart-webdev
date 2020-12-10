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
  div.id = "card-${id}";
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

void onDragStart(MouseEvent event) {
  event.dataTransfer.setData("text", (event.target as Element).id);
}

void allowDrop(MouseEvent event) => event.preventDefault();

void onDrop(MouseEvent event) {
  event.preventDefault();

  var id = event.dataTransfer.getData("text");
  var card = querySelector("#${id}");
  (event.target as Element).append(card);
}

void main() { 
  var pane1 = querySelector("#pane1");
  var pane2 = querySelector("#pane2");

  pane1.onDragStart.listen(onDragStart);
  pane2.onDragOver.listen(allowDrop);
  pane2.onDrop.listen(onDrop);

  for (var task in a1)
    pane1.children.add(createCard(task["id"], task["title"]));
}
