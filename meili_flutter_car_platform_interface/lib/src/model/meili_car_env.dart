/// The Meili API environment the funnel runs against.
///
/// The enum name is sent over the channel and must match the native SDKs'
/// environments exactly; anything else makes `open` fail.
enum MeiliCarEnv {
  /// Production.
  prod,

  /// Pre-production.
  preProd,

  /// UAT.
  uat,

  /// Development.
  dev,
}
