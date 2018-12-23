void clickMenu() {
    if (mouseX >= 155 && mouseX <= 775) {
        if (mouseY >= 60 && mouseY <= 160) newGamePlayerVsPlayer();
        if (mouseY >= 210 && mouseY <= 310) newGamePlayerVsComputer();
        if (returnToGame && mouseY >= 510 && mouseY <= 610) resumeGame();
    }
}

void newGamePlayerVsPlayer() { initGame(); gameMode = "PvsP"; }
void newGamePlayerVsComputer() { initGame(); gameMode = "PvsC"; }
void resumeGame() { menu = false; }
void showWinner() { menu = true; returnToGame = false; }