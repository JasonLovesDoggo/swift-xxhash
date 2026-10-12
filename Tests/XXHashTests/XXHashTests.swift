import Foundation
import Testing
import XXHash

/// Expected values come from `xxhsum -H3` and `-H2` built from the same release.
struct XXHashTests {
    /// Bytes 0, 1, … 250 repeated: long enough to cross the C code's internal blocks.
    static let pattern = Data((0..<(1 << 20)).map { UInt8($0 % 251) })

    @Test(arguments: [
        (Data(), 0x2d06_8005_38d3_94c2 as UInt64, 0x99aa_06d3_0147_98d8_6001_c324_468d_497f as UInt128),
        (Data("abc".utf8), 0x78af_5f94_892f_3950, 0x06b0_5ab6_733a_6185_78af_5f94_892f_3950),
        (pattern, 0x6e0d_7ac3_6b8c_10ff, 0x5373_8d98_098c_abba_6e0d_7ac3_6b8c_10ff),
    ])
    func matchesTheReferenceTool(input: Data, xxh3: UInt64, xxh128: UInt128) {
        #expect(XXH3.hash64(input) == xxh3)
        #expect(XXH3.hash128(input) == xxh128)
    }

    @Test(arguments: [0, 1, 7, 240, 4096, 65_537])
    func streamingInAnyPiecesMatchesOneShot(piece: Int) {
        for seed: UInt64 in [0, 42] {
            var hasher64 = XXH3Hasher64(seed: seed)
            var hasher128 = XXH3Hasher128(seed: seed)
            var start = 0
            while start < Self.pattern.count {
                let end = piece == 0 ? Self.pattern.count : min(start + piece, Self.pattern.count)
                hasher64.update(Self.pattern[start..<end])
                hasher128.update(Self.pattern[start..<end])
                start = end
            }
            #expect(hasher64.finalize() == XXH3.hash64(Self.pattern, seed: seed))
            #expect(hasher128.finalize() == XXH3.hash128(Self.pattern, seed: seed))
        }
    }

    @Test func aSeedChangesTheHash() {
        #expect(XXH3.hash128(Data("abc".utf8), seed: 1) != XXH3.hash128(Data("abc".utf8)))
    }

    @Test func arraysAndDataHashTheSame() {
        #expect(XXH3.hash128([UInt8]("abc".utf8)) == XXH3.hash128(Data("abc".utf8)))
    }
}
