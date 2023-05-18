import SwiftUI
import MapKit

struct CircleButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .frame(width: 50, height: 50)
            .foregroundColor(Color.black)
            .background(Color(RemoteConfigManager.shared.primaryColor))
            .clipShape(Circle())
    }
}

struct MapScreen: View {
    
    @StateObject var router: MapRouter
    @ObservedObject var viewModel: MapViewModel
    
    @State private var mapRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0),
                                                      span: MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2))
    @State var tracking: MapUserTrackingMode = .follow
    @State var addingPin = false
    
    var body: some View {
        
        ZStack {
            Map(coordinateRegion: $mapRegion,
                interactionModes: MapInteractionModes.all,
                showsUserLocation: true,
                userTrackingMode: $tracking,
                annotationItems: viewModel.mapPinModels,
                annotationContent: { pin in
                MapAnnotation(coordinate: CLLocationCoordinate2D(latitude: pin.latitude,
                                                                 longitude: pin.longitude),
                              content: {
                    router.pinButtonView(pin: pin)
                })
            })
            
            Group {
                
                if addingPin {
                    
                    Button {
                        addingPin = false
                    } label: {
                        Text("Cancel")
                            .padding(10)
                            .foregroundColor(.white)
                            .background(Color(RemoteConfigManager.shared.primaryColor))
                            .cornerRadius(200)
                        
                    }
                    .frame(maxWidth: .infinity,
                           maxHeight: .infinity,
                           alignment: .topTrailing)
                    .padding(20)

                    Image(systemName: "mappin.and.ellipse")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 40, height: 40)
                        .foregroundColor(.red)
                }
                
                HStack {
                    
                    Button(action: {
                        updateRegion()
                    }) {
                        Image(systemName: "location.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .foregroundColor(.white)
                            .frame(width: 25, height: 25)
                    }
                    .buttonStyle(CircleButtonStyle())
                    
                    Spacer()
                    
                    if viewModel.addPinsIsOn {
                        Button(action: {
                            if addingPin {
                                router.navigateToAddPinScreen = true
                            }
                            addingPin.toggle()
                        }) {
                            Image(systemName: addingPin ? "pin" : "plus")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .foregroundColor(.white)
                                .frame(width: 25, height: 25)
                        }
                        .buttonStyle(CircleButtonStyle())
                    }
                    
                }
                .frame(maxHeight: .infinity, alignment: .bottom)
                .padding(20)
                
            }
        }
        
        .sheet(isPresented: $router.navigateToAddPinScreen) {
            router.addPinScreen(latitude: mapRegion.center.latitude, longitude: mapRegion.center.longitude)
        }
        
        .onAppear {
            mapRegion = MKCoordinateRegion(center: viewModel.currentLocation,
                                           span: MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2))
        }
    }
    
    private func updateRegion() {
        mapRegion = MKCoordinateRegion(center: viewModel.currentLocation,
                                       span: MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2))
    }
    
}

struct MapScreen_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = MapViewModel(locationManager: LocationManager.shared,
                                     firestoreManager: FirestoreManager.shared,
                                     remoteConfigManager: RemoteConfigManager.shared)
        MapScreen(router: MapRouter(), viewModel: viewModel)
    }
}
