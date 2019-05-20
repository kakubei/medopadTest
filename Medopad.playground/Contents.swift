import UIKit


enum PieceName: String {
    case tall1, tall2, tall3, tall4
    case fatPiece
    case widePiece
    case normal1, normal2, normal3, normal4
    case empty1, empty2
    case boardPiece
}

enum PieceType {
    case tall, fat, wide, normal, empty, board
    
    var width: Int {
        switch self {
        case .tall:
            return 1
        case .fat:
            return 2
        case .wide:
            return 1
        case .normal:
            return 1
        case .empty:
            return 1
        case .board:
            return 4
        }
    }
    
    var height: Int {
        switch self {
        case .tall:
            return 2
        case .fat:
            return 2
        case .wide:
            return 2
        case .normal:
            return 1
        case .empty:
            return 1
        case .board:
            return 5
        }
    }
}

protocol Griddable {
    var name: PieceName { get }
    var type: PieceType { get }
    var movable: Bool { get }
}

extension Griddable {
    var movable: Bool {
        return true
    }
}

// Pssition properties need to be optionals because we have 1x1 pieces
struct Position {
    let x: Int?
    let y: Int?
    
    init(_ x: Int?, _ y: Int? = nil) {
        self.x = x
        self.y = y
    }
}


// MARK: Typeliases
typealias Region = (Position) -> Bool

//: Instead of defining an object or struct to represent regions, we represent a region by a *function* that determines if a given point is in the region or not

typealias GridNumber = Int

typealias GridSpace = [Position]
typealias GridSpaces = ([Piece]) -> [Position]


// MARK: Piece
struct Piece: Griddable {
    var name: PieceName
    var type: PieceType
    
    init(_ name: PieceName, _ type: PieceType) {
        self.name = name
        self.type = type
    }
}

// MARK: Board
struct Board: Griddable {
    var name: PieceName = .boardPiece
    var type: PieceType = .board
    var movable: Bool = false
    
    var pieces: [Piece] = []
    
    init() {
        setupBoard()
    }
    
    public func move(piece: Piece, to: GridNumber) {
        
    }
    
    mutating private func setupBoard() {
        // MARK: Pieces
        let tall1 = Piece(.tall1, .tall)
        let tall2 = Piece(.tall2, .tall)
        let tall3 = Piece(.tall3, .tall)
        let tall4 = Piece(.tall4, .tall)
        
        let fatPiece = Piece(.fatPiece, .fat)
        let widePiece = Piece(.widePiece, .wide)
        
        let normal1 = Piece(.normal1, .normal)
        let normal2 = Piece(.normal2, .normal)
        let normal3 = Piece(.normal3, .normal)
        let normal4 = Piece(.normal4, .normal)
        
        let empty1 = Piece(.empty1, .empty)
        let empty2 = Piece(.empty2, .empty)
        
        pieces = [
            tall1, fatPiece, tall2,
            tall3, widePiece, tall4,
            normal1, normal2,
            normal3, empty1, empty2, normal4
        ]
    }
    
    // Initial position for each piece
    func initialGridSpace() -> GridSpaces {
        var gridSpaces: GridSpace = []
        
        return { pieces in
            pieces.forEach { piece in
                switch piece.name {
                case .tall1:
                    gridSpaces.append(Position(1,5))
                case .fatPiece:
                    gridSpaces.append(contentsOf: [Position(2,6), Position(3,7)])
                case .tall2:
                    gridSpaces.append(Position(4,8))
                case .tall3:
                    gridSpaces.append(Position(9,13))
                case .widePiece:
                    gridSpaces.append(contentsOf: [Position(10), Position(11)])
                case .tall4:
                    gridSpaces.append(Position(12,16))
                case .normal1:
                    gridSpaces.append(Position(14))
                case .normal2:
                    gridSpaces.append(Position(15))
                case .normal3:
                    gridSpaces.append(Position(17))
                case .normal4:
                    gridSpaces.append(Position(20))
                default:
                    break
                }
            }
            
            return gridSpaces
        }
    }
    
    /* Maps piece to grid spaces it occupies, based on its width and height and position */
    private func  gridSpaces() {
        pieces.forEach { piece in
            let initialPosition = 1 // TODO: Replace this with something valid
            
            let x = initialPosition + piece.type.width
            let y = initialPosition + piece.type.height
            let pieceSpace = [Position(x, y)]
        }
    }
    
    // TODO: Make this functional!
    private func canMove(piece: Piece, to position: Position) -> Bool {
        // 1. can only move if positions are empty
        // 2. if empty, does the piece fit?
        let regionIsEmpty = emptyRegion()
        let pieceFits = fits(piece: piece)
        
        // TODO: Convert Region to Bool

        return false
    }
    
    /*private*/ func emptyRegion() -> Region {
        return { position in
            
            // These need to be true by default, because if they don't exist, we don't care about them
            var emptyX = true
            var emptyY = true
            
            // TODO: Rewrite this, we can't use the index, but using it here just for testing
            if let x = position.x {
                emptyX = self.pieces[x].type == .empty
            }
            if let y = position.y {
                emptyY = self.pieces[y].type == .empty
            }
            
            return emptyX && emptyY
        }
    }
    
    private func fits(piece: Piece) -> Region {
        // true if both width and height are moving to .empty positions
        return { _ in
            self.pieces[piece.type.width].type == .empty &&
            self.pieces[piece.type.height].type == .empty
        }
    }
}

var board = Board()
let spaces = board.initialGridSpace()

let testTall = Piece(.tall1, .tall)
let testEmpty = Piece(.empty1, .empty)

board.pieces = [testTall, testEmpty]

let emptyTest = board.emptyRegion()
print(emptyTest)

if emptyTest { print("Yes, the position is empty") }
