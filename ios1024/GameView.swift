import SwiftUI

struct GameView: View {
    @StateObject var vm: GameViewModel = GameViewModel()
    @State var dir: SwipeDirection? = .none
    
    var body: some View {
        ZStack {
            VStack {
                Text("Welcome to 1024 by Catherine and Blaze").font(.title2)
                Text("Valid Swipes: \(vm.validSwipesCount)")
                Text("Game Status: \(vm.gameStatus)")
                
                NumberGrid(grid: vm.grid)
                    .gesture(DragGesture(minimumDistance: 40).onEnded{
                        dir = determineSwipeDirection($0)
                        vm.handleSwipe(dir!)
                    })
                    .padding()
                
                Button("Reset Game") {
                    vm.resetGame()
                }
                .padding()
                
                if let dir {
                    Text("You swiped \(dir)")
                }
            }
            .frame(maxHeight: .infinity, alignment: .top)
            
            // Overlay win/lose message on top of the screen
            if vm.gameStatus == "WIN" || vm.gameStatus == "LOSE" {
                VStack {
                    Spacer()
                    
                    Text(vm.gameStatus == "WIN" ? "You Won" : "You Lost")
                        .font(.headline)
                        .foregroundColor(vm.gameStatus == "WIN" ? .green : .red)
                        .bold()
                        .padding()
                    
                    Spacer()
                    
                    // Reset Button inside the overlay
                    Button("Reset Game") {
                        vm.resetGame() // Reset the game logic
                    }
                    .font(.title3)
                    .padding()
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .shadow(radius: 5)
                    
                    Spacer()
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.white.opacity(0.8))
                .cornerRadius(10)
                .padding(40)
                .shadow(radius: 10)
                .transition(.opacity)
                .zIndex(1)
            }
        }
    }
}

struct NumberGrid: View {
    let grid: [[Int]]
    let size: Int = 4
    
    var body: some View {
        VStack(spacing: 4) {
            ForEach(0..<size, id: \.self) { row in
                HStack(spacing: 4) {
                    ForEach(0..<size, id: \.self) { col in
                        let cellValue = grid[row][col]
                        Text(cellValue == 0 ? "" : "\(cellValue)")
                            .font(.system(size: 24))
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .aspectRatio(CGSize(width: 1, height: 1), contentMode: .fit)
                            .background(cellColor(for: cellValue))
                            .cornerRadius(8)
                    }
                }
            }
        }
        .padding(4)
        .background(Color.gray)
    }
    
    func cellColor(for value: Int) -> Color {
        switch value {
        case 0: return .white
        case 2: return .yellow
        case 4: return .orange
        case 8: return .red
        case 16: return .green
        case 32: return .blue
        case 64: return .purple
        default: return .gray
        }
    }
}

func determineSwipeDirection(_ swipe: DragGesture.Value) -> SwipeDirection {
    if abs(swipe.translation.width) > abs(swipe.translation.height) {
        return swipe.translation.width < 0 ? .left : .right
    } else {
        return swipe.translation.height < 0 ? .up : .down
    }
}

