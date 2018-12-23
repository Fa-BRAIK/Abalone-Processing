class Counter {
  int x, y;
  color c, cSelected, strokeColor;
  char player;
  boolean selected = false;
  ArrayList<MapCoordinates> possibleWays = new ArrayList<MapCoordinates>();

  Counter(int x, int y, char player) {
    this.x = x;
    this.y = y;
    this.player = player;
    if (player == 'c') {
      c = color (41, 125, 125);
      cSelected = color (21, 66, 66);
      strokeColor = color(38, 83, 104);
    }
    else {
      c = color(199, 0, 57);
      cSelected = color(130, 0, 36);
      strokeColor = color(86, 13, 13);
    }
  }

  boolean equals(Counter c) {
    return ((this.x == c.x) && (this.y == c.y));
  }

  boolean equals(int x, int y) {
    return ((this.x == x) && (this.y == y));
  }

  void possibleWays() {
    tryToAssignAWayComputer(this.x + 1, this.y + 1, this, null);
    tryToAssignAWayComputer(this.x + 1, this.y - 1, this, null);
    tryToAssignAWayComputer(this.x - 1, this.y + 1, this, null);
    tryToAssignAWayComputer(this.x - 1, this.y - 1, this, null);
    tryToAssignAWayComputer(this.x, this.y - 2, this, null);
    tryToAssignAWayComputer(this.x, this.y + 2, this, null);
  }
}

Counter searchCounter(int x, int y) {
  for (Counter c : playerCounter) {
    if (c.equals(x, y)) return c;
  }
  for (Counter c : computerCounter) {
    if (c.equals(x, y)) return c;
  }
  return null;
}

Counter searchCounter(int x, int y, ArrayList<Counter> list) {
  for (Counter c : list) {
    if (c.equals(x, y)) return c;
  }
  return null;
}

Counter searchCounterState(int x, int y, State state) {
  for (Counter c : state.playerCounters) {
    if (c.equals(x, y)) return c;
  }
  for (Counter c : state.computerCounters) {
    if (c.equals(x, y)) return c;
  }
  return null;
}


boolean findCounter(ArrayList<Counter> list, Counter target) {
  for (Counter c : list) {
    if (c.equals(target)) return true;
  }
  return false;
}

ArrayList<Counter> removeDuplicateCounters(ArrayList<Counter> counters) {
  ArrayList<Counter> copy = new ArrayList<Counter>();
  int i = 0;
  while (i < counters.size()) {
    if (!findCounter(copy, counters.get(i))) {
      copy.add(counters.get(i));
    }
    i++;
  }
  return copy;
}

void moveTo(int i, int j) {
  MapCoordinates mapCoordinates = findWay(i, j);
  int depX = mapCoordinates.counter.x - i, depY = mapCoordinates.counter.y - j;
  for (Counter counter : playerTurnCounters) {
    counter.x -= depX;
    counter.y -= depY;
  }
  playerTurn = (playerTurn == 'p') ? 'c' : 'p';
  // playerTurn = 'p';
  removeAll();
}

void pushTo(int i, int j) {
  if (availablePush.size() == 2) leaveOnePossibleWayToPush(i, j);
  MapCoordinates mapCoordinates = findPush(i , j);
  int depX = mapCoordinates.counter.x - i, depY = mapCoordinates.counter.y - j;
  for (Counter counter : enemyCounters) {
    counter.x -= depX;
    counter.y -= depY;
  }
  for (Counter counter : playerTurnCounters) {
    counter.x -= depX;
    counter.y -= depY;
  }
  playerTurn = (playerTurn == 'p') ? 'c' : 'p';
  // playerTurn = 'p';
  removeAll();
}

int searchForNighboringTeamMates(Counter target, ArrayList<Counter> list) {
    int totalNighboringTeamMates = 0;   Counter counter;
    // test for each possible move
    counter = searchCounter(target.x + 1, target.y - 1, list);
    if (counter != null && counter.player == target.player) totalNighboringTeamMates++;
    counter = searchCounter(target.x - 1, target.y + 1, list);
    if (counter != null && counter.player == target.player) totalNighboringTeamMates++;
    counter = searchCounter(target.x + 1, target.y + 1, list);
    if (counter != null && counter.player == target.player) totalNighboringTeamMates++;
    counter = searchCounter(target.x - 1, target.y - 1, list);
    if (counter != null && counter.player == target.player) totalNighboringTeamMates++; 
    counter = searchCounter(target.x, target.y + 2, list);
    if (counter != null && counter.player == target.player) totalNighboringTeamMates++;
    counter = searchCounter(target.x, target.y - 2, list);
    if (counter != null && counter.player == target.player) totalNighboringTeamMates++;
    return totalNighboringTeamMates;
}