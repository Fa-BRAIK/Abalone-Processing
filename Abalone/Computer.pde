void computreTurn() {
    boolean priorityPushOrPoint = false; // will be used to determine if we have a priority push or point
    // check for possible pushes or points first 
    ArrayList<Point> possiblePoints = new ArrayList<Point>();
    ArrayList<MapCoordinates> possiblePushes = new ArrayList<MapCoordinates>();
    // checking for possible pushes and points 
    checkForPushesAndPointsComputer(possiblePushes, possiblePoints);
    // println("possible pushes/points", possiblePushes.size(), possiblePoints.size());
    if (possiblePoints.size() > 0) {
        priorityPushOrPoint = true;
        executePoint(possiblePoints.get(0));
    }

    if (!priorityPushOrPoint) {
        initialState = new State(playerCounter, computerCounter);
        // Generating AlphaBeta to execute negaMax
        createGameTree(initialState, 2); //Create Tree  (ex: 2 means tree level 3)
        initialState = negaMax(initialState, false, Double.NEGATIVE_INFINITY, Double.POSITIVE_INFINITY).state;
        computerCounter = copyList(initialState.computerCounters);
    }
    playerTurn = 'p';
}

void checkForPushesAndPointsComputer(ArrayList<MapCoordinates> possiblePushes, ArrayList<Point> possiblePoints) {
    Counter targetedCounter;
    for (Counter counter : computerCounter) {
        targetedCounter = searchCounter(counter.x + 1, counter.y - 1);
        if (targetedCounter != null && targetedCounter.player != 'c') 
            tryToAssignPushOrPointForComputer(targetedCounter, counter, possiblePushes, possiblePoints);
        targetedCounter = searchCounter(counter.x - 1, counter.y + 1);
        if (targetedCounter != null && targetedCounter.player != 'c') 
            tryToAssignPushOrPointForComputer(targetedCounter, counter, possiblePushes, possiblePoints);
        targetedCounter = searchCounter(counter.x + 1, counter.y + 1);
        if (targetedCounter != null && targetedCounter.player != 'c') 
            tryToAssignPushOrPointForComputer(targetedCounter, counter, possiblePushes, possiblePoints);
        targetedCounter = searchCounter(counter.x - 1, counter.y - 1);
        if (targetedCounter != null && targetedCounter.player != 'c') 
            tryToAssignPushOrPointForComputer(targetedCounter, counter, possiblePushes, possiblePoints);
        targetedCounter = searchCounter(counter.x, counter.y + 2);
        if (targetedCounter != null && targetedCounter.player != 'c') 
            tryToAssignPushOrPointForComputer(targetedCounter, counter, possiblePushes, possiblePoints);
        targetedCounter = searchCounter(counter.x, counter.y - 2);
        if (targetedCounter != null && targetedCounter.player != 'c') 
            tryToAssignPushOrPointForComputer(targetedCounter, counter, possiblePushes, possiblePoints);
    }
}

void addAllPossibleWaysToTree(State state, Counter counter) {
    if (checkWayState(counter.x + 1, counter.y + 1, state, counter)) state.childStates.add(new State(state, counter.x, counter.y, 1, 1));
    if (checkWayState(counter.x + 1, counter.y - 1, state, counter)) state.childStates.add(new State(state, counter.x, counter.y, 1, -1));
    if (checkWayState(counter.x - 1, counter.y + 1, state, counter)) state.childStates.add(new State(state, counter.x, counter.y, -1, 1));
    if (checkWayState(counter.x - 1, counter.y - 1, state, counter)) state.childStates.add(new State(state, counter.x, counter.y, -1, -1));
    if (checkWayState(counter.x, counter.y + 2, state, counter)) state.childStates.add(new State(state, counter.x, counter.y, 0, 2));
    if (checkWayState(counter.x, counter.y - 2, state, counter)) state.childStates.add(new State(state, counter.x, counter.y, 0, -2));
}

// treeLevel variable will be used to determine how 
//  deep we're going. we'll stop when treeLevel = 0;
void createGameTree(State state, int treeLevel) { // the tree is correctly generated without having pushes and points
    if (state.playerTurn != 'c')
        for (Counter counter : state.computerCounters) 
            addAllPossibleWaysToTree(state, counter);
    else
        for (Counter counter : state.playerCounters) 
            addAllPossibleWaysToTree(state, counter);
    if (treeLevel != 0) for (State childState : state.childStates) createGameTree(childState, treeLevel - 1); 
}

class Values { Double val; State state; Values(Double val, State state) { this.val = val; this.state = state; } }

// to be tested soon enough
public Values negaMax(State state, boolean isMaximizingPlayer, Double alpha, Double beta) {
    if (state.childStates.size() == 0) return new Values(new Double(mpEvaluation(state)), state);
    if (isMaximizingPlayer) {
        Values bestVal = new Values(Double.NEGATIVE_INFINITY, state);
        for (State childState : state.childStates) {
            Values value = negaMax(childState, false, alpha, beta);
            // check if childState has no childStates to apply possiblePushesVal
            //if (childState.childStates.size() == 0) value.val += mpEvaluationInsideParent(state, childState);
            if (state.changedCounter == null && bestVal.val < value.val) bestVal.state = value.state;
            bestVal.val = Double.max(bestVal.val, value.val);
            alpha = Double.max(alpha, bestVal.val);
            if (beta <= alpha) break;
        }
        return bestVal;
    } else {
        Values bestVal = new Values(Double.POSITIVE_INFINITY, state);
        for (State childState : state.childStates) {
            Values value = negaMax(childState, true, alpha, beta);
            // check if childState has no childStates to apply possiblePushesVal
            //if (childState.childStates.size() == 0) value.val += mpEvaluationInsideParent(state, childState);
            if (state.changedCounter == null && bestVal.val > value.val) bestVal.state = value.state;
            bestVal.val = Double.min(bestVal.val, value.val);
            beta = Double.max(beta, bestVal.val);
            if (beta <= alpha) break;
        }
        return bestVal;
    }
}

// check if we have a counter or not
boolean checkWayState(int i, int j, State state, Counter counter) {
  try {
    if ((searchCounterState(i, j, state) == null) && (map[i][j] != 99) && (map[i][j] != 0)) return true;
    else return false;
  } catch (Exception e) { return false; }
}

// if this method is called it means we have a possible push or point so 
// we need to distinguish if it's a fair push/point first 
// then we'll add it to the array if that's true 
void tryToAssignPushOrPointForComputer(Counter targetedCounter, Counter counter, ArrayList<MapCoordinates> possiblePushes, ArrayList<Point> possiblePoints) {
    int depX = counter.x - targetedCounter.x, depY = counter.y - targetedCounter.y, mapX, mapY;
    // mapX and mapY will be used to determine if the possible push is a point or just a simple push
    Counter selectedCounter; // selected counter will be used to check teammates and enemies number of counter
    int teammatesNumber = 1, enemiesNumber = 1;
    // first we need to make sure that we have at least 2 teammates
    selectedCounter = searchCounter(counter.x + depX, counter.y + depY);
    if (selectedCounter != null && selectedCounter.player == counter.player) {
        teammatesNumber++;
        selectedCounter = searchCounter(selectedCounter.x + depX, selectedCounter.y + depY);
        if (selectedCounter != null && selectedCounter.player == counter.player) teammatesNumber++;
        // after checking about teammates number 
        // we need to see if we can push with 2/3 counters in (depX, depY) direction
        mapX = targetedCounter.x - depX; mapY = targetedCounter.y - depY;
        selectedCounter = searchCounter(targetedCounter.x - depX, targetedCounter.y - depY);
        if (selectedCounter != null && selectedCounter.player == targetedCounter.player) {
            enemiesNumber++;
            mapX = selectedCounter.x - depX; mapY = selectedCounter.y - depY;
            selectedCounter = searchCounter(selectedCounter.x - depX, selectedCounter.y - depY);
            if (selectedCounter != null) enemiesNumber++; // it doesn't matter if it's an 
            // enemie counter or not we can't push anyways
        } else if (selectedCounter != null) enemiesNumber += 3;
        if (teammatesNumber > enemiesNumber) // it means we have a possible push or point 
            if (mapX == 5 && mapY == -1) //it means we have a special case of point so we'll create one
                possiblePoints.add(new Point(5, 0, searchCounter(5, 1), true)); // point created
            else if (mapX == 5 && mapY == 19)   // another special case of point we'll need to add it
                possiblePoints.add(new Point(5, 18, searchCounter(5, 17), true));
            else if (map[mapX][mapY] == 99) // classic possible point
                possiblePoints.add(new Point(mapX, mapY, searchCounter(mapX + depX, mapY + depY), true)); 
            else possiblePushes.add(new MapCoordinates(mapX, mapY, searchCounter(mapX + depX, mapY + depY), true)); 
            // else we'll have a push
    }
}