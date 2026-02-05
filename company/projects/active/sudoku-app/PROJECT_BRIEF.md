# Project Brief: Sudoku App

## Overview
First revenue-generating app for AppVenture Studio. A clean, well-designed Sudoku puzzle game for Android (cross-platform capable).

## Goals
- Ship a polished MVP in 2-3 weeks
- Learn the app store process end-to-end
- Generate initial revenue to fund passion project
- Build foundation for future puzzle games

## Target Audience
- Casual puzzle players
- Ages 25-55
- Android users primarily
- Value: clean design, no intrusive ads, fair difficulty

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
- [ ] iOS port

## Technical Specs

### Platform
- Primary: Android
- Framework: Flutter
- Min SDK: Android 6.0 (API 23)

### Architecture
- State management: Provider or Riverpod
- Puzzle generation: Custom algorithm or lightweight library
- Storage: SharedPreferences for settings/stats

### Monetization
- Free with ads
- Interstitial ads between games
- Rewarded ads for hints
- Premium unlock (remove ads, unlimited hints) - $2.99

## Design Direction
- Clean, minimal UI
- Focus on the puzzle
- Calming color palette
- Clear number legibility
- Material Design 3 principles

## Competitors to Beat
1. **Sudoku.com (Easybrain)** - Too many ads
2. **Microsoft Sudoku** - Bloated, slow
3. **Sudoku - Classic** - Dated UI

**Our angle:** Clean, fast, fair monetization

## Success Metrics
- 1000+ downloads in first month
- 4.0+ star rating
- $100+ revenue in first quarter
- Lessons learned documented

## Timeline

| Week | Focus |
|------|-------|
| 1 | Research, design, puzzle generator |
| 2 | Core game logic, UI implementation |
| 3 | Polish, ASO, store submission |

---

## Project Structure

```
company/projects/active/sudoku-app/
├── lib/
│   ├── main.dart
│   ├── models/
│   ├── screens/
│   ├── widgets/
│   ├── services/
│   └── utils/
├── test/
├── android/
├── ios/
├── assets/
│   └── images/
├── design/
│   └── ui-specs.md
├── marketing/
│   └── store-listing.md
├── qa/
│   └── test-plan.md
└── README.md
```

---

## Key Decisions Log

| Date | Decision | Rationale |
|------|----------|-----------|
| 2026-02-05 | Flutter over React Native | Better for games, single codebase |
| 2026-02-05 | Android primary | Larger market, easier testing |
| 2026-02-05 | Freemium model | Standard for puzzle games |

---

*Created: 2026-02-05*
*Owner: Andy*
