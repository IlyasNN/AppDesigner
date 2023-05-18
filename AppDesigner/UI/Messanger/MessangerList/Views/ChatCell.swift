import SwiftUI

struct ChatCell: View {
    
    var text: String
    var avatarUrl: String
    
    var body: some View {
        HStack {
            AsyncImage(url: URL(string: avatarUrl)!,
                       placeholder: {
                Image("placeholder.photo")
                    .resizable()
                    .frame(width: 50, height: 50)
            })
            .frame(width: 50, height: 50)
            .aspectRatio(contentMode: .fit)
            .clipShape(Circle())
            .overlay(Circle().stroke(.black, lineWidth: 2))
            .scaledToFit()
            
            Text(text)
        }
        .padding(.top, 8)
        .padding(.bottom, 8)
    }
    
}

struct ChatCell_Previews: PreviewProvider {
    static var previews: some View {
        ChatCell(text: "Name", avatarUrl: "https://pixelbox.ru/wp-content/uploads/2021/05/ava-vk-animal-91.jpg")
    }
}
