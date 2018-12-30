class MapCoordinates {
  Counter counter;
  int lastValue;
  int x, y;
  ArrayList<MapCoordinates> possibleWays = new ArrayList<MapCoordinates>();
  MapCoordinates (int x, int y, Counter counter) { this.x = x; this.y = y; this.lastValue = map[x][y]; this.counter = counter; map[x][y] = 2; }
  
  MapCoordinates (int x, int y, Counter counter, boolean computer) {this.x = x; this.y = y; this.counter = counter; this.lastValue = 99;}

  void removeMapCoordinates() { map[x][y] = lastValue; }

  void possibleWays() {
    tryToAssignAWayComputer(this.x + 1, this.y + 1, this.counter, this);
    tryToAssignAWayComputer(this.x + 1, this.y - 1, this.counter, this);
    tryToAssignAWayComputer(this.x - 1, this.y + 1, this.counter, this);
    tryToAssignAWayComputer(this.x - 1, this.y - 1, this.counter, this);
    tryToAssignAWayComputer(this.x, this.y - 2, this.counter, this);
    tryToAssignAWayComputer(this.x, this.y + 2, this.counter, this);
  }
}

void popFromMapCoordinates(Counter counter) {
  int cpt = 0;
  while (cpt < availableWay.size()) {
    if (availableWay.get(cpt).counter.equals(counter)) {
      availableWay.get(cpt).removeMapCoordinates();
      availableWay.remove(cpt);
      cpt = 0;
    } else cpt ++;
  }
}

MapCoordinates findWay(int x, int y) {
  for (MapCoordinates c : availableWay) {
    if ((c.x == x) && (c.y == y)) {
      return c;
    }
  }
  return null;
}

boolean findWay(ArrayList<MapCoordinates> list, MapCoordinates target) {
  for (MapCoordinates mp : list) {
    if (mp.x == target.x && mp.y == target.y) return true;
  }
  return false;
}

MapCoordinates findPush(int x, int y) {
  for (MapCoordinates c : availablePush) {
    if ((c.x == x) && (c.y == y)) return c;
  }
  return null;
}

void deleteWay(int x, int y) {
  int i = 0;
  while (i < availableWay.size()) {
    if ((availableWay.get(i).x == x) && (availableWay.get(i).y == y)) {
      availableWay.get(i).removeMapCoordinates();
      availableWay.remove(i);
      break;
    }
    i++;
  }
}

int countWayDupplicates(int i, int j) {
  int k = 0, count = 0;
  while (k < availableWay.size()) {
    if ((availableWay.get(k).x == i) && (availableWay.get(k).y == j)) count++;
    k++;
  }
  return count;
}

void findAndDeleteDuplicates() {
  int k = 0;
  while ( k < availableWay.size()) {
    MapCoordinates mp = availableWay.get(k);
    if (countWayDupplicates(mp.x, mp.y) > 1) {
      int lastCorrectValue = 1;
      while (findWay(mp.x, mp.y) != null) {
        MapCoordinates withLastCorrectValue = findWay(mp.x, mp.y);
        if (withLastCorrectValue.lastValue != 2) lastCorrectValue = withLastCorrectValue.lastValue;
        deleteWay(mp.x, mp.y);
      }
      map[mp.x][mp.y] = lastCorrectValue;
      k = 0;
    } else {
      k ++;
    }
  }
}

void checkAllPush() {
  enemyCounters = removeDuplicateCounters(enemyCounters);
  ArrayList<Counter> toBeDeleted = new ArrayList<Counter>();
  ArrayList<MapCoordinates> removeMapCoordinatesAfter = new ArrayList<MapCoordinates>();
  for (MapCoordinates mapCoordinates : availablePush) {
    int pushX = mapCoordinates.counter.x - mapCoordinates.x, pushY = mapCoordinates.counter.y - mapCoordinates.y;
    Counter counter = searchCounter(mapCoordinates.counter.x + pushX, mapCoordinates.counter.y + pushY);
    if (counter.player != playerTurn) counter = searchCounter(counter.x + pushX, counter.y + pushY);
    if (counter != null) {
      Counter first_counter = counter;
      counter = searchCounter(counter.x + pushX, counter.y + pushY);
      if (counter == null) {
        counter = searchCounter(first_counter.x - pushX, first_counter.y - pushY); 
        while (counter != null) {
          toBeDeleted.add(counter);
          counter = searchCounter(counter.x - pushX, counter.y - pushY);
        }
        removeMapCoordinatesAfter.add(mapCoordinates);
      } else {
        if (!counter.selected) {
          counter = searchCounter(first_counter.x - pushX, first_counter.y - pushY);
          while (counter != null) {
            toBeDeleted.add(counter);
            counter = searchCounter(counter.x - pushX, counter.y - pushY);
          }
          removeMapCoordinatesAfter.add(mapCoordinates);
        }
      }
    } else {
      removeAll();
    }
  }
  toBeDeleted = removeDuplicateCounters(toBeDeleted);
  for (Counter counter : toBeDeleted) popFromList(enemyCounters, counter);
  for (MapCoordinates mapCoordinates : removeMapCoordinatesAfter) {
    popMapCoordinates(availablePush, mapCoordinates);
    if (searchPoint(mapCoordinates.x, mapCoordinates.y)) popFromPointList(availablePoints, mapCoordinates.x, mapCoordinates.y);
  }
}