void  drawBoard() {
  image(backgroundImage, 0, 0);
  drawLignes();
  noStroke();
  for (i = 0; i < stepY; i++) {
    for (j = 0; j < stepX; j++) {
      Counter counter = searchCounter(i, j); 
      switch (map[i][j]) {
        case 0 : noFill(); break;	
        case 1 : fill(200); break;
        case 2 : fill(206, 177, 128); break;
        case 3 : fill(157, 96, 121); break;
        case 99: noFill(); break;
      }
      pushMatrix();
      translate(5, 5);
      ellipse(j * boxSize, i * boxSize, 30, 30);
      popMatrix();
      if (counter != null) {
        if (counter.selected) fill(counter.cSelected);
        else fill(counter.c);
        strokeWeight(2); stroke(counter.strokeColor);
        ellipse((w - (w - j * boxSize) + boxSize / 2) - 20, (h - (h - i * boxSize) + boxSize / 2) - 20, ellipseSize, ellipseSize);
        noStroke();
      }
    }
  }
  scoreboard();
}

void drawLignes() {
  strokeWeight(7); stroke(200);
  // -- lignes
  line(255, 55, 655, 55); line(205, 105, 705, 105); line(155, 155, 755, 155);
  line(105, 205, 805, 205); line(55, 255, 855, 255); line(105, 305, 805, 305);
  line(155, 355, 755, 355); line(205, 405, 705, 405); line(255, 455, 655, 455);

  // / lignes
  line(55, 255, 255, 55); line(105, 305, 355, 55); line(155, 355, 455, 55);
  line(205, 405, 555, 55); line(255, 455, 655, 55); line(355, 455, 705, 105);
  line(455, 455, 755, 155); line(555, 455, 805, 205); line(655, 455, 855, 255);

  // \ lignes
  line(855, 255, 655, 55); line(805, 305, 555, 55); line(755, 355, 455, 55);
  line(705, 405, 355, 55); line(655, 455, 255, 55); line(555, 455, 205, 105);
  line(455, 455, 155, 155); line(355, 455, 105, 205); line(250, 455, 55, 255);
  
  strokeWeight(20); stroke(70);
  
  // between out and in
  line(10, 255, 55, 255); line(855, 255, 900, 255);
  line(240, 25, 255, 55); line(673, 26, 653, 55);
  line(255, 455, 240, 487); line(655, 455, 673, 487);

  // out of game lines
  line(10, 255, 235, 20); line(10, 255, 240, 490);
  line(675, 20, 240, 20); line(675, 490, 240, 490);
  line(680, 20, 900, 255); line(675, 490, 900, 255);
}

void scoreboard() {
  String name;
  textFont(f,28); strokeWeight(7); stroke(200); 
  fill(70); rect(55, 530, 300, 100, 25, 0, 0, 25); fill(200);
  if (gameMode.equals("PvsP")) text("Player 1 Score : " + playerScore, 205, 580);
  else text("Player Score : " + playerScore, 205, 580);
  fill(70); rect(555, 530, 300, 100, 0, 25, 25, 0); fill(200);
  if (gameMode.equals("PvsP")) text("Player 2 Score : " + computerScore, 705, 580);
  else text("Computer Score : " + computerScore, 705, 580);
  color textColor = (playerTurn == 'p')? color(199, 0, 57) : color(41, 125, 125);
  if (gameMode.equals("PvsP")) name = (playerTurn == 'p')? "Player 1" : "Player 2";
  else name = (playerTurn == 'p')? "Player" : "Computer";
  fill(200); rect(355, 530, 200, 100); noStroke();
  fill(textColor); text(name + " Turn", 455, 580); 
}

void mainMenu() {
  image(backgroundImage, 0, 0, 1000, 750);
  textFont(f,38); stroke(240); strokeWeight(1);
  fill(120, 120, 120, 150); rect(155, 60, 620, 100, 25, 25, 25, 25);
  fill(240); text("New Game / Player Vs Player", 470, 100);
  fill(120, 120, 120, 150); rect(155, 210, 620, 100, 25, 25, 25, 25);
  fill(240); text("New Game / Player Vs Computer", 475, 250);
  color rectColor;
  if (gameMode.equals("PvsC")) rectColor = (playerTurn == 'p') ? color(199, 0, 57) : color(41, 125, 125);
  else rectColor = (playerTurn == 'c') ? color(199, 0, 57) : color(41, 125, 125);
  fill(rectColor, 150); textFont(f,50); noStroke();
  if (gameMode.equals("PvsC")) {
    if (playerScore == 6) {
      rect(0, 350, 911, 200);
      fill(240); text("Player Is The Winner Congrats!!!", 460.5, 430);
    }
    if (computerScore == 6) {
      rect(0, 350, 911, 200);
      fill(240); text("Computer Is The Winner :( !!!", 460.5, 430);
    }
  } else {
    if (playerScore == 6) {
      rect(0, 350, 911, 200);
      fill(240); text("Player 1 Is The Winner Congrats!!!", 460.5, 430);
    }
    if (computerScore == 6) {
      rect(0, 350, 911, 200);
      fill(240); text("Player 2 Is The Winner Congrats!!!", 460.5, 430);
    }
  }
  textFont(f,38); stroke(240); strokeWeight(1);
  if (returnToGame) {
    fill(120, 120, 120, 150); rect(155, 510, 620, 100, 25, 25, 25, 25);
    fill(255); text("Resume Game", 455, 550);
  }
}