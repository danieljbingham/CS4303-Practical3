class UpgradeButton extends Button {

  public UpgradeButton(int x, int y, String text) {
    super(x, y, text);
    btnWidth = 300;
    btnHeight = 125;
  }
  
  public void draw() {
    push();
    fill(0);
    if (inButton(mouseX, mouseY)) {
      fill(40);
    }
    rect(position.x, position.y, btnWidth, btnHeight);
    textAlign(CENTER,CENTER);
    fill(255);
    text(text, position.x + (btnWidth / 2), position.y + (btnHeight / 2) - 20);
    text(text, position.x + (btnWidth / 2), position.y + (btnHeight / 2) + 20);
    pop();
  }
}
