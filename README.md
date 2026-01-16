# Flutter Performance Clinic

Hands-on clinic that reproduces common Flutter performance issues (janky lists, memory leaks, rebuild storms, image caching, and network pagination) plus their fixes. Each scenario ships with runnable code (`lib/main.dart` menu) and documentation to record metrics and device/DevTools screenshots.

```
flutter-performance-clinic/
├── 01_list_optimization/
├── 02_memory_leaks/
├── 03_widget_rebuilds/
├── 04_image_caching/
├── 05_network_lists/
├── docs/
│   ├── devtools/          # Drop PNGs from DevTools tabs
│   ├── gifs/              # Add bad/good GIF loops
│   └── videos/            # Optional longer walkthroughs
├── lib/                   # Flutter app (menu + demos)
├── METRICS.md             # Cross-scenario summary table
└── README.md
```

## Run the demos
1. Ensure you have Flutter 3.9+ installed (FVM works too).
2. Install packages: `flutter pub get`.
3. Launch the menu app: `flutter run -d <device>` (debug mode recommended).
4. Tap a scenario to open a detail view with **Bad example** and **Optimized** tabs.

## Capture performance evidence
1. With the app running, execute `flutter pub global activate devtools` (first time) and `flutter pub global run devtools`.
2. Open the printed URL, attach to the running device, and switch to the relevant tab (Performance, Memory, or Network) based on the scenario README instructions.
3. Each README lists:
   - Steps to reproduce the issue and fix.
   - Required GIFs (store under `docs/gifs/`), DevTools screenshots (`docs/devtools/`), and optional video recordings (`docs/videos/`).
   - Placeholder metrics to replace with your actual numbers.
4. Update `METRICS.md` once you have numbers and link to the new assets.

### Suggested capture workflow
- **Bad pass**: Clear DevTools timeline, start recording, perform the action that causes jank/leak, stop recording, export PNG/GIF, and save it with the naming convention from the README (`list_bad.gif`, etc.).
- **Good pass**: Repeat after switching to the optimized tab to highlight the improvement.
- Use `QuickTime`/`OBS` or `adb screenrecord` to capture video demos if desired; place them under `docs/videos/` and reference them in the scenario README or main README.

## Adding more scenarios
- Follow the numbering scheme (`06_new_topic/`).
- Provide `bad_example.dart`, `good_example.dart`, and `README.md` inside the folder.
- Register the new scenario inside `lib/main.dart` (`demos` list) so it appears in the menu.
- Extend `METRICS.md` with your new measurements.

## Deliverables checklist
- [ ] GIFs for each bad/good pair showing jank versus smooth behavior.
- [ ] DevTools screenshots (Performance, Memory, Network as applicable).
- [ ] Concrete metrics like `Reduced frame time from 45 ms to 8 ms` documented per scenario.
- [ ] Optional video walkthrough stored in `docs/videos/` and linked from the root README.
