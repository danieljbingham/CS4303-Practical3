class UpgradeButton extends Button {

  public UpgradeButton(int x, int y, int w, int h, String text) {
    super(x, y, w, h, text);
  }
  
  public void draw(String subtext) {
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
    text(text, position.x + (btnWidth / 2), position.y + (btnHeight / 2) - 20);
    text(subtext, position.x + (btnWidth / 2), position.y + (btnHeight / 2) + 20);
    pop();
  }
}
