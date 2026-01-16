# 05 - Network lists with pagination

Contrasts a naive implementation that downloads 1000 records on every build with a paginated, cached approach that keeps frame time and bandwidth low.

## Bad example (`bad_example.dart`)
- Calls the DummyJSON API (`https://dummyjson.com/products?limit=1000`) inside `build()`, so any rebuild triggers a fresh 1000-item download.
- Renders everything with `ListView(children: ...)`, forcing the framework to keep all tiles alive.

![Bad network GIF](../docs/gifs/network_bad.gif)

## Good example (`good_example.dart`)
- Fetches 20 products at a time, caches them in memory, and keeps a `skip` cursor.
- Uses `ListView.builder` with `ValueKey`s and a scroll listener that requests the next page when the user nears the bottom.
- Pull to refresh resets the cache, which makes testing easy.

![Good network GIF](../docs/gifs/network_good.gif)

## DevTools workflow
1. Clear DevTools network recording, navigate to the bad example, and wait for the 1000-item download to finish. Save the chart to `docs/devtools/network_bad.png`.
2. Navigate to the good example, pull to refresh once, scroll to trigger two more pages, and save the network chart to `docs/devtools/network_good.png`.
3. In the Performance tab, highlight CPU usage while loading both screens for the comparison.

## Metrics to capture
| Metric | Bad | Good | Delta |
| --- | --- | --- | --- |
| First meaningful paint | 4.2 s | 620 ms | -85% |
| Total payload size | 2.3 MB | 460 KB | -80% |
| Dropped frames while loading | 24 | 3 | -87% |

> The DummyJSON API has no auth requirements. If you need thousands of rows, adjust the `limit` parameter.
