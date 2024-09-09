# Godot 3D Base Project

This is a base project for Godot 4.3 with simple 3D FPS controller which you can use as a starting project for your game jams. Of course, feel free to use it as a starting project for your feature complete game as well.
This project should be complying with the Ludum Dare *Compo* rules, which state: "You’re free to start with **any** base-code you may have." This is a project that can help you to start very rapidly, but only contains the necessary busywork so that you can focus and start working on the actual game very quickly.

## How to start

Clone this repository into your working folder and open `project.godot` in some text editor. Once open, edit this line:

```
config/name="Godot 4 3D Sample Project"
```

And change it to the name of your project.

Once you do that, just import the project into Godot 4.3. Eventually, you can import this project right away and rename it in the `Project` -> `Project settings` -> `Application` -> `Config`.

## Scene order

Project starts with a Splash scene (`ui/SplashScene.tscn`), which displays two logos — one of them is usually used as your logo, second is usually used as a logo of the game jam you are participating in or as a logo of your game. 

Once both logos are displayed, the Splash scene automatically loads the Main menu scene (`MainMenuScene.tscn`). You can start a new game, which starts the `GameSceneOne.tscn` scene. Main menu also offers the player a possibility to switch between On/Off modes for sounds and music, display Credits (which focuses the camera to the `CreditsSection`) or quit the game. *Quit game* button contains an extra check that disables it in case your game is running in HTML5, because quitting a HTML5 game would just unload it from the embed.

## Player controller

Project contains a very basic FPS controller. The player can:

* look around with the mouse
* move with `WASD`
* jump with `Space`
* sprint with `Shift`
* pause with `Escape`

Key bindings contain some settings for gamepads as well, but this would have to be tested, so do not count on those being 100 % correct (at least yet). 

Player scene also contains a RayCast which can output the current object that the player is looking at into the console. If you want to see it, just change the `debug` variable to `true` and you will get a stream of messages indicating what the player is currently looking at.

Player scene contains three additional screens, which are important to know about:

* `GamePauseScene` — if the player presses `Escape`, the Pause scene is displayed. Player can either continue, turn the music/sounds off (or on) or go back to the main menu.
* `GameWonScene` — if the player wins, use the `toggle_game_won()` function, which displays this scene. Once displayed, the player is unable to move.
* `GameOverScene` — if the player loses, use the `toggle_game_over()` function which displays this scene. Just like with previous one, once it's displayed, the player is unable to move.
* `TypewriterDialog` — used to display dialogs with `typewriter_dialog.start_dialog([dialog_array], delta)` (described below)

### Floating player controller

FPS controller might not be suitable for all projects. This is the reason this project also contains `FloatingPlayerScene.tscn`, which is very similar to the `PlayerScene.tscn`, but with a slight difference in the physics and behavior. Physics here simulate moving freely with little (or no) gravity. This can be used for games where the player is swimming underwater the whole time, but it is also applicable as submarine controller or even spaceship controller.

The differentiating factor here is the `is_pulled_down` variable: 
	
	* If `true`, a small gravity is always applied to the player, always pulling them down slightly a bit (unless the player is on the floor) — useful for players swimming underwater as this makes it feel more engaging. 
	* If `false`, there is no gravity pull at all, meaning that the player stays in the same spot. Can be used for submarines and space stations as this basically offers a player a free no-gravity movement.

Player can move upwards by holding `Space` and go downwards by holding `Ctrl`. Otherwise, `Y` vector is lerped to 0 to simulate the water resistance and to prevent the player from moving on Y axis endlessly.

## Global scene

There are two global scenes in the project. First is the `GlobalScene.tscn`. This scene is autoloaded as a general global scene right at the beginning, and contains `SfxPlayer`, which is set to play sounds and `MusicPlayer`, which is set to play music.

Sounds can be played by `play_sound(sfx_name)` and stopped by `stop_sound(sfx_name)`. 

Music can be played by `play_music()` and stopped by `stop_music()`. 


## Transition overlay

Second global scene is `TransitionOverlay.tscn`. This scene takes care of "fade in" and "fade out" effects. Use this for smooth transitions between screens. You can simply call:

```
transition_overlay.fade_in()
```

or

```
transition_overlay.fade_out()
```

from any code anywhere in order for the fade in or fade out effect to appear. If you want to do something in your code right after the fade in/out is complete, wait for the `transition_overlay.transition_completed` varible to turn `true`. It will turn `true` once the effect is played fully.

## Typewriter dialog

PlayerScene contains a `TypewriterDialogNode`, which is assigned through the `typewriter_dialog` variable. In order to trigger a dialog, use this function anywhere in the Player code: 

```
typewriter_dialog.start_dialog(["First message.", "Second message."], delta)
```

The first parameter is an array of strings — those are separate dialogs that you want to display right after each other. This array can contain as many strings as you want. The other parameter of the function is `delta`, which should be self-explanatory and takes care of the dialog countdown (the time before another line is displayed automatically). If you do not have a delta available in your function, you can use `get_process_delta_time()`.

## Tooltip

Another node which you might find helpful is `PlayerTooltip` node, which lets you display a tooltip and set the action to dismiss it.

You can set a new tooltip with `player_tooltip.display_tooltip("Text to display", true/false)` where `true` or `false` set the tooltip flashing on or off.

You can set the action with `player_tooltip.set_tooltip_action("action_to_be_performed")` where the action is the input name from the input map. 

TL;DR: if you want to create a flashing tooltip that says "Press Space to continue" which is dismissed by jumping, you can do it like this:

```
player_tooltip.display_tooltip("Press Space to continue", true)
player_tooltip.set_tooltip_action("move_jump")
```

You can also dismiss the tooltip with `player_tooltip.dismiss_tooltip()` any time.

## Scripts

Scripts are separated from scenes in the `scripts` folder. Apart from `buttons` folder, they generally follow the same structure as their scene counterparts, so, there is not much to describe here.

## Assets

This project contains `assets` folder with the following structure:

* **external** — this folder contains placeholders for covers and banners for *itch.io* & *Ludum Dare*.
* **fonts** — this folder contains a font package from Kenney, which are licenced as CC0.
* **music** — this folder contains a placeholder for your game music
* **sfx** — this folder contains a placeholder for your game sounds
* **sprites** — this is a folder for your sprites
  * **dialogue** — this folder contains placeholder for dialog text background
  * **menu_buttons** — this folder contains placeholders for all menu buttons
  * **splash_logos** — this folder placeholders for `logo-jam.png` and `logo-main.png` which are displayed in the `SplashScene.tscn` when the game is launched.
  * **transition** — this folder contains black 1 x 1 px sprite used by the `TransitionOverlay.tscn`. Transition overlay simply scales the sprite to fit the window resolution

## Export to HTML5

If you use this project for a game jam, you are most likely insterested in exporting the project to HTML5. This is extremely easy. Just follow these steps:

  1. Select `Project` -> `Export...`.
  1. If you don't have up-to-date `Web (Runnable)` preset, download it.
  1. Click on `Export Project...` at the bottom of the Export dialog.
  1. Select (or create) `export` folder and give your project `index.html` name — important for itch.io! This folder is also included in `.gitignore`, which means that its contents will not show as changes in git.
  1. Open the `export` folder and put all files in it into a new *.zip* file.
  1. Upload *your_project.zip* to itch.io and set it as file that is played in the browser and set the proper embed resolution. Your project should work right away.
