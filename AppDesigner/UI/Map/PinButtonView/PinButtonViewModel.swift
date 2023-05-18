import Foundation

class PinButtonViewModel: ObservableObject {
    
    @Published var pin: MapPinModel
    
    init(pin: MapPinModel) {
        self.pin = pin
    }
    
}
