#if os(iOS)
  import Flutter
#elseif os(macOS)
  import FlutterMacOS
#else
  #error("Unsupported platform.")
#endif

public class GeocodingDarwinPlugin: NSObject, FlutterPlugin {
    var proxyApiRegistrar: ProxyApiRegistrar?
    
    init(binaryMessenger: FlutterBinaryMessenger) {
        proxyApiRegistrar = ProxyApiRegistrar(binaryMessenger: binaryMessenger)
        proxyApiRegistrar?.setUp()
    }
    
    public static func register(with registrar: FlutterPluginRegistrar) {
#if os(iOS)
  let binaryMessenger = registrar.messenger()
#else
  let binaryMessenger = registrar.messenger
#endif
        let plugin = GeocodingDarwinPlugin(binaryMessenger: binaryMessenger)
        registrar.publish(plugin)
    }

    /// VENITI PATCH: quanto tempo o registrar sobrevive ao detach.
    static let detachedRegistrarRetention: TimeInterval = 120

    public func detachFromEngine(for registrar: any FlutterPluginRegistrar) {
        // VENITI PATCH (Crashlytics 86faf374): o codec das respostas e as
        // PigeonApis guardam o registrar como `unowned`. Destruído aqui, uma
        // resposta do CLGeocoder que ainda estava pendente lia o objeto morto e
        // o Swift abortava o app ("Attempted to read an unowned reference").
        // O tearDown continua recusando chamadas novas; só a vida do registrar
        // é estendida para as respostas pendentes terminarem. Remover quando
        // uma versão oficial do geocoding_darwin corrigir o defeito.
        guard let detached = proxyApiRegistrar else { return }
        detached.ignoreCallsToDart = true
        detached.tearDown()
        proxyApiRegistrar = nil
        DispatchQueue.main.asyncAfter(
            deadline: .now() + GeocodingDarwinPlugin.detachedRegistrarRetention
        ) {
            _ = detached
        }
    }
}
