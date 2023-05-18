import Foundation
import SwiftUI

class MapRouter: ObservableObject {
    
    @Published var navigateToAddPinScreen: Bool = false
    @Published var navigateToMapPinInfoScreen: Bool = false
    
    @ViewBuilder func mapScreen() -> some View {
        let viewModel = MapViewModel(locationManager: LocationManager.shared,
                                     firestoreManager: FirestoreManager.shared,
                                     remoteConfigManager: RemoteConfigManager.shared)
        MapScreen(router: self,
                  viewModel: viewModel)
    }
    
    @ViewBuilder func addPinScreen(latitude: Double, longitude: Double) -> some View {
        let viewModel = AddPinViewModel(firestoreManager: FirestoreManager.shared,
                                        latitude: latitude,
                                        longitude: longitude)
        AddPinScreen(router: self, viewModel: viewModel)
    }
    
    @ViewBuilder func pinButtonView(pin: MapPinModel) -> some View {
        let viewModel = PinButtonViewModel(pin: pin)
        PinButtonView(router: self,
                      viewModel: viewModel)
    }
    
}

struct MapRouterView: View {
    
    var router: MapRouter
    
    var body: some View {
        NavigationView {
            self.router.mapScreen()
                .navigationTitle("Map")
                .navigationBarColor(backgroundColor: UIColor(hex: RemoteConfigManager.shared.primaryColor),
                                    titleColor: .white)
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}
