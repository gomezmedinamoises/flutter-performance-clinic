# 02 - Memory leaks

Shows how leaving `StreamSubscription`, `TextEditingController`, and `FocusNode` instances alive quickly inflates memory, and how explicit disposal fixes it.

## Bad example (`leak_example.dart`)
- `Stream.periodic` keeps pushing events even after the widget is off screen.
- Controllers are recreated automatically after setState without ever being freed.
- DevTools: the memory timeline keeps trending upward with every navigation, and GC does not recover objects.

![Leaky timeline](../docs/gifs/memory_leak_bad.gif)

## Good example (`fixed_example.dart`)
- Cancels the subscription and disposes controllers in `dispose()`.
- Uses `mounted` checks before touching state.
- DevTools: memory plateaus and dropped frames disappear after GC.

![Stable timeline](../docs/gifs/memory_leak_good.gif)

## DevTools workflow
1. Open DevTools > Memory and start allocation tracing.
2. Navigate to the bad example, push the extra screen 10 times, then take a heap snapshot.
3. Pop back to the home page and repeat on the good example. Snapshots should show stable instance counts.
4. Save screenshots under `docs/devtools/memory_leak_{bad,good}.png`.

## Metrics to capture
| Metric | Bad | Good | Delta |
| --- | --- | --- | --- |
| Memory after 10 pushes | 220 MB | 120 MB | -45% |
| Detached `StreamSubscription` count | 10+ | 0 | -100% |
| GC events triggered | 16 | 5 | -69% |

> Replace placeholder numbers with your own device measurements.
