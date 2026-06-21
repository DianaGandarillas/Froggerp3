# Froggerp3 — Godot 4.6

Pure Godot 4.6 project in GDScript. No external tooling, no tests, no CI, no lint/format config.

## Repository conventions

- **Language**: All code, comments, and strings are in **Spanish** (variable names, HUD labels, debug prints). Write new code in Spanish to match.
- **Indentation**: Tabs (GDScript default).
- **No `class_name` declarations** — scripts are attached to scenes, not registered as global classes.

## Project structure

| What | File | Notes |
|---|---|---|
| Project config | `project.godot` | Name `FroggerJuego`, main scene `MapaPrincipal.tscn`, window 1200x700 |
| Autoload singleton | `scripts/global.gd` | Accessed as `Global`. Fields: `nivel_actual`, `puntaje`, `vidas`, `record`, `tiempo_restante` |
| Game controller | `scenes/mapa_principal.gd` | Attached to `MapaPrincipal.tscn`. Handles HUD, pause, death, level progression |
| Player | `scripts/player.gd` | `CharacterBody2D`, 50px grid movement, WASD control |
| Cars | `scripts/car.gd` | Horizontal wrap. Also reused by `Log.tscn` (same script, different group). |
| Car lanes | `scripts/car_lane.gd` | Dynamic spawner, difficulty scaling. |
| Platforms | `scripts/plataforma.gd` | Logs & turtles shared movement script. |
| Turtles | `scripts/tortugas.gd` | Sinking/emerging mechanic (attached to `Tortugas2/3.tscn`). |
| Goals | `scenes/obstacles/meta.gd` | Marks occupied, switches group `meta`→`peligro`. |
| Test harness | `scenes/TestWorld.tscn` | Minimal debug scene (not the main scene). |

## How to run

```bash
godot --editor .        # Open in editor
godot .                 # Run game directly
```

## Input

| Action | Key |
|---|---|
| Up / Down / Left / Right | W / S / A / D |
| Pause | Escape |

## Groups

Used instead of type checks for collision logic:

| Group | Purpose |
|---|---|
| `peligro` | Cars, water, occupied goals — kills frog on contact |
| `plataforma` | Logs and turtles — rideable, carries frog |
| `agua` | Water body — kills frog if not on platform |
| `meta` | Unoccupied goal zones |

## Physics layers

- **Layer 1** `jugador` — Player
- **Layer 2** `peligro` — Hazards

## Difficulty scaling

Car lane speeds multiply per level: `0.85 + (nivel_actual - 1) * 0.175` (in `car_lane.gd`).  
N1=0.85×, N2=1.025×, N3=1.20×, N4=1.375×...  
Nivel 1 additionally has 1 fewer car per lane and 30% more spacing between cars.  
**Log platform speeds are NOT scaled** — they use `plataforma.gd` which has no level multiplier.

## Timer

Each level has a countdown timer shown in the HUD.  
Formula: `max(30, 60 - (nivel_actual - 1) * 5)` → N1=60s, N2=55s, ... N7+=30s.  
On timeout → frog dies. On death → timer resets.  
On level completion → remaining time × 10 added as bonus points.  
Timer pauses when the game is paused (Escape).

## Lives

5 lives total at game start. **Lives do NOT reset on level up** (changed from original behavior).  
Game over when lives reach 0.

## Gotchas

- **Known dead signal**: `Player.tscn` connects `_on_hit_box_area_exited` but no matching function exists in `player.gd`. The death logic relies solely on `_on_area_entered` via `hit_box.area_entered`.
- **Scene root naming**: Some scene files have root node names that differ from the scene filename (e.g., `Log.tscn` root is `"TroncoLargo"`). Do not rely on `scene.name` matching the filename.
- **Level transition**: Uses `call_deferred("_cambiar_nivel")` after playing a sound. The method calls `get_tree().reload_current_scene()`. Global state carries over through the `Global` autoload.
- **Player death lock**: On death, `reiniciar_posicion()` blocks input via `esta_saltando = true` + `esta_muerto = true`, then unblocks after a 0.1s `create_timer`.
- **Test scene**: `TestWorld.tscn` exists for debugging. It is not the run/main scene.

## Assets

- Sprites: PNG under `assets/sprites/`
- Audio: WAV under `assets/sounds/`
- Every asset has an accompanying `.import` metadata file.
- Engine cache at `.godot/` is gitignored.

## Limited tooling

There are no test files, linting config, formatting config, or CI workflows. To add any, you would need to install external tools (e.g., `gdtoolkit` for gdlint/gdformat). Do not look for `package.json`, `Cargo.toml`, or other build manifests — they do not exist.
