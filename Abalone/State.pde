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

    // Craeting state that contain a possible push or point
    State(State previousState, int x, int y, int depX, int depY, Counter counter, int enemiesNumber, int teammatesNumber) {
        println("possible push", depX, depY);
        /*******************************/
        //    UNTESTED PART OF CODE    //
        /*******************************/
        ArrayList<Counter> countersToBeMoved = new ArrayList<Counter>();
        // we take a previous state and then we change 
        // player turn and make a move
        playerTurn = (previousState.playerTurn == 'c') ? 'p' : 'c';
        playerCounters = copyList(previousState.playerCounters);
        computerCounters = copyList(previousState.computerCounters);
        // computerCounters and playerCounters are from state
        Counter firstCounterToBeMoved = searchCounterState(x, y, this);
        Counter selectedCounter = searchCounterState(x, y, this);
        // Adding the posibility to move multiple counters
        while (enemiesNumber > 0) { 
            countersToBeMoved.add(selectedCounter);
            selectedCounter = searchCounterState(selectedCounter.x - depX, selectedCounter.y - depY, this);
            enemiesNumber--;
        }
        selectedCounter = counter;
        while (teammatesNumber > 0) {
            countersToBeMoved.add(selectedCounter);
            selectedCounter = searchCounterState(selectedCounter.x + depX, selectedCounter.y + depY, this);
            teammatesNumber--;
        }
        print(countersToBeMoved.size(), "counters to be moved : / ");
        for (Counter c : countersToBeMoved) print(c.x, c.y, " / ");
        println("");
        println("original position :", firstCounterToBeMoved.x, firstCounterToBeMoved.y);
        while (countersToBeMoved.size() > 0) {
            countersToBeMoved.get(0).x -= depX;
            countersToBeMoved.get(0).y -= depY;
            countersToBeMoved.remove(0);
        }
        println("after moving everything position :", firstCounterToBeMoved.x, firstCounterToBeMoved.y);
        println("map :", map[firstCounterToBeMoved.x][firstCounterToBeMoved.y]);
        if (map[firstCounterToBeMoved.x][firstCounterToBeMoved.y] == 99) { 
            if (firstCounterToBeMoved.player == 'c') {
                popFromList(computerCounters, firstCounterToBeMoved);
                println("computerCounters new size :", computerCounters.size());
            } else {
                popFromList(playerCounters, firstCounterToBeMoved);
                println("playerCounters new size :", playerCounters.size());
            }
            previousState.possiblePoints.add(new Point(-1, -1, null, previousState));
        } else previousState.possiblePushes.add(new MapCoordinates(-1, -1, null, previousState));
        println("--------------");
    }
}

int mpEvaluation(State state) {
    // return (f1(state) + f2(state) + f3(state));
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

//int f3(State state) { return ((state.computerCounters.size() - state.playerCounters.size()) * 1000); }