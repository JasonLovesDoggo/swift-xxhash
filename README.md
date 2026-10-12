# swift-xxhash

[xxHash](https://github.com/Cyan4973/xxHash)'s XXH3 for Swift, as a Swift package.

The official C code is included unmodified, so you get its speed and its exact hashes. A small Swift layer on top gives you one-shot and streaming hashing, 64-bit and 128-bit.

## Install

```swift
.package(url: "https://github.com/JasonLovesDoggo/swift-xxhash", from: "0.8.4"),
```

```swift
.product(name: "XXHash", package: "swift-xxhash"),
```

Requires Swift 6 and macOS 15, iOS 18, tvOS 18, watchOS 11 or visionOS 2 (for `UInt128`).

## Use

```swift
import XXHash

// One shot, from Data, [UInt8] or any ContiguousBytes.
let digest: UInt128 = XXH3.hash128(data)
let small: UInt64 = XXH3.hash64(data, seed: 42)

// In pieces, e.g. a large file read in chunks.
var hasher = XXH3Hasher128()
for chunk in chunks { hasher.update(chunk) }
let fileDigest = hasher.finalize()
```

Streamed and one-shot hashes of the same bytes are equal, and match `xxhsum -H3` / `-H2`.

XXH3 is not cryptographic: use it to catch corruption or for hash tables, not where someone could craft collisions. For that, use SHA-256 (CryptoKit).

## Versions

Releases follow xxHash's: `0.8.4` contains xxHash v0.8.4. The C sources live in `Sources/CXXHash` exactly as released; `scripts/update-xxhash <tag>` replaces them with another release.

## License

The Swift code is BSD 2-Clause (`LICENSE`). xxHash is BSD 2-Clause by Yann Collet (`Sources/CXXHash/LICENSE`).
