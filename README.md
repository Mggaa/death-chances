# Doom Chances

A gameplay mod for GZDoom that adds a limited lives system and automatic saves.

## Features

* **Limited lives system** – You start with **3 chances** by default.
* The maximum number of chances can be changed with the CVAR:

```
dc_max_lifes
```

* **Automatic save every 20 seconds** by default.
* The autosave interval can be changed with:

```
secs_to_save
```

* If you **lose all chances**, the game will:

  * Reset the current level
  * Overwrite the autosave file
  * This means the automatic save is permanently lost.

## Important Behavior

Chances are **global to the play session**, not tied to individual save files.

This means:

* Loading another save **will not restore your chances**.
* The current amount of chances will remain the same across saves.

Chances only reset when:

* You get **Game Over** (lose all lives), or
* You **restart the game**.

## Requirements

* GZDoom **4.7 or newer**

## Configuration

You can change settings through the console:

```
dc_max_lifes = number of lives
secs_to_save = autosave interval in seconds
```

Example:

```
dc_max_lifes 5
secs_to_save 60
```
