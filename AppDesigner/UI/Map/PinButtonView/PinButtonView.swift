import SwiftUI

struct PinButtonView: View {
    
    @StateObject var router: MapRouter
    @ObservedObject var viewModel: PinButtonViewModel
    
    var body: some View {
        Button(action: {
            router.navigateToMapPinInfoScreen.toggle()
        }) {
            VStack(spacing: 0) {
                Image(systemName: "pin.circle.fill")
                    .padding()
                    .foregroundColor(Color(RemoteConfigManager.shared.primaryColor))
                    .font(.title)
                Text(viewModel.pin.name)
            }
        }
        .sheet(isPresented: $router.navigateToMapPinInfoScreen,
               content: {
            MapPinInfoScreen(router: router,
                             pin: viewModel.pin)
        })
    }
}

struct PinButtonView_Previews: PreviewProvider {
    static var previews: some View {
        PinButtonView(router: MapRouter(),
                      viewModel: PinButtonViewModel(pin: MapPinModel(name: "Name",
                                                                     description: "Desc",
                                                                     longitude: 0.0,
                                                                     latitude: 0.0)))
    }
}
