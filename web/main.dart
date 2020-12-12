import 'dart:html';

class Task {
  final String id;
  final String title;
  final int points;

  Task(this.id, this.title, this.points) {}
}

var tasks = [
  Task("TEST-1", "Do something cool", 1),
  Task("TEST-2", "Do something even cooler", 3),
  Task("TEST-3", "Hide the pain", 5)
];

var points = [0, 0, 0, 0];

DivElement createCard(Task task) {
  var div = Element.div();
  div.classes.add("card");
  div.id = "card-${task.id}";
  div.attributes
      .addAll({"draggable": "true", "data-points": task.points.toString()});

  var elTitle = Element.div();
  elTitle.classes.add("card-title");
  elTitle.text = task.id;

  var elName = Element.div();
  elName.classes.add("card-name");
  elName.text = task.title;

  var elPoints = Element.div();
  elPoints.classes.add("card-points");
  elPoints.text = "${task.points}";

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

  tasks.forEach((task) {
    pane1.children.add(createCard(task));
    points[0] += task.points;
  });

  pane1.parent.querySelector(".pane-points").text = "${points[0]} points";

  var cards = querySelectorAll(".card");
  var panes = querySelectorAll(".pane");

  cards.onDragStart.listen(onDragStart);
  panes.onDragOver.listen(allowDrop);
  panes.onDrop.listen(onDrop);
}
