import UIKit

let position: CGPoint = CGPoint(x: 1, y: 2)

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
    var name: PieceType { get }
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

typealias GridSpace = Int

struct Piece: Griddable {
    var name: PieceType
    var gridSpace: [GridSpace] = []
    
    init(_ name: PieceType) {
        self.name = name
        setGridSpace()
    }
    
    private func setGridSpace() {
        /*
         1. from its origin (top left)...
         2. based on its type...
         3. add X or Y to the grid
         4. account for the origin as well
        */
        
        
    }
}

struct Board: Griddable {
    var name: PieceType = .board
    var movable: Bool = false
    
    var pieces: [Piece] = []
    
    init(pieces: [Piece]) {
        self.pieces = pieces
    }
    
    public func move(piece: Piece, to: Position) {
        
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
    
    private func emptyRegion() -> Region {
        return { point in
            
            // These need to be true by default, because if they don't exist, we don't care about them
            var emptyX = true
            var emptyY = true
            
            if let x = point.x {
                emptyX = self.pieces[x].name == .empty
            }
            if let y = point.y {
                emptyY = self.pieces[y].name == .empty
            }
            
            return emptyX && emptyY
        }
//        return { position in false }
    }
    
    private func fits(piece: Piece) -> Region {
        // true if both width and height are moving to .empty positions
        return { _ in
            self.pieces[piece.name.width].name == .empty &&
            self.pieces[piece.name.height].name == .empty
        }
    }
}

// MARK: Pieces
let tall1 = Piece(.tall)
let tall2 = Piece(.tall)
let tall3 = Piece(.tall)
let tall4 = Piece(.tall)

let fat = Piece(.fat)
let wide = Piece(.wide)

let normal1 = Piece(.normal)
let normal2 = Piece(.normal)
let normal3 = Piece(.normal)
let normal4 = Piece(.normal)

let empty1 = Piece(.empty)
let empty2 = Piece(.empty)
