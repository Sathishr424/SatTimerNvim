# SatTimer.nvim ⏱️

A lightweight countdown timer and stopwatch plugin for Neovim.

SatTimer.nvim lets you run multiple timers and stopwatches simultaneously in floating windows, allowing you to keep track of time without leaving your editor.

---

## Features

* ⏳ Countdown timers
* ⏱️ Stopwatches
* 🪟 Floating windows
* 📌 Multiple timers and stopwatches at the same time
* 🏷️ Custom timer names
* 🔔 Notification when a timer finishes
* ⚡ Lightweight and dependency-free

---

## Installation

### lazy.nvim

```lua
{
    "Sathishr424/SatTimer.nvim",
}
```

### packer.nvim

```lua
use "Sathishr424/SatTimer.nvim"
```

---

## Usage

### Countdown Timer

Start a countdown timer:

```vim
:Timer 25m
```

Create a named timer:

```vim
:Timer 25m Study
```

Run multiple timers:

```vim
:Timer 25m Study
:Timer 5m Break
:Timer 45m Workout
```

Stop a timer:

```vim
:StopTimer Study
```

---

### Stopwatch

Start a stopwatch:

```vim
:Stopwatch
```

Start a named stopwatch:

```vim
:Stopwatch Coding
```

Stop it:

```vim
:StopStopwatch Coding
```

---

## Duration Format

SatTimer.nvim supports the following units:

| Unit | Meaning |
| ---- | ------- |
| `h`  | Hours   |
| `m`  | Minutes |
| `s`  | Seconds |

Examples:

```text
20s
5m
30m20s
1h
1h20m
1h20m15s
200s
```

---

## Naming

Timers and stopwatches may optionally have names.

Unnamed timers are automatically assigned names:

```text
Timer 1
Timer 2
Timer 3
```

Unnamed stopwatches become:

```text
Stopwatch 1
Stopwatch 2
```

Custom names can be used instead:

```vim
:Timer 25m Study
:Timer 10m Break
:Stopwatch Coding
```

---

## Commands

| Command                    | Description             |
| -------------------------- | ----------------------- |
| `:Timer {duration} [name]` | Start a countdown timer |
| `:StopTimer {name}`        | Stop a timer            |
| `:Stopwatch [name]`        | Start a stopwatch       |
| `:StopStopwatch {name}`    | Stop a stopwatch        |

---

## Screenshots

<!-- Add screenshots or GIFs here -->

### Multiple Timers

```
┌─────────────────┐
│ Study           │
│ ⏳ 18:42        │
└─────────────────┘

┌─────────────────┐
│ Break           │
│ ⏳ 04:58        │
└─────────────────┘

┌─────────────────┐
│ Coding          │
│ ⏱ 00:13:21      │
└─────────────────┘
```

---

## Help

After installation, view the built-in documentation with:

```vim
:help sattimer
```

---

## Roadmap

Planned features include:

* Pause and resume timers
* Timer list command
* Configurable window position
* Configurable border styles
* Custom notification styles
* Progress indicator

---

## Contributing

Issues and pull requests are welcome.

If you find a bug or have a feature request, feel free to open an issue.

---

## License

MIT License.

