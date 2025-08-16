import SwiftUI

struct DevMenuRNDevMenu: View {
  let onOpenRNDevMenu: () -> Void

  var body: some View {
    Button {
      onOpenRNDevMenu()
    } label: {
      HStack {
        Text("Open React Native dev menu")
          .foregroundColor(.primary)
        Spacer()
      }
      .padding()
    }
    .background(Color.expoSystemColors.secondarySystemBackground.color)
    .cornerRadius(18)
  }
}

#Preview {
  DevMenuRNDevMenu {}
}
