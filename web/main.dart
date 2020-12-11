import 'dart:html';

var tasks = [
  {"id": "TEST-1", "title": "Do something cool", "points": 1},
  {"id": "TEST-2", "title": "Do something even cooler", "points": 3},
  {"id": "TEST-3", "title": "Hide the pain", "points": 5}
];

var points = [0, 0, 0, 0];

DivElement createCard(String id, String name, int points) {
  var div = Element.div();
  div.classes.add("card");
  div.id = "card-${id}";
  div.attributes
      .addAll({"draggable": "true", "data-points": points.toString()});

  var elTitle = Element.div();
  elTitle.classes.add("card-title");
  elTitle.text = id;

  var elName = Element.div();
  elName.classes.add("card-name");
  elName.text = name;

  var elPoints = Element.div();
  elPoints.classes.add("card-points");
  elPoints.text = "${points}";

  div.children.addAll([elTitle, elName, elPoints]);
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

  var target = event.target as Element;

  while (!target.classes.contains("pane")) target = target.parent;
  target = target.querySelector(".pane-flow");

  var origPaneIndex = int.parse(card.parent.getAttribute("data-pane-index"));
  var paneIndex = int.parse(target.getAttribute("data-pane-index"));
  var cardPoints = int.parse(card.getAttribute("data-points"));
  points[origPaneIndex] -= cardPoints;
  points[paneIndex] += cardPoints;

  querySelector("#pane${paneIndex + 1}").querySelector(".pane-points").text =
      "${points[paneIndex]} points";

  querySelector("#pane${origPaneIndex + 1}")
      .querySelector(".pane-points")
      .text = "${points[origPaneIndex]} points";

  target.append(card);
}

void main() {
  var pane1 = querySelector("#pane1").querySelector(".pane-flow");

  for (var task in tasks) {
    pane1.children.add(createCard(task["id"], task["title"], task["points"]));
    points[0] += task["points"];
  }

  pane1.parent.querySelector(".pane-points").text = "${points[0]} points";

  var cards = querySelectorAll(".card");
  var panes = querySelectorAll(".pane");

  cards.onDragStart.listen(onDragStart);
  panes.onDragOver.listen(allowDrop);
  panes.onDrop.listen(onDrop);
}
