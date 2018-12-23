void computreTurn() {
    initialState = new State(playerCounter, computerCounter);
    // Generating AlphaBeta to execute negaMax
    createGameTree(initialState, 2); //Create Tree  (ex: 2 means tree level 3)
    // checkTree(initialState);  // testing if computer can perform pushes or points
    initialState = negaMax(initialState, false, Double.NEGATIVE_INFINITY, Double.POSITIVE_INFINITY).state;
    computerCounter = copyList(initialState.computerCounters); playerCounter = copyList(initialState.playerCounters);
    println("******************************");
    playerTurn = 'p';
}

// to check if computer is doing points
void checkTree(State state) {
    if (state.playerCounters.size() < 14) println("-------------ok---------------");
    if (state.computerCounters.size() < 14) println("-------------ok---------------");
    if (state.childStates.size() > 0) 
        for (State s : state.childStates) 
            checkTree(s);
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

boolean checkWayState(int i, int j, State state, Counter counter) {
  try {
    Counter possibleCounter = searchCounterState(i, j, state);
    if (possibleCounter != null) {
      if (possibleCounter.player != counter.player) checkPushState(i, j, state, counter);
      return false;
    } else return ( (map[i][j] != 99) && (map[i][j] != 0) );
  } catch (Exception e) {
    if (i == 5 && j == -1) return false;
    else println(e);
    return false;
  }
}
// (i, j) is the counter to be pushed/removed
// State is the current state before applying changes
// Counter is the counter that can('t) push/remove targeted counter
void checkPushState(int i, int j, State state, Counter counter) {
    int depX = counter.x - i, depY = counter.y - j;
    Counter selectedCounter; // selectedCounter will be used to count enemyCounters and teammateCounters
    int teammatesNumber = 1, enemiesNumber = 1;
    // First we need to make sure we have at least 2 teammates 
    selectedCounter = searchCounterState(counter.x + depX, counter.y + depY, state);
    if (selectedCounter != null && selectedCounter.player == counter.player) {
        teammatesNumber++;
        selectedCounter = searchCounterState(selectedCounter.x + depX, selectedCounter.y + depY, state);
        if (selectedCounter != null && selectedCounter.player == counter.player) teammatesNumber++;
        // The second thing we need to do is check if we can push right now
        // since we have 2 or 3 counters that can push in (depX, depY) direction
        selectedCounter = searchCounterState(i - depX, j - depY, state);
        if (selectedCounter != null && selectedCounter.player != counter.player) {
            enemiesNumber++;
            selectedCounter = searchCounterState(selectedCounter.x - depX, selectedCounter.y - depY, state);
            if (selectedCounter != null) enemiesNumber++; // it doesn't matter if it's enemyCounter 
            // or not because we can't push 3 Counters in any case
        }
        //if (teammatesNumber > enemiesNumber) 
        //    state.childStates.add(new State(state, i, j, depX, depY, counter, enemiesNumber, teammatesNumber));
    }
}