import SwiftUI

public struct Route: Hashable {
    private let id: AnyHashable
    fileprivate let buildView: () -> AnyView
    
    // The initializer takes any Hashable ID and a ViewBuilder closure
    public init<T: Hashable, V: View>(id: T, @ViewBuilder view: @escaping () -> V) {
        self.id = id
        self.buildView = { AnyView(view()) }
    }
    
    public static func == (lhs: Route, rhs: Route) -> Bool {
        lhs.id == rhs.id
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

@Observable
public class Router {
    public var path: [Route] = [] 
    
    public init() {}
    
    public func navigate(to route: Route) {
        path.append(route)
    }
    
    public func pop() {
        if !path.isEmpty { path.removeLast() }
    }
    
    public func popToRoot() {
        path.removeAll()
    }
}

public extension View {
    func usingRouter(_ router: Router) -> some View {
        NavigationStack(path: Bindable(router).path) {
            self
                .navigationDestination(for: Route.self) { route in
                    route.buildView()
                }
        }
        .environment(router)
        .environment(\.router, router)
    }
}

private struct RouterEnvironmentKey: EnvironmentKey {
    nonisolated(unsafe) static let defaultValue = Router()
}

public extension EnvironmentValues {
    var router: Router {
        get { self[RouterEnvironmentKey.self] }
        set { self[RouterEnvironmentKey.self] = newValue }
    }
}
