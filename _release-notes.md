## What's Changed

**1.3.1 ports Solidarity to Expo / React Native + Nitro Modules — the first cross-platform (iOS + Android) release, built for 1:1 visual + behavioural parity with the SwiftUI v1.3.x app.** by @kidneyweakx

The new `apps/expo` client is the headline of this release: ~320 commits stand up the whole app — onboarding, identity, passport/ZK, sharing, vault, credentials, groups, shoutouts — on **Expo SDK 56 / React Native 0.85 / TS 6 / NativeWind 4.2**, with all native crypto, NFC, proximity and ZK proving delivered as **Nitro Modules** that run on **both** iOS and Android. Android ships for the first time via EAS Build; iOS releases via Xcode Cloud.

### Highlights (Expo client)

**Foundation**
- `06d839b` scaffold `apps/expo` — SDK 56, RN 0.85, TS 6, NativeWind 4.2, vision-camera v5
- `ff5a00c` bun-workspace monorepo + strict lint (max-lines 500, no `any` at boundaries)
- themed design system — `Themed{Text,Surface,Button}` + `Colors` token mirroring Swift `Color.Theme.*` 1:1, light/dark parity
- `c50e471` `FloatingTabBar` 1:1 port of Swift `CustomFloatingTabBar`; `f0dc093` i18next bootstrap with en / zh-Hant

**Nitro Modules (native, iOS + Android)**
- `1fb7b11` `nitro-spruce-did` — real DID with Secure Enclave / StrongBox keys
- `ae2b0d0` `nitro-proximity` rewrite on CoreBluetooth L2CAP + UWB; `59b2686` Android L2CAP CoC + BLE advertise/scan + UWB; `17f4d27` `androidx.core.uwb` controlee sessions
- `bb3099d` `nitro-semaphore` — Semaphore identity + groups + nullifier via Rust; `e81e7fa` Android nullifier proofs via real Rust FFI
- `40924e1` `nitro-nfc-passport` — Android jmrtd BAC+PACE+passive auth (DG1/2/14/15/SOD parity with iOS); `56710ba` bundled CSCA masterList + guard against silent mock fallback
- `b968310` `nitro-secrets-vault` — hardware root-secret wrapping (Secure Enclave / StrongBox / TEE)
- `62bc6f9` `walletpass` — Swift `PassKitManager` port with server-side PKCS7 signing; `9d12c68` `nitro-airdrop` iOS `UIActivityViewController`

**Passport · NFC · Zero-knowledge**
- `3b72671` Nitro MRZ-OCR plugin (VisionKit iOS / ML Kit Android) + 3-frame consensus parser
- `cf9a95b` FHD + native-Vision parity, adaptive ROI for <1s MRZ scan; `4c9c73b` pure-algorithm Tesseract4Android Android path
- `dec96ec` OpenAC v3 disclosure circuit — real chip MRZ → 9-field witness, age / nationality proof end-to-end; `5f52a2b` bundle passport-noir 0.3.0 circuits
- `b554f3b` passive-only OpenAC v3 proofs when the chip exposes no DG15/AA; `6bb5956` DSC revocation + DG15 active-auth evidence
- `10f4603` Android: bundle `passport_verifier` + SRS, auto-resolve bundled v3 circuit

**Identity · keychain · vault**
- `845c248` SpruceID `did:key` VCs + iCloud-Keychain-syncable key; `e8bf309` W3C `did:key` document export matching Swift JSON
- `a019621` `BusinessCardCredentialEnvelope` ES256 JWS; `f760aa5` PBKDF2 + AES-GCM identity import restoring cards/claims/credentials
- `5b5271c` single-layer sign gate via `keyAuthMode` (JS gate canonical); `a20d833` shared biometric grace bucket — delete always prompts
- `905014f` vault `ContentKeyExchangeService` X25519 + HKDF + AES-GCM; `2fc5b53` root wrapping key migrated to ACL-free v2

**App surfaces — 1:1 SwiftUI parity**
- `70b919b` Me tab (`ProfileHeaderCard` + sections + tiles); `8a442d4` Groups management + detail + new flow; `8011b17` Shoutouts Stats charts via react-native-svg
- `bf495a9` `ReceivedCardSheet`; `ac596ee` credentials Present-proof with chunked QR + playback controls; `7be4c93` scan VerifierResult + ProofPresentation sheets
- onboarding 7-step flow, cards editor, vault, contacts importer — all ported to parity

**Sharing · proximity · matching · messaging**
- `76f14e0` proximity matching flow 1:1; `b468781` DID-bound signer/verifier with raw r‖s / DER support
- `8fb2efb` Sakura APNs/FCM push + Ed25519 sealed-route cache + inbox sync; `27d6915` fail-closed TLS pinning mirroring Swift `MessageServerPinning`
- `7cddf27` iCloud backup → Drive Documents SOLB files (fixes prod-schema CKError); `e614731` OIDC `vp_token` verify + dcql parsing

**Developer sandbox (DID-first DAG / P2P playground)**
- `e4c735e` Developer screen rewritten as DID-first hub; `7fa3323` DAG node schema (NIP-01 id + BIP-340 schnorr via @noble); `d1d0362` three-step sync (HEADS → WANT → NODE)
- `1a89cbb` 3D force-directed DAG graph; `6251259` Nostr Bridge Lab (NIP-78); `bf374ed` Common Friends Lab (DAG diff intersection); `194f6a9` UWB Bump Lab

**Android polish & build**
- `4f39310` EAS submit + AAB signing, splash, sqlite, scrubbed media perms, Terraform infra; `c405b2b` broad Android-parity pass (SfIcon mapping, dark tab bar, pickers, toasts, Settings ordering)
- `5ef4293` themed `confirmDialog` replaces Material `Alert.alert`; `c8ea657` deep-link DomainVerification allowlist; safe-area insets so CTAs clear notch / nav bar
- `e31cc9a` Xcode Cloud bootstrap; `bfa52cb` seeded `Package.resolved`; `6c77010` copy non-owning Nitro `ArrayBuffer` before `Promise.async` (fixes sign/share/VC SIGTRAP)

> Full per-commit detail (376 commits) is in the changelog link below.

**Full Changelog**: https://github.com/p2p-solidarity/solidarity/compare/1.3.0...1.3.1

