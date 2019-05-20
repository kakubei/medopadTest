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
    
    init(_ x: Int?, _ y: Int?) {
        self.x = x
        self.y = y
    }
}

typealias Region = (Position) -> Bool

typealias GridNumber = Int

typealias GridSpace = [Position]


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
        
        // normal1 and 2 are between the descendant of tall3 and 4
        let initialPiecesPosition = [
            tall1, fatPiece, tall2,
            tall3, widePiece, tall4,
            normal1, normal2,
            normal3, empty1, empty2, normal4
        ]
        
        pieces = initialPiecesPosition
    }
    
    /* Maps piece to grid spaces it occupies, based on its width and height and position */
    private func  gridSpaces() {
        
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
    
    private func gridSpace(for piece: Piece) {
        guard let gridCoordinates: Int = (pieces.firstIndex { $0.name == piece.name }) else {
            return
        }
        
        
    }
    
    private func emptyRegion() -> Region {
        return { point in
            
            // These need to be true by default, because if they don't exist, we don't care about them
            var emptyX = true
            var emptyY = true
            
            if let x = point.x {
                emptyX = self.pieces[x].type == .empty
            }
            if let y = point.y {
                emptyY = self.pieces[y].type == .empty
            }
            
            return emptyX && emptyY
        }
//        return { position in false }
    }
    
    private func fits(piece: Piece) -> Region {
        // true if both width and height are moving to .empty positions
        return { _ in
            self.pieces[piece.type.width].type == .empty &&
            self.pieces[piece.type.height].type == .empty
        }
    }
}



let board = Board()
