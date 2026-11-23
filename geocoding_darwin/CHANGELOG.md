## 1.0.3+veniti.1

- **VENITI PATCH** (fork `allansalles-satellitus/flutter-geocoding`, tag
  `geocoding_darwin_v1.0.3+veniti.1`, usado via `dependency_overrides` git no
  app): `detachFromEngine` mantém o
  `ProxyApiRegistrar` vivo por 120s depois do `tearDown()`. No 1.0.3 publicado
  ele era destruído na hora, e uma resposta do `CLGeocoder` ainda pendente lia
  a referência `unowned` destruída e abortava o app (Crashlytics `86faf374`,
  `Attempted to read an unowned reference`). Remover esta cópia quando uma
  versão oficial corrigir o defeito. Spec:
  `20261105-1408-ios-geocoding-unowned-crash`.

## 1.0.3

- Moves `pigeon` from `dependencies` to `dev_dependencies`. Pigeon is a
  build-time code generator; the generated `geocoding.g.dart` does not import it
  at runtime. Declaring it as a runtime dependency leaked pigeon's `analyzer`
  version constraint into consuming apps. This matches `geocoding_android`,
  which already declares pigeon under `dev_dependencies`. Fixes #304.

## 1.0.2

- Registers the `GeocodingDarwinFactory` class as `dartPluginClass` factory to
  ensure the plugin automatically registers it self correctly.

## 1.0.1

- Updates the example app to demonstrate Darwin-specific native CLGeocoder
  methods via `clgeocoder.dart`.

## 1.0.0

- Initial release of the geocoding_darwin package containing easy geocoding and
  reverse-geocoding features for iOS and macOS.
