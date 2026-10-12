import CXXHash
import Foundation

/// XXH3, 64- and 128-bit, computed by the official xxHash C code.
///
/// Fast and well distributed, for checksums and hash tables. Not
/// cryptographic: don't use it where someone may craft collisions.
public enum XXH3 {
    /// The 64-bit XXH3 hash of `bytes`.
    public static func hash64(_ bytes: some ContiguousBytes, seed: UInt64 = 0) -> UInt64 {
        bytes.withUnsafeBytes { XXH3_64bits_withSeed($0.baseAddress, $0.count, seed) }
    }

    /// The 128-bit XXH3 hash of `bytes`.
    public static func hash128(_ bytes: some ContiguousBytes, seed: UInt64 = 0) -> UInt128 {
        bytes.withUnsafeBytes { UInt128(XXH3_128bits_withSeed($0.baseAddress, $0.count, seed)) }
    }
}

/// XXH3-64 over bytes that arrive in pieces; the result matches `XXH3.hash64`
/// of all of them at once.
public struct XXH3Hasher64: ~Copyable {
    private let state: OpaquePointer

    public init(seed: UInt64 = 0) {
        state = XXH3_createState()
        XXH3_64bits_reset_withSeed(state, seed)
    }

    deinit { XXH3_freeState(state) }

    public mutating func update(_ bytes: some ContiguousBytes) {
        bytes.withUnsafeBytes { _ = XXH3_64bits_update(state, $0.baseAddress, $0.count) }
    }

    /// The hash of everything so far; more can still be added.
    public func finalize() -> UInt64 { XXH3_64bits_digest(state) }
}

/// XXH3-128 over bytes that arrive in pieces; the result matches
/// `XXH3.hash128` of all of them at once.
public struct XXH3Hasher128: ~Copyable {
    private let state: OpaquePointer

    public init(seed: UInt64 = 0) {
        state = XXH3_createState()
        XXH3_128bits_reset_withSeed(state, seed)
    }

    deinit { XXH3_freeState(state) }

    public mutating func update(_ bytes: some ContiguousBytes) {
        bytes.withUnsafeBytes { _ = XXH3_128bits_update(state, $0.baseAddress, $0.count) }
    }

    /// The hash of everything so far; more can still be added.
    public func finalize() -> UInt128 { UInt128(XXH3_128bits_digest(state)) }
}

extension UInt128 {
    init(_ hash: XXH128_hash_t) {
        self = UInt128(hash.high64) << 64 | UInt128(hash.low64)
    }
}
