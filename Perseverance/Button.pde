class Button {
  
  PVector position;
  int btnWidth;
  int btnHeight;
  String text;
  
  public Button(int x, int y, int w, int h, String text) {
    position = new PVector(x, y);
    this.text = text;
    btnWidth = w;
    btnHeight = h;
  }
  
  public boolean inButton(int x, int y) {
    return x >= position.x && x <= position.x + btnWidth &&
    y >= position.y && y <= position.y + btnHeight;
  }
  
  public void draw(int offsetX) {
    push();
    textSize(18);
    fill(0);
    stroke(255,255,255);
    println(text + ": " + mouseX + " + " + offsetX + " in " + position.x + " to " + (position.x+btnWidth));
    if (inButton(mouseX, mouseY)) {
      fill(40);
    }
    rect(position.x + offsetX, position.y, btnWidth, btnHeight);
    textAlign(CENTER,CENTER);
    fill(255);
    text(text, position.x + offsetX + (btnWidth / 2), position.y + (btnHeight / 2));
    pop();
  }
}
