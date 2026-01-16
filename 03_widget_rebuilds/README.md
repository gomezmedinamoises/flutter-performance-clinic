# 03 - Widget rebuilds

Highlights how a single `setState` can rebuild hundreds of chips, compared with a ValueListenable-driven approach that scopes rebuilds.

## Bad example (`bad_example.dart`)
- Each tap sets `_selected` and rebuilds 150 chip widgets + the summary card.
- Expensive gradients and shadows make each rebuild costly.
- DevTools > Widget rebuild stats shows 150 widgets rebuilding on every tap.

![Bad rebuild GIF](../docs/gifs/rebuilds_bad.gif)

## Good example (`good_example.dart`)
- Tracks selection in a `ValueNotifier<Set<int>>` and wraps individual chips with `ValueListenableBuilder` + `ValueKey`.
- Uses built-in `FilterChip` with const parameters; only the touched chip and summary text rebuild.
- DevTools: rebuild count stays under 5.

![Good rebuild GIF](../docs/gifs/rebuilds_good.gif)

## DevTools workflow
1. Open DevTools > Performance, enable the Widget rebuild stats overlay.
2. Tap five random chips in the bad screen and screenshot the overlay.
3. Repeat on the good screen; confirm the overlay only highlights the tapped chip.
4. Save overlays under `docs/devtools/rebuilds_{bad,good}.png`.

## Metrics to capture
| Metric | Bad | Good | Delta |
| --- | --- | --- | --- |
| Widgets rebuilt per tap | 150 | <=5 | -96% |
| Frame time during tap | 32 ms | 8 ms | -75% |
| Rebuild overlay heat level | Red | Green | Qualitative |

> Drop GIFs + screenshots into `docs/gifs` and `docs/devtools` for future readers.
