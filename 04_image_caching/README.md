# 04 - Image caching

Demonstrates the impact of loading dozens of network images without caching versus precaching and using `cached_network_image`.

## Bad example (`bad_example.dart`)
- `Image.network` busts the cache by appending a query parameter, so every rebuild refetches bytes.
- Flinging causes a burst of HTTP downloads and jank on the raster thread.

![Bad image GIF](../docs/gifs/images_bad.gif)

## Good example (`good_example.dart`)
- Uses `CachedNetworkImage` plus `precacheImage` for the first rows, so the pipeline is warm.
- Loading indicators are cheap, and repeat views hit local cache.

![Good image GIF](../docs/gifs/images_good.gif)

## DevTools workflow
1. Open DevTools > Network and start recording.
2. Scroll the bad example twice; export the HAR or screenshot into `docs/devtools/images_bad.png`.
3. Scroll the good version; you should see far fewer GET requests and smaller bandwidth.
4. Capture the Performance tab to show reduced raster spikes.

## Metrics to capture
| Metric | Bad | Good | Delta |
| --- | --- | --- | --- |
| Network requests (first scroll) | 60 | 12 | -80% |
| Total bytes downloaded | 48 MB | 7 MB | -85% |
| Average raster time | 28 ms | 9 ms | -67% |

> Replace the placeholder numbers with your DevTools measurements.
