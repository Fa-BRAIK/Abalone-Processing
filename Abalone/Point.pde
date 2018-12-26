class Point {
    Counter counter;
    int x, y;
    int lastColor;
    Point (int x, int y, Counter counter) {this.x = x; this.y = y; this.counter = counter; lastColor = 99; map[x][y] = 3;}
    Point (int x, int y, Counter counter, boolean computer) {this.x = x; this.y = y; this.counter = counter; lastColor = 99;}
    void selfDestroy() {map[x][y] = lastColor;}

    void markPoint() {
        if (x == 5) {
            switch (y) {
                case 0 : 
                    removePointCustomWay(0, 2);
                break;
                case 18 :
                    removePointCustomWay(0, -2);              
                break;
                default :
                    removePoint();
                break;	
            }
        } else {
            removePoint();
        }
        if (playerScore == 6 || computerScore == 6) showWinner();
    }

    void removePoint() {
        if (availablePush.size() == 2) leaveOnePossibleWayToPush(x, y);
        int depX = counter.x - x, depY = counter.y - y;
        for (Counter counter : enemyCounters) {
            counter.x -= depX;
            counter.y -= depY;
        }
        int n = 3;
        for (Counter counter : playerTurnCounters) {
            counter.x -= depX;
            counter.y -= depY;
            if (n == 0) break;
        }
        playerTurn = (playerTurn == 'p') ? 'c' : 'p';
        if (counter.player == 'c') { playerScore++; popFromList(computerCounter, counter); }
        else { computerScore++; popFromList(playerCounter, counter); }
        popFromPointList(availablePoints, x, y);
        removeAll();
    }

    void removePointCustomWay(int depX, int depY) {
        leaveOnePossibleWayToPushCustom(depX, depY, counter);
        for (Counter counter : enemyCounters) {
            counter.x -= depX;
            counter.y -= depY;
        }
        int n = 3;
        for (Counter counter : playerTurnCounters) {
            n--;
            counter.x -= depX;
            counter.y -= depY;
            if (n == 0) break;
        }
        playerTurn = (playerTurn == 'p') ? 'c' : 'p';
        removeAll();
        if (counter.player == 'c') { playerScore++; popFromList(computerCounter, counter); }
        else { computerScore++; popFromList(playerCounter, counter); }
        popFromPointList(availablePoints, x, y);
    }

    void removeoPointFromMapCoordinates() {
        MapCoordinates mp = findWay(x, y);
        while (mp != null) {
            popMapCoordinates(availablePush, mp);
            mp = findWay(x, y);
        }
    }

    boolean equals(Point p) { return (p.x == this.x && p.y == y); }
    boolean equals(int x, int y) { return (x == this.x && y == this.y); }
}

Point getPoint(int i, int j) {
    for (Point p : availablePoints) {
        if (p.x == i && p.y == j) return p;
    }
    return null;
}

boolean searchPoint(int i, int j) {
    for (Point p : availablePoints) {
        if (p.x == i && p.y == j) return true;
    }
    return false;
}

void popFromPointList(ArrayList<Point> list, int x, int y) {
    int i = 0; boolean found = false;
    while (i < list.size()) {
        if (list.get(i).equals(x, y)) {
            found = true;
            break;
        }
        i++;
    }
    if (found) list.remove(i);
}