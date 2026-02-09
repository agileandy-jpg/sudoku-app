# Sudoku App - Context Document

## Overview
First revenue-generating app for Agile Vortex. A clean, well-designed Sudoku puzzle game built with Expo (cross-platform: Android + iOS).

## Goals
- Ship a polished MVP in 2-3 weeks
- Learn the app store process end-to-end
- Generate initial revenue to fund passion project
- Build foundation for future puzzle games

## Target Audience
- Casual puzzle players
- Ages 25-55
- Mobile users (Android primary, iOS secondary)
- Value: clean design, no intrusive ads, fair difficulty

---

## Core Features (MVP)

### Must Have
- [ ] 9x9 Sudoku grid
- [ ] Puzzle generator (unique solutions)
- [ ] Three difficulties: Easy / Medium / Hard
- [ ] Number input (tap cell, then number)
- [ ] Real-time validation (optional: highlight errors)
- [ ] Win detection
- [ ] New game / Restart
- [ ] Basic settings (sound on/off)

### Nice to Have (v1.1)
- [ ] Notes/pencil marks
- [ ] Hint system (limited, IAP or ad rewarded)
- [ ] Timer
- [ ] Statistics tracking
- [ ] Dark mode

### Future (v2.0)
- [ ] Daily challenges
- [ ] Leaderboards
- [ ] Themes/skins (IAP)
- [ ] iOS port (already supported via Expo!)

---

## Technical Specs

### Platform
- Primary: Android
- Framework: Expo / React Native
- Min SDK: Android 6.0 (API 23)

### Architecture
- State management: React Context + Zustand (lightweight)
- Puzzle generation: Custom TypeScript algorithm or lightweight library
- Storage: AsyncStorage for settings/stats

### Monetization
- Free with ads
- Interstitial ads between games
- Rewarded ads for hints
- Premium unlock (remove ads, unlimited hints) - $2.99

---

## Design Philosophy
- **Clean and calm** — The puzzle is the hero
- **Minimal chrome** — No unnecessary UI elements
- **Accessible** — High contrast, readable numbers, touch-friendly
- **Fast** — No animations that slow down gameplay

---

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

---

## Typography

### Fonts
- **Primary:** System default (Roboto on Android, San Francisco on iOS)
- **Numbers:** System default, bold for fixed, regular for user entries

### Sizes
| Element | Size | Weight |
|---------|------|--------|
| Header title | 20px | 600 (Semibold) |
| Grid numbers (fixed) | 24px | Bold |
| Grid numbers (user) | 24px | Normal |
| Button text | 16px | 500 (Medium) |
| Dialog title | 20px | 600 (Semibold) |
| Dialog body | 16px | Normal |
| Small labels | 12px | Normal |

---

## Layout

### Game Screen
```
[Header - 56px height]
  - Back button (left)
  - Title: "Sudoku" (center)
  - Settings icon (right)

[Timer & Difficulty - 48px height]
  - Difficulty: "Medium" (left)
  - Timer: "12:34" (right)

[Spacer - flexible]

[Sudoku Grid - square, max 360x360px]
  - 9x9 grid
  - Thin lines: 1px
  - Thick lines (3x3 borders): 2px
  - Cell size: ~40px
  - Padding: 16px all sides

[Spacer - flexible]

[Number Input Pad - 72px height]
  - Numbers 1-9 as buttons
  - Equal width, square buttons
  - Active state on tap

[Action Bar - 56px height]
  - Undo | Erase | Notes | Hint
  - Icons with labels below
```

### Key Dimensions
- **Touch targets:** Minimum 48x48px (all buttons)
- **Grid padding:** 16px from screen edges
- **Button padding:** 12px horizontal, 8px vertical
- **Spacing between sections:** 16px
- **Card border radius:** 8px
- **Dialog border radius:** 12px

---

## Expo / React Native Implementation

### Project Structure

```
sudoku-app/
├── src/
│   ├── components/          # Reusable UI components
│   │   ├── sudoku/
│   │   │   ├── SudokuGrid.tsx
│   │   │   ├── SudokuCell.tsx
│   │   │   ├── NumberPad.tsx
│   │   │   └── GameToolbar.tsx
│   │   └── ui/
│   │       ├── Button.tsx
│   │       ├── Dialog.tsx
│   │       └── IconButton.tsx
│   ├── screens/             # Screen components
│   │   ├── MainMenuScreen.tsx
│   │   ├── GameScreen.tsx
│   │   ├── DifficultyScreen.tsx
│   │   ├── SettingsScreen.tsx
│   │   └── WinScreen.tsx
│   ├── hooks/               # Custom React hooks
│   │   ├── useGame.ts
│   │   ├── useSudoku.ts
│   │   └── useSettings.ts
│   ├── stores/              # Zustand state stores
│   │   ├── gameStore.ts
│   │   ├── settingsStore.ts
│   │   └── statsStore.ts
│   ├── contexts/            # React Context (if needed)
│   │   └── ThemeContext.tsx
│   ├── utils/               # Utility functions
│   │   ├── puzzleGenerator.ts
│   │   ├── sudokuSolver.ts
│   │   └── validation.ts
│   ├── types/               # TypeScript types
│   │   └── index.ts
│   ├── constants/
│   │   ├── colors.ts
│   │   ├── theme.ts
│   │   └── config.ts
│   └── App.tsx              # Root component
├── assets/
│   ├── images/
│   └── sounds/
├── app.json                 # Expo configuration
├── package.json
├── tsconfig.json
└── .gitignore
```

### Theme Configuration

```typescript
// src/constants/theme.ts
import { Theme } from '../types';

export const lightTheme: Theme = {
  colors: {
    background: '#FAFAFA',
    surface: '#FFFFFF',
    onSurface: '#333333',
    onSurfaceVariant: '#757575',
    primary: '#4A90D9',
    onPrimary: '#FFFFFF',
    primaryContainer: '#E3F2FD',
    error: '#E57373',
    // Grid colors
    gridLineThin: '#E0E0E0',
    gridLineThick: '#9E9E9E',
    cellSelected: '#E3F2FD',
    cellHighlighted: '#F5F9FF',
    cellMatch: '#E8F5E9',
    givenNumber: '#000000',
    userNumber: '#1565C0',
    noteText: '#757575',
    errorBackground: '#FFEBEE',
  },
  spacing: {
    xs: 4,
    sm: 8,
    md: 16,
    lg: 24,
    xl: 32,
  },
  borderRadius: {
    sm: 4,
    md: 8,
    lg: 12,
  },
};

export const darkTheme: Theme = {
  colors: {
    background: '#121212',
    surface: '#1E1E1E',
    onSurface: '#E0E0E0',
    onSurfaceVariant: '#B0B0B0',
    primary: '#6AB7FF',
    onPrimary: '#121212',
    primaryContainer: '#1A3A5C',
    error: '#EF5350',
    // Grid colors
    gridLineThin: '#424242',
    gridLineThick: '#616161',
    cellSelected: '#1A3A5C',
    cellHighlighted: '#0D1F33',
    cellMatch: '#1B3D1B',
    givenNumber: '#FFFFFF',
    userNumber: '#90CAF9',
    noteText: '#B0B0B0',
    errorBackground: '#3D1515',
  },
  spacing: lightTheme.spacing,
  borderRadius: lightTheme.borderRadius,
};
```

### State Management (Zustand)

```typescript
// src/stores/gameStore.ts
import { create } from 'zustand';
import { CellData, Difficulty } from '../types';

interface GameState {
  grid: CellData[][];
  selectedCell: { row: number; col: number } | null;
  difficulty: Difficulty;
  timer: number;
  isNotesMode: boolean;
  isComplete: boolean;
  
  // Actions
  selectCell: (row: number, col: number) => void;
  enterNumber: (number: number) => void;
  toggleNotes: () => void;
  undo: () => void;
  erase: () => void;
  newGame: (difficulty: Difficulty) => void;
}

export const useGameStore = create<GameState>((set, get) => ({
  grid: [],
  selectedCell: null,
  difficulty: 'medium',
  timer: 0,
  isNotesMode: false,
  isComplete: false,
  
  selectCell: (row, col) => set({ selectedCell: { row, col } }),
  enterNumber: (number) => { /* implementation */ },
  toggleNotes: () => set(state => ({ isNotesMode: !state.isNotesMode })),
  undo: () => { /* implementation */ },
  erase: () => { /* implementation */ },
  newGame: (difficulty) => { /* implementation */ },
}));
```

### React Native Paper Setup (Optional)

```typescript
// App.tsx
import { PaperProvider } from 'react-native-paper';
import { StatusBar } from 'expo-status-bar';
import { NavigationContainer } from '@react-navigation/native';
import { createNativeStackNavigator } from '@react-navigation/native-stack';
import { MainMenuScreen, GameScreen, SettingsScreen } from './src/screens';
import { theme } from './src/constants/theme';

const Stack = createNativeStackNavigator();

export default function App() {
  return (
    <PaperProvider theme={theme}>
      <NavigationContainer>
        <Stack.Navigator>
          <Stack.Screen name="MainMenu" component={MainMenuScreen} />
          <Stack.Screen name="Game" component={GameScreen} />
          <Stack.Screen name="Settings" component={SettingsScreen} />
        </Stack.Navigator>
      </NavigationContainer>
      <StatusBar style="auto" />
    </PaperProvider>
  );
}
```

---

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

---

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

---

## Data Models

```typescript
// src/types/index.ts

export interface CellData {
  value: number | null;        // null = empty
  isGiven: boolean;            // true = puzzle clue (fixed)
  notes: Set<number>;          // Pencil marks (1-9)
  isError: boolean;            // Conflict detected
}

export type Difficulty = 'easy' | 'medium' | 'hard' | 'expert';

export interface DifficultyConfig {
  label: string;
  givenCells: number;
}

export const DIFFICULTY_CONFIG: Record<Difficulty, DifficultyConfig> = {
  easy: { label: 'Easy', givenCells: 35 },
  medium: { label: 'Medium', givenCells: 30 },
  hard: { label: 'Hard', givenCells: 25 },
  expert: { label: 'Expert', givenCells: 22 },
};

export interface GameStats {
  gamesPlayed: number;
  gamesWon: number;
  bestTime: Record<Difficulty, number | null>;
  currentStreak: number;
}
```

---

## Assets Needed

### Icons (Lucide React Native or Expo Vector Icons)
- Arrow-left (back)
- Settings/gear
- Undo
- Trash-2 (erase/delete)
- Pencil (notes)
- Lightbulb (hint)
- Pause
- Play
- Refresh-cw (restart)
- Share
- Star (rating)

### Optional Graphics
- App icon (9x9 grid motif)
- Feature graphic for Play Store/App Store
- Screenshot frames (if needed)

---

## Accessibility

- **Color contrast:** All text 4.5:1 minimum
- **Touch targets:** 48px minimum
- **Screen reader:** All buttons labeled with `accessibilityLabel`
- **Focus indicators:** Visible focus states
- **Reduced motion:** Respect system preference via `useReducedMotion()`

---

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

---

## Competitors to Beat
1. **Sudoku.com (Easybrain)** - Too many ads
2. **Microsoft Sudoku** - Bloated, slow
3. **Sudoku - Classic** - Dated UI

**Our angle:** Clean, fast, fair monetization

---

## Success Metrics
- 1000+ downloads in first month
- 4.0+ star rating
- $100+ revenue in first quarter
- Lessons learned documented

---

## Timeline

| Week | Focus |
|------|-------|
| 1 | Research, design, puzzle generator |
| 2 | Core game logic, UI implementation |
| 3 | Polish, ASO, store submission |

---

## Key Decisions Log

| Date | Decision | Rationale |
|------|----------|-----------|
| 2026-02-05 | Expo/React Native over Flutter | Faster dev, web preview, easier OTA updates |
| 2026-02-05 | Android primary | Larger market, easier testing |
| 2026-02-05 | Freemium model | Standard for puzzle games |

---

*Created: 2026-02-05*
*Updated: 2026-02-09 (Pivot: Flutter → Expo)*
*Owner: Andy*
*Status: Ready for Development*
