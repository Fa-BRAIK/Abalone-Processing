class State {
    char playerTurn;
    ArrayList<Counter> playerCounters, computerCounters;
    ArrayList<State> childStates = new ArrayList<State>();
    ArrayList<MapCoordinates> possiblePushes = new ArrayList<MapCoordinates>();
    ArrayList<Point> possiblePoints = new ArrayList<Point>();
    Counter changedCounter = null;
    int depX, depY;
    // Initial State
    State(ArrayList<Counter> playerCounters, ArrayList<Counter> computerCounters) {
        playerTurn = 'p';
        this.playerCounters = copyList(playerCounters);
        this.computerCounters = copyList(computerCounters);
    }

    // Creating State and taking a next move
    State(State previousState, int x, int y, int depX, int depY) {
        // we take a previous state and then we change 
        // player turn and make a move
        playerTurn = (previousState.playerTurn == 'c') ? 'p' : 'c';
        playerCounters = copyList(previousState.playerCounters);
        computerCounters = copyList(previousState.computerCounters);
        // computerCounters and playerCounters are from state
        Counter counter = (playerTurn == 'c') ? searchCounter(x, y, computerCounters) : searchCounter(x, y, playerCounters);
        // Adding the posibility to move multiple counters
        ArrayList<Counter> countersToBeMoved = new ArrayList<Counter>();
        countersToBeMoved.add(counter);
        changedCounter = counter;
        counter = searchCounterState(x - depX, y - depY, this);
        if (counter != null && counter.player == playerTurn) {
            countersToBeMoved.add(counter);
            counter = searchCounterState(counter.x - depX, counter.y - depY, this);
            if (counter != null && counter.player == playerTurn) {
                countersToBeMoved.add(counter);
            }
        }
        while (countersToBeMoved.size() != 0) {
            countersToBeMoved.get(0).x += depX;
            countersToBeMoved.get(0).y += depY;
            countersToBeMoved.remove(0);
        }
        this.depX = depX; this.depY = depY;
    }
}

int mpEvaluation(State state) {
    return (f1(state) + f2(state));
}

/* ******************************************************** */
/* IMPORTANT NOTICE                                         */
/* f1 & f2 CAN BE OPTIMIZED BY MERGIND THEM WITH EACH OTHER */
/* ******************************************************** */

int f1(State state) {
    int totalDistancesPlayer = 0, totalDistancesComputer = 0;
    for (Counter counter : state.computerCounters)
        totalDistancesComputer += (abs(counter.x - 5) + abs(counter.y - 9));
    for (Counter counter : state.playerCounters)
        totalDistancesPlayer += (abs(counter.x - 5) + abs(counter.y - 9));
    return (totalDistancesComputer - totalDistancesPlayer);
}

int f2(State state) {
    int totalComputerNeighboringPoints = 0, totalPlayerNeighboringPoints = 0;
    for (Counter counter : state.computerCounters) 
        totalComputerNeighboringPoints += searchForNighboringTeamMates(counter, state.computerCounters);
    for (Counter counter : state.playerCounters)
        totalPlayerNeighboringPoints += searchForNighboringTeamMates(counter, state.playerCounters);
    return (totalPlayerNeighboringPoints - totalComputerNeighboringPoints);
}

// this function is reserved for computer
void executePoint(Point point) {
    int depX, depY;
    ArrayList<Counter> targetedCounters = new ArrayList<Counter>();
    if (point.x == 5 && point.y == -1) { depX = 0; depY = -2; }
    else if (point.x == 5 && point.y == 18) { depX = 0; depY = 2; }
    else { depX = point.x - point.counter.x; depY = point.y - point.counter.y; }
    int i = 2; Counter counter = point.counter;
    // moving enemiesCounter
    while (i > 0 && counter.player == point.counter.player) { 
        targetedCounters.add(counter);
        counter = searchCounter(counter.x - depX, counter.y - depY);
        i--;
    }
    i = 3;
    while (i > 0) { 
        targetedCounters.add(counter); 
        counter = searchCounter(counter.x - depX, counter.y - depY);
        i--; 
    }
    while (targetedCounters.size() != 0) {
        targetedCounters.get(0).x += depX;
        targetedCounters.get(0).y += depY;
        targetedCounters.remove(0);
    }
    point.markPoint();
}