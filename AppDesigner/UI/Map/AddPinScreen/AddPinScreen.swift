import SwiftUI

struct AddPinScreen: View {
    
    @StateObject var router: MapRouter
    @ObservedObject var viewModel: AddPinViewModel
    
    @State var showActionSheet = false
    @State var showImagePicker = false
    @State var sourceType:UIImagePickerController.SourceType = .camera
    @State var showValidationAlert = false
    
    var body: some View {
        NavigationView {
            
            VStack(alignment: .leading) {
                
                DefaultTextfield(title: "Name", value: $viewModel.name)
                DefaultTextfield(title: "Description", value: $viewModel.description)
                    
                Text("Photo")
                    .font(.headline)
                    .fontWeight(.light)
                    .foregroundColor(Color.init(.label).opacity(0.75))
                Button(action: {
                    self.showActionSheet = true
                }, label: {
                    Image(uiImage: viewModel.image ?? UIImage(named: "placeholder.photo")!)
                        .resizable()
                        .scaledToFit()
                })
                .actionSheet(isPresented: $showActionSheet) {
                    ActionSheet(title: Text("Add a picture to your post"), message: nil, buttons: [
                        
                        .default(Text("Camera"), action: {
                            self.showImagePicker = true
                            self.sourceType = .camera
                        }),
                        .default(Text("Photo Library"), action: {
                            self.showImagePicker = true
                            self.sourceType = .photoLibrary
                        }),
                        
                        .cancel()
                        
                    ])
                }.sheet(isPresented: $showImagePicker) {
                    ImagePicker(image: self.$viewModel.image,
                                showImagePicker: self.$showImagePicker,
                                sourceType: self.sourceType)
                    
                }
                
                HStack {
                    Spacer()
                    Text("Tap on image to add photo")
                    Spacer()
                }
                
                Spacer()
                
            }
            .padding(.horizontal, 6)
            .padding()
            
            .navigationBarItems(leading: Button {
                router.navigateToAddPinScreen = false
            } label: {
                Text("Cancel")
                    .foregroundColor(.white)
            }, trailing: Button {
                guard !viewModel.name.isEmpty && !viewModel.description.isEmpty else {
                    showValidationAlert = true
                    return
                }
                viewModel.saveNewPinToFirebase()
                router.navigateToAddPinScreen = false
            } label: {
                Text("Save")
                    .foregroundColor(.white)
            }
                                
            )
            .navigationBarTitle("Add location", displayMode: .inline)
            .navigationBarColor(backgroundColor: UIColor(hex: RemoteConfigManager.shared.primaryColor),
                                titleColor: .white)
            .alert(isPresented: $showValidationAlert) {
                Alert(
                    title: Text("Error"),
                    message: Text("Fill all of the fields")
                )
            }.padding()
        }
    }
}

struct AddPinScreen_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = AddPinViewModel(firestoreManager: FirestoreManager.shared,
                                        latitude: 0.0,
                                        longitude: 0.0)
        AddPinScreen(router: MapRouter(),
                     viewModel: viewModel)
    }
}
