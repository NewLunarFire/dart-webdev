import 'dart:html';

void loadTitle() {
  querySelector("#title").text = window.localStorage["title"] ?? "My Planning Poker";
}

void bindTitle() {
  var titleEditButton = querySelector("#title-edit-button");
  titleEditButton.onClick.listen(toggleTitleEditMode);

  var titleEditBox = querySelector("#title-edit-box") as InputElement;
  titleEditBox.onBlur.listen(exitEditMode);
  titleEditBox.onKeyUp.listen((event) {
    if(event.keyCode == 13 || event.keyCode == 27)
      exitEditMode(event);
  });
}

void toggleTitleEditMode(Event event) {
  if(querySelector("#title-edit-box").classes.contains("hidden"))
    enterEditMode(event);
  else
    exitEditMode(event);
}

void enterEditMode(Event event)
{
  var title = querySelector("#title");
  var titleEditBox = querySelector("#title-edit-box") as InputElement;

  if(titleEditBox.classes.contains("hidden"))
  {
    title.classes.add("hidden");
    titleEditBox.value = title.text;
    titleEditBox.classes.remove("hidden");
    titleEditBox.focus();
  }
}

void exitEditMode(Event event)
{
  var title = querySelector("#title");
  var titleEditBox = querySelector("#title-edit-box") as InputElement;

  if(!titleEditBox.classes.contains("hidden"))
  {
    var value = titleEditBox.value;
    titleEditBox.classes.add("hidden");
    title.text = value;
    title.classes.remove("hidden");

    window.localStorage["title"] = value;
  }
}