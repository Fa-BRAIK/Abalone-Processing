PFont f;
PImage backgroundImage;
int i, j, h, w;
float r, g, b;
int customHeight = 550, customWidth = 950, boxSize = 50, ellipseSize = 38, stepX, stepY, playerScore = 0, computerScore = 0;
char playerTurn = 'p';
boolean menu = true, returnToGame = false;
int [][]map={{99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99},
              {99,99,99,99,99,1,0,1,0,1,0,1,0,1,99,99,99,99,99,99},
              {99,99,99,99,1,0,1,0,1,0,1,0,1,0,1,99,99,99,99,99},
              {99,99,99,1,0,1,0,1,0,1,0,1,0,1,0,1,99,99,99,99},
              {99,99,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,99,99,99},
              {99,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,99,99},
              {99,99,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,99,99,99},
              {99,99,99,1,0,1,0,1,0,1,0,1,0,1,0,1,99,99,99,99},
              {99,99,99,99,1,0,1,0,1,0,1,0,1,0,1,99,99,99,99,99},
              {99,99,99,99,99,1,0,1,0,1,0,1,0,1,99,99,99,99,99,99},
              {99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99}};
ArrayList<Counter> playerCounter = new ArrayList<Counter>();
ArrayList<Counter> computerCounter = new ArrayList<Counter>();
ArrayList<Counter> playerTurnCounters = new ArrayList<Counter>();
ArrayList<Counter> enemyCounters = new ArrayList<Counter>();
ArrayList<MapCoordinates> availableWay = new ArrayList<MapCoordinates>();
ArrayList<MapCoordinates> availablePush = new ArrayList<MapCoordinates>();
ArrayList<Point> availablePoints = new ArrayList<Point>();
State initialState;
String gameMode = "";

void setup() {
  backgroundImage = loadImage("background.jpg");
  size(911, 650);
  h = customHeight;
  w = customWidth;
  stepX = customWidth / boxSize;
  stepY = customHeight / boxSize;
  f = createFont("Serif.plain", 16, true);
  strokeCap(ROUND);
  strokeJoin(ROUND);
  ellipseMode(CENTER);
  textAlign(CENTER, CENTER);
  stroke(153);
  imageMode(CORNERS);
}

void draw() {
  if (!menu) drawBoard();
  else mainMenu();
}

void mouseClicked() {
  // if (!menu) println(mpEvolution(mouseY/ (customHeight / stepY), mouseX/ (customWidth / stepX)));
  if ((gameMode.equals("PvsP")) || (playerTurn == 'p')) 
  if (!menu) checkWhereMouseIsPressed(mouseY/ (customHeight / stepY), mouseX/ (customWidth / stepX));
  else clickMenu();
  if (!(gameMode.equals("PvsP")) && (playerTurn != 'p')) computreTurn();
}

void keyPressed() {
  if (!menu && (key == 'm' || key == 'M')) menu = true; 
}

void checkWhereMouseIsPressed(int i, int j) {
  Counter counter = searchCounter(i, j);
  if (counter != null) {
    if (counter.player == playerTurn)  {
      counter.selected = !counter.selected;
      if (counter.selected) {
        switch (playerTurnCounters.size()) {
          case 0 : { playerTurnCounters.add(counter); break; }
          case 1 : {
            Counter firstCounter = playerTurnCounters.get(0);
            if ((counter.equals(firstCounter.x + 1, firstCounter.y + 1)) || (counter.equals(firstCounter.x + 1, firstCounter.y - 1)) 
            || (counter.equals(firstCounter.x - 1, firstCounter.y + 1)) || (counter.equals(firstCounter.x - 1, firstCounter.y - 1)) 
            || (counter.equals(firstCounter.x, firstCounter.y + 2)) || (counter.equals(firstCounter.x, firstCounter.y - 2))) {
              playerTurnCounters.add(counter);
            } else {
              removeAll();
              playerTurnCounters.add(counter);
            }
            break;
          }
          case 2 : {
            Counter firstCounter = playerTurnCounters.get(0), secondCounter = playerTurnCounters.get(1);
            int y = abs(firstCounter.y - secondCounter.y);
            if (y == 2) {
              if (((abs(counter.x - firstCounter.x) == 0) && (abs(counter.y - firstCounter.y) == 2))
              || ((abs(counter.x - secondCounter.x) == 0) && (abs(counter.y - secondCounter.y) == 2))) {
                playerTurnCounters.add(counter);
              } else {
                removeAll();
                playerTurnCounters.add(counter);
              }
            } else {
              if (((abs(counter.x - firstCounter.x) == 1) && (abs(counter.y - firstCounter.y) == 1) 
                && (abs(counter.x - secondCounter.x) == 2) && (abs(counter.y - secondCounter.y) == 2))
              || ((abs(counter.x - secondCounter.x) == 1) && (abs(counter.y - secondCounter.y) == 1) 
                && (abs(counter.x - firstCounter.x) == 2) && (abs(counter.y - firstCounter.y) == 2))) {
                playerTurnCounters.add(counter);
              } else {
                removeAll();
                playerTurnCounters.add(counter);
              }
            }
            break;
          }
          case 3 : {
            removeAll();
            playerTurnCounters.add(counter);
            break;			
          }
        }
      } else {
        if (playerTurnCounters.size() == 3) {
          removeAll();
        } else {
          removePushMoves();
          popFromList(playerTurnCounters, counter);
          popFromMapCoordinates(counter);
        }
      }
    }
  } else {
    if ((availablePoints.size() > 0) && searchPoint(i, j)) {
      getPoint(i, j).markPoint(); 
      removeAll();
    } else {
      MapCoordinates mapCoordinates = findWay(i, j);
      if (mapCoordinates == null) {
        mapCoordinates = findPush(i, j);
        if (mapCoordinates != null) pushTo(i, j);
        else removeAll();
      } else {
        moveTo(i, j);
      }
    }
  }
  showAvaibleWay();
}

void showAvaibleWay() {
  removeAllMapCoordinates();
  for (Counter counter : playerTurnCounters) {
    tryToAssignAWay(counter.x + 1, counter.y + 1, counter);
    tryToAssignAWay(counter.x + 1, counter.y - 1, counter);
    tryToAssignAWay(counter.x - 1, counter.y + 1, counter);
    tryToAssignAWay(counter.x - 1, counter.y - 1, counter);
    tryToAssignAWay(counter.x, counter.y - 2, counter);
    tryToAssignAWay(counter.x, counter.y + 2, counter);
  }
  findAndDeleteDuplicates();
  checkAllWays();
  if (playerTurnCounters.size() >= 2) checkAllPush();
}
