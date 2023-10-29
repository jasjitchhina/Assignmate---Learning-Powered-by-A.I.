import SwiftUI
import FirebaseAuth

struct MakeFlashcardsView: View {
    @StateObject private var viewModel = FlashcardViewModel()
    @State private var isNavigationActive = false
    @EnvironmentObject var flashcardStore: FlashcardStore
    @State private var isScanning = false
    @State private var showScannerSheet = false

    private var buttonStyle: some ButtonStyle {
        ButtonStyleImpl(backgroundColor: .purple, foregroundColor: .white)
    }

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Spacer()

                if !isScanning {
                    ZStack(alignment: .topLeading) {
                        TextEditor(text: $viewModel.inputText)
                            .padding()
                            .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.gray, lineWidth: 1))
                            .font(.title2)

                        if viewModel.inputText.isEmpty {
                            Text("Enter text here")
                                .font(.title2)
                                .foregroundColor(.gray)
                                .padding(.leading)
                                .padding(.top)
                        }
                    }
                    .frame(height: 300) // Adjust the height as needed
                } else {
                    ScannerView { scannedText in
                        if let text = scannedText {
                            viewModel.inputText = text.joined(separator: "\n")
                        }
                        isScanning = false
                    }
                }

                Button(action: {
                    if isScanning {
                        self.showScannerSheet = true
                    } else {
                        viewModel.sendText()
                        if let newSet = viewModel.currentFlashcardSet {
                            flashcardStore.addFlashcardSet(newSet)
                        }
                        isNavigationActive = true
                    }
                }) {
                    Text("Generate Flashcards")
                }
                .buttonStyle(buttonStyle)

                Spacer()

                NavigationLink(
                    destination: FlashcardContentView(viewModel: viewModel),
                    isActive: $isNavigationActive,
                    label: {
                        EmptyView()
                    }
                )
            }
            .padding()
            .navigationBarTitle("Make Flashcards", displayMode: .inline)
            .navigationBarItems(trailing:
                Button(action: {
                    isScanning.toggle()
                }) {
                    Image(systemName: isScanning ? "pencil.circle" : "camera.circle")
                }
                .buttonStyle(buttonStyle)
            )
        }
    }
}

struct ButtonStyleImpl: ButtonStyle {
    var backgroundColor: Color
    var foregroundColor: Color

    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .padding()
            .background(backgroundColor)
            .foregroundColor(foregroundColor)
            .cornerRadius(10)
            .font(.headline)
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
    }
}
