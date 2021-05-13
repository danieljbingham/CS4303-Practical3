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
  
  public void draw() {
    push();
    textSize(18);
    fill(0);
    stroke(255,255,255);
    if (inButton(mouseX, mouseY)) {
      fill(40);
    }
    rect(position.x, position.y, btnWidth, btnHeight);
    textAlign(CENTER,CENTER);
    fill(255);
    text(text, position.x + (btnWidth / 2), position.y + (btnHeight / 2));
    pop();
  }
}
