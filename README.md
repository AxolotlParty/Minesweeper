# Minesweeper
A classic Minesweeper game built in the [Godot Engine](https://godotengine.org/) v4.3 using an MVC style architecture.
This is my first game built in Godot, created as a learning project to explore the basics of the engine.

![image](https://github.com/user-attachments/assets/ae93b005-83dd-4ca3-87e5-33e3226e9c48)

## Features
Clear spaces by left clicking.
Flag and mark cells as Unsure by right clicking.
Speed-clear by middle-clicking on already revealed cells.
A timer to score your run.
A restart feature by clicking the smiley face.
Basic sound effects.

## Project Architecture
#### Minesweeper.gd:
This is the controller, it sets up the components of the game and coordinates their communications.
It listens for game actions and passes them to the game state.
It listens for game state updates and passes them to renderer.

#### MineField.gd:
This is the view, it handles setting up cells and their rendered state.
It listens for clicks on each cell and packages them up for the controller.

#### Cell.gd:
Handles the UI of a single cell.
It handles the different click states and rendering the correct icons.

#### GameState.gd:
This is the model of the game.
It handles the high level game parts, for example starting/stopping the game time, restarting a game, game over and game won.
It handles game actions and passes them to the subcomponents that need to handle the action.

#### GameBoard.gd:
This is a model of a specific game board.
It reacts to game actions and updates it's self to represent the new state after an action had happened.

## Known issues
Middle button plays a click sound everytime. The sounds should probably be handled by listening for a specific game event and acting there.
Smiley face states are not implemented, eg Surprised, Dead and Cool Sunnies.

## Outcomes
Success, I made a reasonable Minesweeper clone.
The MVC style architecture works well for this simple style of game.

## Future
None, I feel I have learnt enough with this game to start on another game.

## Development Notes
Godot 4.3
GDScript
