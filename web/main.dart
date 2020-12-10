import 'dart:html';

var tasks = [{
  "id": "TEST-1",
  "title": "Do something cool"
}, {
  "id": "TEST-2",
  "title": "Do something even cooler"  
}, {
  "id": "TEST-3",
  "title": "Hide the pain"  
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
  print(event.target);
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
  for (var task in tasks)
    querySelector("#pane1").children.add(createCard(task["id"], task["title"]));

  var cards = querySelectorAll(".card");
  var panes = querySelectorAll(".pane");

  cards.onDragStart.listen(onDragStart);
  panes.onDragOver.listen(allowDrop);
  panes.onDrop.listen(onDrop);
}
