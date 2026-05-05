# performance/image-optimization.md

## Objective

Define standards to optimize image loading, rendering, and caching in React Native applications for smooth performance and reduced memory/network usage (critical for fintech/banking apps).

Applies to:

* React Native (iOS + Android)
* TypeScript
* UI components, lists, and media-heavy screens

Main rule:

> Images must be appropriately sized, efficiently cached, and rendered with minimal impact on memory and the UI thread.

---

# 1. Core Principles

## 1.1 Right Size, Right Format

* Do not render images larger than required display size
* Prefer modern formats (WebP/HEIF where supported)

## 1.2 Cache Aggressively (but Safely)

* Cache static assets and CDN images
* Avoid caching sensitive images

## 1.3 Avoid Re-renders

* Stable props
* Memoized components

---

# 2. Image Formats

## 2.1 Recommended

* **WebP** (Android + iOS modern)
* **JPEG** (photos)
* **PNG** (transparency)

## 2.2 Avoid

* Large PNG for photos
* Uncompressed images

Rules:

* Balance quality vs size
* Use progressive JPEG for large photos

---

# 3. Sizing & Resizing

## 3.1 Server-side Resize (Preferred)

* Request exact size from CDN

```txt
https://cdn/image.jpg?w=200&h=200
```

## 3.2 Client-side Resize (Fallback)

* Resize before rendering
* Avoid scaling very large images in UI

---

# 4. Caching Strategy

## 4.1 Use Caching Libraries

* `react-native-fast-image`
* Platform-native caching (URLSession/OkHttp)

## 4.2 Cache Control

* Respect server `Cache-Control`
* Use immutable URLs for versioning

```txt
image_v2.png
```

## 4.3 Do Not Cache Sensitive Images

* KYC documents
* ID cards
* Receipts (if sensitive)

---

# 5. Rendering Optimization

## 5.1 Avoid Re-rendering Images

```ts
export default React.memo(ImageComponent);
```

## 5.2 Stable Source

Bad:

```tsx
<Image source={{ uri: dynamicUrl() }} />
```

Good:

```tsx
const uri = useMemo(() => buildUrl(id), [id]);
<Image source={{ uri }} />
```

---

# 6. List Optimization (CRITICAL)

## 6.1 Use FlatList with Images

* Avoid rendering too many images at once

## 6.2 Lazy Loading

* Load images only when visible

## 6.3 Placeholder

```tsx
<Image source={placeholder} />
```

* Show skeleton or placeholder while loading

---

# 7. Memory Management

## 7.1 Avoid Large Bitmaps

* Downscale images before rendering

## 7.2 Release Unused Images

* Unmount components when not needed

## 7.3 Limit Concurrent Loads

* Avoid loading many large images simultaneously

---

# 8. Progressive Loading

* Load low-resolution image first
* Replace with high-resolution after

```txt
low-res → high-res
```

---

# 9. Network Optimization

## 9.1 CDN Usage

* Always serve images via CDN
* Use geographic edge nodes

## 9.2 Compression

* Enable gzip/brotli (for metadata)
* Optimize image size at source

---

# 10. Error Handling

```tsx
<Image
  source={{ uri }}
  onError={() => setError(true)}
/>
```

Rules:

* Provide fallback image
* Avoid infinite retry loops

---

# 11. Fintech Rules

## 11.1 Sensitive Images

* Do not cache locally
* Use secure endpoints (authenticated)

## 11.2 KYC Documents

* Load on-demand only
* Clear after use

## 11.3 Transaction Screens

* Optimize icons/logos
* Avoid heavy images

---

# 12. Testing & Profiling

Tools:

* Flipper (Network + Images)
* React DevTools
* Android Studio Profiler
* Xcode Instruments

Metrics:

* image load time
* memory usage
* FPS during scroll

---

# 13. Common Anti-patterns

* Loading full-size images in thumbnails
* No caching strategy
* Inline dynamic URLs every render
* Rendering too many images at once
* Using map() for large image lists

---

# 14. Checklist

* [ ] Images resized correctly
* [ ] CDN used
* [ ] Caching configured
* [ ] No sensitive image caching
* [ ] Lazy loading implemented
* [ ] Placeholders used
* [ ] No unnecessary re-renders

---

# 15. Final Rule

> Image optimization is a balance of quality, size, and performance.
> Poor image handling leads to slow UI, high memory usage, and bad UX.
