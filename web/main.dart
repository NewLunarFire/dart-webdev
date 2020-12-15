import 'dart:convert';
import 'dart:html';

class Task {
  final String id;
  final String title;
  final int points;

  Task(this.id, this.title, this.points) {}

  Task.fromJson(Map<String, dynamic> json):
    id = json['id'],
    title = json['title'],
    points = json['points'];

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'points': points
  };
}

List<Task> tasks = List.empty(growable: true);
var points = [0, 0, 0, 0];

DivElement createCard(Task task) {
  var div = Element.div();
  div.classes.add("card");
  div.id = "card-${task.id}";
  div.attributes
      .addAll({"draggable": "true", "data-points": task.points.toString()});

  var elTitle = Element.div();
  elTitle.classes.add("card-title");
  var spanTitle = Element.span();
  spanTitle.text = task.id;
  var closeButton = ButtonElement();
  closeButton.text = "X";
  closeButton.onClick.listen((event) => removeCard(div, task));
  elTitle.children.addAll([spanTitle, closeButton]);

  var elName = Element.div();
  elName.classes.add("card-name");
  elName.text = task.title;

  var elPoints = Element.div();
  elPoints.classes.add("card-points");
  elPoints.text = "${task.points}";

  div.children.addAll([elTitle, elName, elPoints]);
  div.onDragStart.listen(onDragStart);
  return div;
}

void removeCard(Element card, Task task) {
  changePoints(int.parse(card.parent.getAttribute("data-pane-index")), -task.points);

  querySelector("#card-${task.id}").remove();
  tasks.remove(task);
  saveTasks();
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

  var cardPoints = int.parse(card.getAttribute("data-points"));
  changePoints(int.parse(card.parent.getAttribute("data-pane-index")), -cardPoints);
  changePoints(int.parse(target.getAttribute("data-pane-index")), cardPoints);

  target.append(card);
}

void changePoints(int index, int delta)
{
  points[index] += delta;
  querySelector("#pane${index + 1}")
    .querySelector(".pane-points")
    .text = "${points[index]} points";
}

void onCreateTask(MouseEvent event) {
  var elIdField = querySelector("#task-id-field") as TextInputElement;
  var elTitleField = querySelector("#task-title-field") as TextInputElement;
  var elPointsField = querySelector("#task-points-field") as NumberInputElement;

  var id = elIdField.value;
  var title = elTitleField.value;
  var points = elPointsField.valueAsNumber;

  var task = Task(id, title, points);

  tasks.add(task);
  saveTasks();
  addTaskCardToFirstPane(task);

  elIdField.value = '';
  elTitleField.value = '';
  elPointsField.value = '1';
}

void addTaskCardToFirstPane(Task task) {
  var pane1 = querySelector("#pane1").querySelector(".pane-flow");

  pane1.children.add(createCard(task));
  points[0] += task.points;

  pane1.parent.querySelector(".pane-points").text = "${points[0]} points";
}

void saveTasks()
{
  window.localStorage["tasks"] = jsonEncode(tasks);
}

void main() {
  // Load tasks from localStorage
  var storedTasks = jsonDecode(window.localStorage["tasks"]);

  if(storedTasks is List)
    (storedTasks).map((json) => Task.fromJson(json)).forEach(tasks.add);

  tasks.forEach(addTaskCardToFirstPane);

  var panes = querySelectorAll(".pane");
  panes.onDragOver.listen(allowDrop);
  panes.onDrop.listen(onDrop);

  var createTaskButton = querySelector("#task-create-button");
  createTaskButton.onClick.listen(onCreateTask);
}
