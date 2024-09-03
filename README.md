# Godot 3D Base Project

This is a base project for Godot 4.3 with simple 3D FPS controller which you can use as a starting project for your game jams. Of course, feel free to use it as a starting project for your feature complete game as well.
This project should be complying with the Ludum Dare *Compo* rules, which state: "You’re free to start with **any** base-code you may have." This is a project that can help you to start very rapidly, but only contains the necessary busywork so that you can focus and start working on the actual game very quickly.

## How to start

Clone this repository into your working folder and open `project.godot` in some text editor. Once open, edit these lines:

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

* `GamePauseScene` — if the player presses `Escape`, the Pause screne is displayed. Player can either continue, turn the music/sounds off (or on) or go back to the main menu 
* `GameWonScene` — if the player wins, use the `toggle_game_won()` function, which displays this scene. Once displayed, the player is unable to move.
* `GameOverScene` — if the player loses, use the `toggle_game_over()` function which displays this scene. Just like with previous one, once it's displayed, the player is unable to move.
* `TypewriterDialog` — used to display dialogs with `typewriter_dialog.start_dialog([dialog_array], delta)` (described below)

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

## Scripts

Scripts are separated in their separate `scripts` folder. Apart from `buttons` folder, they generally follow the same structure as their scene counterparts, so there is not much to describe here.

## Assets

This project contains `assets` folder with the following structure:

* **external** — this folder contains placeholders for covers and banners for *itch.io* & *Ludum Dare*.
* **fonts** — this folder contains a font package from Kenney, which are licenced as CC0.
* **music** — this folder contains a placeholder for your game music
* **sfx** — this folder contains a placeholder for your game sounds
* **sprites** — this is a folder for your visual assets
  * **game_env** — this folder contains placeholders for the skybox and cubemap
  * **ui** — this folder contains placeholders for UI elements
	* **dialogue** — this folder contains placeholder for dialog text background
	* **menu_buttons** — this folder contains placeholders for all menu buttons
	* **splash_logos** — this folder placeholders for `logo-jam.png` and `logo-main.png` which are displayed in the `SplashScene.tscn` when the game is launched.
	* **transition** — this folder contains black 1 x 1 px sprite used by the `TransitionOverlay.tscn`. Transition overlay simply scales the sprite to fit the window resolution
