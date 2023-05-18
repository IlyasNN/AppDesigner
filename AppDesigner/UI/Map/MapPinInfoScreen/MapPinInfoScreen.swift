import SwiftUI

struct MapPinInfoScreen: View {
    
    @StateObject var router: MapRouter

    @State var pin: MapPinModel

    var body: some View {
        NavigationView {
            
            List {
                Section(header: Text("Description")) {
                    Text(pin.description)
                }
                
                if let url = pin.photoUrl,
                   !url.isEmpty {
                    AsyncImage(url: URL(string: url)!,
                               placeholder: {
                        Image("placeholder.photo")
                            .resizable()
                            .scaledToFit()
                        //                            .frame(width: 50, height: 50)
                    })
                    .scaledToFit()
                }
                
            }
            
            .navigationBarItems(leading: Button {
                router.navigateToMapPinInfoScreen = false
            } label: {
                Text("Back")
                    .foregroundColor(.white)
            })
            .navigationBarTitle(pin.name, displayMode: .inline)
            .navigationBarColor(backgroundColor: UIColor(hex: RemoteConfigManager.shared.primaryColor),
                                titleColor: .white)
        }
    }
    
}

struct MapPinInfoScreen_Previews: PreviewProvider {
    static var previews: some View {
        MapPinInfoScreen(router: MapRouter(),
                         pin: MapPinModel(name: "Name",
                                          description: "Desc",
                                          longitude: 0.0,
                                          latitude: 0.0))
    }
}
