# Metrics dashboard

Update this table after running each scenario on your target device. Use the per-folder READMEs for detailed capture instructions.

| Scenario | Issue | Improvement highlight | Evidence |
| --- | --- | --- | --- |
| 01 List optimization | ListView builds 10k children upfront | Frame time 45 ms -> 8 ms, memory 380 MB -> 210 MB | `docs/gifs/list_bad.gif`, `docs/gifs/list_good.gif`, DevTools perf screenshots |
| 02 Memory leaks | StreamSubscription + controllers never disposed | Resident memory 220 MB -> 120 MB | `docs/devtools/memory_leak_bad.png`, `docs/devtools/memory_leak_good.png` |
| 03 Widget rebuilds | 150 chips rebuild per tap | Rebuild count 150 -> <=5, frame time 32 ms -> 8 ms | `docs/gifs/rebuilds_bad.gif`, `docs/gifs/rebuilds_good.gif` |
| 04 Image caching | Network images refetched on every scroll | Network payload 48 MB -> 7 MB, raster 28 ms -> 9 ms | `docs/devtools/images_bad.png`, `docs/devtools/images_good.png` |
| 05 Network lists | Fetches 1000 records per build | First paint 4.2 s -> 620 ms, dropped frames 24 -> 3 | `docs/gifs/network_bad.gif`, `docs/gifs/network_good.gif` |

> Replace the placeholder numbers + file paths with actual captures when you finish profiling.
