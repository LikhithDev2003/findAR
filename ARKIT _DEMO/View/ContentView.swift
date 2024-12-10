import SwiftUI
import RealityKit

struct ContentView: View {
    @StateObject private var viewModel = GameViewModel()

    var body: some View {
        ZStack {
            // Display ARView from the ViewModel
            if let arView = viewModel.arView {
                ARViewContainer(arView: arView)
                    .edgesIgnoringSafeArea(.all)
            }
            
            VStack {
                Spacer()
                
                // Display the score
                Text("Score: \(viewModel.score)")
                    .font(.largeTitle)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.black.opacity(0.7))
                    .cornerRadius(10)
                
                Spacer()
                    .frame(height: 20)
            }
        }
    }
}

// A UIViewRepresentable to wrap ARView in SwiftUI
struct ARViewContainer: UIViewRepresentable {
    let arView: ARView

    func makeUIView(context: Context) -> ARView {
        return arView
    }

    func updateUIView(_ uiView: ARView, context: Context) {}
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
