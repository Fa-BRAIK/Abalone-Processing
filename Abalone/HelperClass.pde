boolean checkWay(int i, int j) {
  return ( (map[i][j] != 99) && (map[i][j] != 0) && (searchCounter(i, j) == null) );
}

boolean checkWayToMove(int i, int j) {
  if ( (map[i][j] != 99) && (map[i][j] != 0) ) {
    if ( searchCounter(i, j) == null ) {
      return true;
    } else {
      return findCounter(playerTurnCounters, searchCounter(i, j));
    }
  }
  return false;
}

void checkAllWays() {
  int i;
  MapCoordinates mapCoordinates;
  ArrayList<MapCoordinates> toBeDeleted = new ArrayList<MapCoordinates>();
  if (availableWay.size() != 0) {
    i = 0;
    while (i < availableWay.size()) {
      mapCoordinates = availableWay.get(i);
      int depX = mapCoordinates.counter.x - mapCoordinates.x, depY = mapCoordinates.counter.y - mapCoordinates.y;
      for (Counter counter : playerTurnCounters) {
        if (!checkWayToMove(counter.x - depX, counter.y - depY)) {
          toBeDeleted.add(mapCoordinates);
          break;
        }
      }
      i++;
    }
    while (toBeDeleted.size() != 0) {
      deleteWay(toBeDeleted.get(0).x, toBeDeleted.get(0).y);
      toBeDeleted.remove(0);
    }
  }
}

void removeAllMapCoordinates() {
  while (availableWay.size() != 0) {
    availableWay.get(0).removeMapCoordinates();
    availableWay.remove(0);
  }

  while (availablePush.size() != 0) {
    availablePush.get(0).removeMapCoordinates();
    availablePush.remove(0);
  }
}

void removePushMoves() {
  while (availablePush.size() != 0) {
    availablePush.get(0).removeMapCoordinates();
    availablePush.remove(0);
  }
  while (enemyCounters.size() != 0) {
    enemyCounters.remove(0);
  }
  while (availablePoints.size() != 0) {
    availablePoints.get(0).selfDestroy();
    availablePoints.remove(0);
  }
}

void removeAll() {
  while (availableWay.size() != 0) {
    availableWay.get(0).removeMapCoordinates();
    availableWay.remove(0);
  }
  while (playerTurnCounters.size() != 0) {
    Counter counter = playerTurnCounters.get(0);
    counter.selected = false;
    playerTurnCounters.remove(0);
  }
  while (availablePush.size() != 0) {
    availablePush.get(0).removeMapCoordinates();
    availablePush.remove(0);
  }
  while (enemyCounters.size() != 0) {
    enemyCounters.remove(0);
  }
  while (availablePoints.size() != 0) {
    availablePoints.get(0).selfDestroy();
    availablePoints.remove(0);
  }
}

void popMapCoordinates(ArrayList<MapCoordinates> list, MapCoordinates target) {
  int i = 0; boolean found = false;
  while (i < list.size()) {
    if (list.get(i).x == target.x && list.get(i).y == target.y) {
      found = true;
      break;
    }
    i++;
  }
  if (found) {
    list.get(i).removeMapCoordinates();
    list.remove(i);
  }
}

void popFromList(ArrayList<Counter> list, Counter target) {
  int i = 0; boolean found = false;
  while (i < list.size()) {
    if (list.get(i).equals(target)) {
      found = true;
      break;
    }
    i++;
  }
  if (found) list.remove(i);
}

void popEveryThing(ArrayList<Counter> list) {
  int i = 0;
  while (list.size() > 0) list.remove(0);
}

ArrayList<Counter> copyList(ArrayList<Counter> list) {
  ArrayList<Counter> returnedList = new ArrayList<Counter>();
  for (Counter counter : list) 
    returnedList.add(new Counter(counter.x, counter.y, counter.player));
  return returnedList;
}

void initGame() {
  removeAll();
  popEveryThing(computerCounter);   popEveryThing(playerCounter);
  playerScore = 0; computerScore = 0; playerTurn = 'p'; returnToGame = true; menu = false;
  computerCounter.add(new Counter(3, 11, 'c')); computerCounter.add(new Counter(3, 9, 'c')); computerCounter.add(new Counter(3, 7, 'c'));
  computerCounter.add(new Counter(1, 5, 'c')); computerCounter.add(new Counter(1, 7, 'c')); computerCounter.add(new Counter(1, 9, 'c'));
  computerCounter.add(new Counter(1, 11, 'c')); computerCounter.add(new Counter(1, 13, 'c')); computerCounter.add(new Counter(2, 6, 'c'));
  computerCounter.add(new Counter(2, 8, 'c')); computerCounter.add(new Counter(2, 10, 'c')); computerCounter.add(new Counter(2, 12, 'c')); 
  computerCounter.add(new Counter(2, 14, 'c')); computerCounter.add(new Counter(2, 4, 'c')); playerCounter.add(new Counter(7, 7, 'p')); 
  playerCounter.add(new Counter(7, 9, 'p')); playerCounter.add(new Counter(7, 11, 'p')); playerCounter.add(new Counter(8, 4, 'p'));
  playerCounter.add(new Counter(8, 6, 'p')); playerCounter.add(new Counter(8, 8, 'p'));
  playerCounter.add(new Counter(8, 10, 'p')); playerCounter.add(new Counter(8, 12, 'p')); playerCounter.add(new Counter(8, 14, 'p'));
  playerCounter.add(new Counter(9, 13, 'p')); playerCounter.add(new Counter(9, 11, 'p')); playerCounter.add(new Counter(9, 9, 'p'));
  playerCounter.add(new Counter(9, 7, 'p')); playerCounter.add(new Counter(9, 5, 'p')); 
}
