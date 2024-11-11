import Foundation

class GameViewModel: ObservableObject {
    @Published var grid: [[Int]] = Array(repeating: Array(repeating: 0, count: 4), count: 4)
    @Published var validSwipesCount: Int = 0
    @Published var gameStatus: String = "Playing"
    
    init() {
        resetGame()
    }
    
    func resetGame() {
        grid = Array(repeating: Array(repeating: 0, count: 4), count: 4)
        validSwipesCount = 0
        gameStatus = "Playing"
        addNewNumber()
    }
    
    func handleSwipe(_ dir: SwipeDirection) {
        let oldGrid = grid
        moveAndMerge(in: dir)
        if grid != oldGrid {
            validSwipesCount += 1
            addNewNumber()
            checkGameStatus()
        }
    }
    
    private func moveAndMerge(in direction: SwipeDirection) {
        switch direction {
        case .left:
            for i in 0..<4 {
                grid[i] = mergeRow(grid[i])
            }
        case .right:
            for i in 0..<4 {
                grid[i] = mergeRow(grid[i].reversed()).reversed()
            }
        case .up:
            for i in 0..<4 {
                var column = [grid[0][i], grid[1][i], grid[2][i], grid[3][i]]
                column = mergeRow(column)
                for j in 0..<4 {
                    grid[j][i] = column[j]
                }
            }
        case .down:
            for i in 0..<4 {
                var column = [grid[0][i], grid[1][i], grid[2][i], grid[3][i]]
                column = mergeRow(column.reversed()).reversed()
                for j in 0..<4 {
                    grid[j][i] = column[j]
                }
            }
        }
    }
    
    private func mergeRow(_ row: [Int]) -> [Int] {
        var newRow = row.filter { $0 != 0 }
        var i = 0
        while i < newRow.count - 1 {
            if newRow[i] == newRow[i + 1] {
                newRow[i] *= 2
                newRow.remove(at: i + 1)
            }
            i += 1
        }
        while newRow.count < 4 {
            newRow.append(0)
        }
        return newRow
    }
    
    private func addNewNumber() {
        var emptySpots = [(Int, Int)]()
        for i in 0..<4 {
            for j in 0..<4 {
                if grid[i][j] == 0 {
                    emptySpots.append((i, j))
                }
            }
        }
        if let (i, j) = emptySpots.randomElement() {
            grid[i][j] = [2, 4].randomElement()!
        }
    }
    
    private func checkGameStatus() {
        if grid.flatMap({ $0 }).contains(1024) {
            gameStatus = "WIN"
        } else if !canMove() {
            gameStatus = "LOSE"
        }
    }
    
    private func canMove() -> Bool {
        for i in 0..<4 {
            for j in 0..<4 {
                if grid[i][j] == 0 {
                    return true
                }
                if i < 3 && grid[i][j] == grid[i + 1][j] {
                    return true
                }
                if j < 3 && grid[i][j] == grid[i][j + 1] {
                    return true
                }
            }
        }
        return false
    }
}
