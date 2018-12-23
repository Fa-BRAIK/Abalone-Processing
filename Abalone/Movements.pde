void tryToAssignAWay(int i, int j, Counter counter) {
  try {
    if ( checkWay(i, j) ) {
      availableWay.add(new MapCoordinates(i, j, counter));
    } else {
      if ( searchCounter(i, j) != null )  tryToAssignAPossiblePush(i, j, counter);
    }
  }
  catch (Exception e) {}
}

void tryToAssignAWayComputer(int i, int j, Counter counter, MapCoordinates mp) {
  try {
    if ( checkWay(i, j) ) {
      MapCoordinates mapCoordinates = new MapCoordinates(i, j, counter);
      if (!findWay(availableWay, mapCoordinates)) {
        availableWay.add(mapCoordinates);
        if (mp != null) mp.possibleWays.add(mapCoordinates);
        else counter.possibleWays.add(mapCoordinates);
      }
    } else {
      if ( searchCounter(i, j) != null )  tryToAssignAPossiblePush(i, j, counter);
    }
  }
  catch (Exception e) {}
}

void tryToAssignAPossiblePush(int i, int j, Counter counter) {
  try {
    ArrayList<Counter> counters = new ArrayList<Counter>();
    if ((searchCounter(i, j).player != playerTurn) && (playerTurnCounters.size() > 1)) {
      int depX = counter.x - i, depY = counter.y - j;
      Counter enemyCounter =  searchCounter(i, j);
      counters.add(enemyCounter);
      if (i == 5 && enemyCounter.y - depY == 17) {
        if (searchCounter(5, 15).player == searchCounter(5, 17).player)
        if (playerTurnCounters.size() > 2) {
          depY = abs(enemyCounter.y - counter.y) % 2;
          if (depY == 0) if (abs(playerTurnCounters.get(0).y - playerTurnCounters.get(1).y) == 2)
          availablePoints.add(new Point(5, 18, searchCounter(i, j)));
        }
      }
      else if (i == 5 && enemyCounter.y - depY == 19) {
        if (abs(playerTurnCounters.get(0).y - playerTurnCounters.get(1).y ) == abs(depY))
          availablePoints.add(new Point(5, 18, searchCounter(i, j)));
      } else {
        int x = enemyCounter.x - depX, y = enemyCounter.y - depY;
        enemyCounter = searchCounter(enemyCounter.x - depX, enemyCounter.y - depY);
        if (enemyCounter == null) {
          if (playerTurnCounters.size() > 1) {
            for (Counter c : counters) enemyCounters.add(c);
            if (map[x][y] == 99) {
              availablePush.add(new MapCoordinates(x, y, searchCounter(x + depX, y + depY)));
              availablePoints.add(new Point(x, y, searchCounter(x + depX, y + depY)));
            } else {
              availablePush.add(new MapCoordinates(x, y, searchCounter(x + depX, y + depY)));
            }
          }
        } else {
          x = enemyCounter.x - depX; y = enemyCounter.y - depY;
          counters.add(enemyCounter);
          enemyCounter = searchCounter(enemyCounter.x - depX, enemyCounter.y - depY);
          if (enemyCounter == null) {
            if (playerTurnCounters.size() > 2) {
              for (Counter c : counters) enemyCounters.add(c);
              if (map[x][y] == 99) { 
                availablePush.add(new MapCoordinates(x, y, searchCounter(x + depX, y + depY)));
                availablePoints.add(new Point(x, y, searchCounter(x + depX, y + depY)));
              } else {
                availablePush.add(new MapCoordinates(x, y, searchCounter(x + depX, y + depY)));
              }
            }
          }
        }
      }
    }
  } catch (Exception e) {
    if (i == 5 && j == 1) {
      Counter enemyCounter = searchCounter(i, j);
      if (enemyCounter != null) {
        int depY = abs(enemyCounter.y - counter.y);
        if (depY == 2) if (abs(playerTurnCounters.get(0).y - playerTurnCounters.get(1).y) == depY)
        availablePoints.add(new Point(5, 0, searchCounter(i, j)));
      }
    } else if (i == 5 && j == 3) {
      if (searchCounter(5, 1).player == searchCounter(5, 3).player)
      if (playerTurnCounters.size() > 2) {
        Counter enemyCounter = searchCounter(i, j);
        if (enemyCounter != null) {
          int depY = abs(enemyCounter.y - counter.y) % 2;
          if (depY == 0) if (abs(playerTurnCounters.get(0).y - playerTurnCounters.get(1).y) == 2)
            availablePoints.add(new Point(5, 0, searchCounter(i, j)));
        }
      }
    }
    else if (i == 5 && j ==15) {
      enemyCounters.add(searchCounter(i, j));
      availablePush.add(new MapCoordinates(i, j + 2, searchCounter(i, j)));
    }
  }
}


void leaveOnePossibleWayToPush(int i, int j) {
  ArrayList<Counter> counters = new ArrayList<Counter>(); 
  MapCoordinates mapCoordinates = findPush(i , j);
  int depX = mapCoordinates.counter.x - i, depY = mapCoordinates.counter.y - j;
  Counter counter = mapCoordinates.counter;
  while (counter.player != playerTurn)  {
    counters.add(counter);
    counter = searchCounter(counter.x + depX, counter.y + depY);
  }
  enemyCounters = counters;
}

void leaveOnePossibleWayToPushCustom(int depX, int depY, Counter target) {
  ArrayList<Counter> enemyCountersCopy = new ArrayList<Counter>();
  ArrayList<Counter> playerTurnCountersCopy = new ArrayList<Counter>();
  enemyCountersCopy.add(target);
  Counter counter = searchCounter(target.x + depX, target.y + depY);
  if (counter.player != playerTurn) {
    enemyCountersCopy.add(counter);
    counter = searchCounter(counter.x + depX, counter.y + depY);
  }
  while (counter.player == playerTurn) {
    playerTurnCountersCopy.add(counter);
    counter = searchCounter(counter.x + depX, counter.y + depY);
    if (counter == null) break;
  }
  enemyCounters = enemyCountersCopy;
  playerTurnCounters = playerTurnCountersCopy;
}