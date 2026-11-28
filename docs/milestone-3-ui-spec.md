# Milestone 3 — UI Specification

This specification describes the current Member B interface. The Milestone 1 user stories were not available when it was written, so Goals A–E are provisional and must be mapped to the original story IDs before submission. This is a specification artifact; it does not add Flutter behavior.

## Conventions and scope

- Wireframes are monochrome and focus on structure and controls.
- `[...]` indicates an interactive control; `{...}` indicates data-driven content.
- W1–W5 include the persistent Today / Calendar / Stats / Awards / Settings navigation.
- Empty states are alternative paths. The current app has no service-backed loading or error UI.
- W6 is the existing Add Habit handoff placeholder; adding a habit is outside Member B's implemented scope.

## User flows

### Goal A — Review and complete today's habits

```mermaid
flowchart TD
  A([Start]) --> B[W1 Today]
  B --> C{Habits planned today?}
  C -- Yes --> D[Show habit cards]
  D --> E[Tap completion control]
  E --> F[Update completion and progress]
  F --> G([End])
  C -- No --> H[Show empty state]
  H --> I[Tap Add a habit]
  I --> J[W6 Add Habit placeholder]
  J --> B
```

Alternative: no habits are scheduled; the empty state links to the placeholder Add Habit screen.

### Goal B — Review activity on a date

```mermaid
flowchart TD
  A([Start]) --> B[W2 Calendar]
  B --> C{Change month?}
  C -- Yes --> D[Tap previous or next month]
  D --> E[Show month]
  C -- No --> F[Select date]
  E --> F
  F --> G{Habits planned on date?}
  G -- Yes --> H[Show completion statuses]
  G -- No --> I[Show empty or day-off state]
  H --> J([End])
  I --> J
```

Alternative: no active habits or no habits scheduled for the selected weekday.

### Goal C — Check statistics

```mermaid
flowchart TD
  A([Start]) --> B[W3 Statistics]
  B --> C{Active habits exist?}
  C -- No --> D[Show empty state]
  C -- Yes --> E[Show 7-day summary]
  E --> F[Choose 7 or 30 days]
  F --> G[Update completion rate and streak]
  G --> H[Show weekly bars]
  D --> I([End])
  H --> I
```

Alternative: no active habits; the summary and chart are replaced by an explanatory empty state.

### Goal D — Review achievements

```mermaid
flowchart TD
  A([Start]) --> B[W4 Achievements]
  B --> C{Habits exist?}
  C -- No --> D[Show first-award empty state]
  C -- Yes --> E[Show award progress and cards]
  E --> F{Award unlocked?}
  F -- Yes --> G[Show unlock date]
  F -- No --> H[Show locked state and requirement]
  D --> I([End])
  G --> I
  H --> I
```

Alternative: no habits exist, so only the empty state is shown.

### Goal E — Change appearance

```mermaid
flowchart TD
  A([Start]) --> B[W5 Settings]
  B --> C[Choose System, Light, or Dark]
  C --> D[Apply theme immediately]
  D --> E([End])
```

Alternative: keep the current selection. The current theme choice applies only during the app session.

## Low-fidelity wireframes

### W1 — Today

```text
+------------------------------------------------+
| Habit Tracker                              (○) |
+------------------------------------------------+
| Good morning                                   |
| {Weekday, Month DD}                            |
| +--------------------------------------------+ |
| | Today's progress                    {x / y} | |
| | [==============================          ] | |
| | {progress message}                          | |
| +--------------------------------------------+ |
| +--------------------------------------------+ |
| | Current streak                         {n} | |
| | {streak message}                            | |
| +--------------------------------------------+ |
| Today's habits                         {count} |
| [icon] {Habit title}          [○ / ✓ toggle]   |
| {description or streak}                       |
| Empty: A fresh start · [ + Add a habit ]       |
+------------------------------------------------+
| [Today] [Calendar] [Stats] [Awards] [Settings] |
+------------------------------------------------+
```

Controls: habit completion toggle, Add a habit action, pull-to-refresh, and bottom navigation.

### W2 — Calendar

```text
+------------------------------------------------+
| Calendar                                       |
| Your consistency, at a glance                 |
| +--------------------------------------------+ |
| | [<]              {Month YYYY}           [>] | |
| |  M    T    W    T    F    S    S            | |
| | {01} {02} {03} {04} {05} {06} {07}          | |
| | {08} {09} {10} {11} {12} {13} {14}          | |
| | {15} {16} {17} {18} {19} {20} {21}          | |
| | {22} {23} {24} {25} {26} {27} {28}          | |
| | {29} {30} {31}  • = completed               | |
| +--------------------------------------------+ |
| {Selected date}                       {x / y} |
| {Habit}                           {status}     |
| Empty: no habits / day off                     |
+------------------------------------------------+
| [Today] [Calendar] [Stats] [Awards] [Settings] |
+------------------------------------------------+
```

Controls: previous/next month buttons and selectable dates.

### W3 — Statistics

```text
+------------------------------------------------+
| Statistics                                     |
| Small wins add up. Here is your progress.      |
| [ 7 days ] [ 30 days ]                         |
| +--------------------------------------------+ |
| | Completion rate                       {x%} | |
| | [==============================          ] | |
| | {completed} of {planned} habit-days       | |
| +--------------------------------------------+ |
| | Current streak                         {n} | |
| | {streak message}                            | |
| +--------------------------------------------+ |
| Last 7 days · {daily completion bars}          |
| Empty alternative: Your progress starts here   |
+------------------------------------------------+
| [Today] [Calendar] [Stats] [Awards] [Settings] |
+------------------------------------------------+
```

Controls: 7-day/30-day selector. Weekly bars are informational.

### W4 — Achievements

```text
+------------------------------------------------+
| Achievements                                   |
| Celebrate the effort behind every streak.      |
| Awards unlocked                          {x/y} |
| [==============================              ] |
| Your achievements                             |
| +--------------------------------------------+ |
| | [trophy/lock] On Fire                       | |
| | Complete 3 planned days in a row.           | |
| | {Habit} · {unlock date / required streak}    | |
| +--------------------------------------------+ |
| | [trophy/lock] Week Warrior                  | |
| | Complete 7 planned days in a row.           | |
| | {Habit} · {unlock date / required streak}    | |
| +--------------------------------------------+ |
| Empty alternative: Your first award is waiting |
+------------------------------------------------+
| [Today] [Calendar] [Stats] [Awards] [Settings] |
+------------------------------------------------+
```

### W5 — Settings

```text
+------------------------------------------------+
| Settings                                       |
| Make your space feel right for you.            |
| +--------------------------------------------+ |
| | Appearance                                  | |
| | Choose how Habit Tracker looks on device.   | |
| | [ System ] [ Light ] [ Dark ]              | |
| +--------------------------------------------+ |
| | Habit Tracker · Build better days...        | |
| +--------------------------------------------+ |
+------------------------------------------------+
| [Today] [Calendar] [Stats] [Awards] [Settings] |
+------------------------------------------------+
```

Controls: System, Light, and Dark theme choices.

### W6 — Add Habit handoff

```text
+------------------------------------------------+
|                                                |
|                  Add habit                    |
|          (placeholder; no form controls)       |
|                                                |
+------------------------------------------------+
```

## Combined wireframe flows

```mermaid
flowchart LR
  W1[W1 Today] -->|Tap completion| W1
  W1 -->|Empty: tap Add a habit| W6[W6 Add Habit placeholder]
  W6 -->|Back navigation| W1
```

```mermaid
flowchart LR
  W1[W1 Today] -->|Tap Calendar tab| W2[W2 Calendar]
  W2 -->|Previous / next month or select date| W2
  W2 -->|No habits or no planned habits: read empty state| W2
```

```mermaid
flowchart LR
  W1[W1 Today] -->|Tap Stats tab| W3[W3 Statistics]
  W3 -->|Choose 7 or 30 days| W3
  W3 -->|No active habits: read empty state| W3
```

```mermaid
flowchart LR
  W1[W1 Today] -->|Tap Awards tab| W4[W4 Achievements]
  W4 -->|Review locked / unlocked cards| W4
  W4 -->|No habits: read empty state| W4
```

```mermaid
flowchart LR
  W1[W1 Today] -->|Tap Settings tab| W5[W5 Settings]
  W5 -->|Choose System / Light / Dark| W5
```

## Widget decomposition

| Screen | Sections/widgets |
|---|---|
| Home shell | `Scaffold`, `IndexedStack`, `NavigationBar` |
| W1 Today | `AppBar`, greeting/date, `ProgressCard`, `StreakCard`, habit count, `HabitCard` list or `EmptyState` |
| W2 Calendar | `AppBar`, `CalendarWidget`, date heading/count, habit tiles or `EmptyState` |
| W3 Statistics | `AppBar`, range selector, `ProgressCard`, `StreakCard`, weekly bars or `EmptyState` |
| W4 Achievements | `AppBar`, `ProgressCard`, `AchievementCard` list or `EmptyState` |
| W5 Settings | `AppBar`, appearance card and theme selector, app identity card |
| W6 Add Habit | Placeholder `Scaffold` and centered label; actual form is not implemented |

## Reusable widgets

All components below live in the shared `lib/widgets/` folder.

| Widget | Screens | Parameters |
|---|---|---|
| `ProgressCard` | Today, Statistics, Achievements | `title`, `value`, `subtitle`, `progress`, `icon` |
| `StreakCard` | Today, Statistics | `streak`, `subtitle` |
| `EmptyState` | Today, Calendar, Statistics, Achievements | `icon`, `title`, `message`, optional `actionLabel`, optional `onAction` |

`CalendarWidget` is shared from `lib/widgets/` and used by Calendar; parameters: `month`, `selectedDate`, `completionDates`, `onMonthChanged`, `onDateSelected`.

## Alignment notes

1. Map Goals A–E to the exact Milestone 1 story IDs and verify no stories are missing.
2. W6 is a placeholder handoff; habit creation is not implemented here.
3. If persistence or service loading is added, document its loading and error states separately.
