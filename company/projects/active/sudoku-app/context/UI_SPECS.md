# Sudoku App - UI Design Specs (Draft)

## Design Philosophy
- **Clean and calm** — The puzzle is the hero
- **Minimal chrome** — No unnecessary UI elements
- **Accessible** — High contrast, readable numbers, touch-friendly
- **Fast** — No animations that slow down gameplay

## Color Palette

### Light Theme (Default)
| Purpose | Color | Hex |
|---------|-------|-----|
| Background | Off-white | `#FAFAFA` |
| Surface (cards/dialogs) | Pure white | `#FFFFFF` |
| Primary (accents) | Calm blue | `#4A90D9` |
| Secondary (highlights) | Soft teal | `#5AC8A8` |
| Grid lines (thin) | Light gray | `#E0E0E0` |
| Grid lines (thick/3x3) | Medium gray | `#9E9E9E` |
| Text (numbers) | Dark gray | `#333333` |
| Text (secondary) | Medium gray | `#757575` |
| Selected cell | Light blue tint | `#E3F2FD` |
| Highlighted row/col/box | Very light blue | `#F5F9FF` |
| Error (invalid number) | Soft red | `#E57373` |
| Fixed/given numbers | Black | `#000000` |
| User-entered numbers | Dark blue | `#1565C0` |

### Dark Theme
| Purpose | Color | Hex |
|---------|-------|-----|
| Background | Dark charcoal | `#121212` |
| Surface | Lighter charcoal | `#1E1E1E` |
| Primary | Light blue | `#6AB7FF` |
| Grid lines (thin) | Dark gray | `#424242` |
| Grid lines (thick) | Medium gray | `#616161` |
| Text (numbers) | Off-white | `#E0E0E0` |
| Selected cell | Dark blue tint | `#1A3A5C` |
| Fixed numbers | White | `#FFFFFF` |
| User-entered numbers | Light blue | `#90CAF9` |

## Typography

### Fonts
- **Primary:** System default (Roboto on Android, San Francisco on iOS)
- **Numbers:** System default, bold for fixed, regular for user entries

### Sizes
| Element | Size | Weight |
|---------|------|--------|
| App bar title | 20px | Medium |
| Grid numbers (fixed) | 24px | Bold |
| Grid numbers (user) | 24px | Regular |
| Button text | 16px | Medium |
| Dialog title | 20px | Medium |
| Dialog body | 16px | Regular |
| Small labels | 12px | Regular |

## Layout

### Game Screen
```
[App Bar - 56dp height]
  - Back button (left)
  - Title: "Sudoku" (center)
  - Settings icon (right)

[Timer & Difficulty - 48dp height]
  - Difficulty: "Medium" (left)
  - Timer: "12:34" (right)

[Spacer - flexible]

[Sudoku Grid - square, max 360x360dp]
  - 9x9 grid
  - Thin lines: 1dp
  - Thick lines (3x3 borders): 2dp
  - Cell size: ~40dp
  - Padding: 16dp all sides

[Spacer - flexible]

[Number Input Pad - 72dp height]
  - Numbers 1-9 as buttons
  - Equal width, square buttons
  - Active state on tap

[Action Bar - 56dp height]
  - Undo | Erase | Notes | Hint
  - Icons with labels below
```

### Key Dimensions
- **Touch targets:** Minimum 48x48dp (all buttons)
- **Grid padding:** 16dp from screen edges
- **Button padding:** 12dp horizontal, 8dp vertical
- **Spacing between sections:** 16dp
- **Card corner radius:** 8dp
- **Dialog corner radius:** 12dp

## Flutter Implementation

### ThemeData Configuration

```dart
// lib/theme/app_theme.dart
import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData light() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: const ColorScheme.light(
        background: Color(0xFFFAFAFA),
        surface: Color(0xFFFFFFFF),
        onSurface: Color(0xFF333333),
        onSurfaceVariant: Color(0xFF757575),
        primary: Color(0xFF4A90D9),
        onPrimary: Color(0xFFFFFFFF),
        primaryContainer: Color(0xFFE3F2FD),
        error: Color(0xFFE57373),
      ),
      scaffoldBackgroundColor: const Color(0xFFFAFAFA),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
    );
  }
  
  static ThemeData dark() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: const ColorScheme.dark(
        background: Color(0xFF121212),
        surface: Color(0xFF1E1E1E),
        onSurface: Color(0xFFE0E0E0),
        onSurfaceVariant: Color(0xFFB0B0B0),
        primary: Color(0xFF6AB7FF),
        onPrimary: Color(0xFF121212),
        primaryContainer: Color(0xFF1A3A5C),
        error: Color(0xFFEF5350),
      ),
    );
  }
}
```

### Color Constants for Grid

```dart
// lib/theme/grid_colors.dart
import 'package:flutter/material.dart';

class GridColors {
  // Light theme
  static const gridLineThin = Color(0xFFE0E0E0);
  static const gridLineThick = Color(0xFF9E9E9E);
  static const cellSelected = Color(0xFFE3F2FD);
  static const cellHighlighted = Color(0xFFF5F9FF);
  static const cellMatch = Color(0xFFE8F5E9);
  static const givenNumber = Color(0xFF000000);
  static const userNumber = Color(0xFF1565C0);
  static const noteText = Color(0xFF757575);
  static const error = Color(0xFFE57373);
  static const errorBackground = Color(0xFFFFEBEE);
}
```

### Widget Structure

```
lib/
├── main.dart
├── theme/
│   ├── app_theme.dart
│   └── grid_colors.dart
├── models/
│   ├── cell_data.dart
│   └── difficulty.dart
├── widgets/
│   ├── sudoku_grid.dart
│   ├── sudoku_cell.dart
│   ├── number_pad.dart
│   ├── game_toolbar.dart
│   ├── game_status_bar.dart
│   └── game_app_bar.dart
├── screens/
│   ├── game_screen.dart
│   ├── main_menu_screen.dart
│   ├── settings_screen.dart
│   └── win_screen.dart
└── dialogs/
    └── difficulty_dialog.dart
```

## Grid Cell States

### Visual States
1. **Default** — White background, black number (if fixed) or blue number (if user)
2. **Selected** — Light blue tint background, number slightly larger
3. **Highlighted** — Very light blue for row/column/box of selected cell
4. **Same number** — Light teal tint for cells with same number as selected
5. **Error** — Light red background (if validation on and number conflicts)
6. **Completed** — Subtle green tint when puzzle solved

### Interaction
- **Tap cell** — Select cell, show number pad active state
- **Tap number** — Enter number in selected cell
- **Long press** — Toggle notes/pencil mode for that cell
- **Double tap** — Erase cell

## Screens

### 1. Main Menu
- Title: "Sudoku" (large, centered)
- Buttons: [Continue] [New Game] [Statistics] [Settings]
- Subtle background pattern (optional)

### 2. Difficulty Selection
- Title: "Select Difficulty"
- Options: Easy | Medium | Hard | Expert
- Each shows estimated solve time
- [Start Game] button

### 3. Game Screen (main)
(See layout above)

### 4. Pause/Settings Menu
- [Resume] [New Game] [Restart] [How to Play] [Settings]
- Semi-transparent overlay

### 5. Win Screen
- Celebration animation (subtle)
- Time taken
- Difficulty
- [New Game] [Share] [Main Menu]

### 6. Settings Screen
- Theme: Light | Dark | System
- Sound: On/Off
- Haptic feedback: On/Off
- Auto-check errors: On/Off
- Show timer: On/Off
- About / Rate app / Share

## Assets Needed

### Icons (Material Design)
- Back arrow
- Settings/gear
- Undo
- Erase/delete
- Pencil/notes
- Lightbulb/hint
- Pause
- Play
- Refresh/restart
- Share
- Star (rating)

### Optional Graphics
- App icon (9x9 grid motif)
- Feature graphic for Play Store
- Screenshot frames (if needed)

## Accessibility

- **Color contrast:** All text 4.5:1 minimum
- **Touch targets:** 48dp minimum
- **Screen reader:** All buttons labeled
- **Focus indicators:** Visible focus states
- **Reduced motion:** Respect system preference

## MVP vs Future

### MVP (Must Have)
- Light theme only
- Basic grid styling
- Selected/highlighted states
- Simple number pad
- Win screen

### v1.1 (Nice to Have)
- Dark theme
- Notes/pencil marks
- Hint animations
- Statistics screen

### v2.0 (Future)
- Custom themes
- Sound effects
- Animations
- Daily challenges UI

## Data Models

```dart
// lib/models/cell_data.dart
class CellData {
  final int? value;           // null = empty
  final bool isGiven;         // true = puzzle clue (fixed)
  final Set<int> notes;       // Pencil marks (1-9)
  final bool isError;         // Conflict detected
  
  const CellData({
    this.value,
    this.isGiven = false,
    this.notes = const {},
    this.isError = false,
  });
  
  CellData copyWith({
    int? value,
    bool? isGiven,
    Set<int>? notes,
    bool? isError,
  }) {
    return CellData(
      value: value ?? this.value,
      isGiven: isGiven ?? this.isGiven,
      notes: notes ?? this.notes,
      isError: isError ?? this.isError,
    );
  }
}

// lib/models/difficulty.dart
enum Difficulty {
  easy('Easy', 35),      // 35 cells given
  medium('Medium', 30),  // 30 cells given  
  hard('Hard', 25),      // 25 cells given
  expert('Expert', 22);  // 22 cells given
  
  final String label;
  final int givenCells;
  
  const Difficulty(this.label, this.givenCells);
}
```

---

*Created: 2026-02-05*
*Status: Implementation Ready*
*For: Coder Agent*
