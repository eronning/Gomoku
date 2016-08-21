In order to play against the AI you need to enter your moves as coordinates, which start as 0, 0 at the top left corner. Each move will be entered as x space y. The AI will then make its own move or a HumanPlayer will.

For the main game it asks a player for a move and then applies it to the state. Then it asks the other player for a move as well and applies that to the state. In the case of an AI player the program looks two levels deep (two to three moves ahead) and decides on the best possible move in order to win the game. It estimates the value of each of the deepest moves and then chooses the best of those moves. After that it checks the best of the moves it can then determine its next move in the game. This game will go while constantly checking to see if all moves are valid (which if it isn't then you just enter another move) and that the game is not over (no five pieces are in a row, column diagonal). Eventually the game will come to an end and there will either be a winner in which case the program says which player won. Otherwise when the game comes to an end then the program will say that the game was a tie.

Bugs: None that we know of -- values for the AI's moves aren't entirely optimized plus it is run at depth 2 so it doesn't take forever

Collaboration : Erik Ronning, Aravind Elangovan

Extra Features: none