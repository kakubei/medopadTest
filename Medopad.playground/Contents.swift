import UIKit

let position: CGPoint = CGPoint(x: 1, y: 2)

enum PieceType {
    case tall, fat, wide, normal, empty, board
}

protocol Griddable {
    var name: PieceType { get }
    var witdh: Int { get }
    var height: Int { get }
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
    var witdh: Int
    var height: Int
    
    var gridSpace: [GridSpace] = []
    
    init(_ name: PieceType, _ width: Int, _ height: Int) {
        self.name = name
        self.witdh = width
        self.height = height
    }
    
    private func setGridSpace() {
        
    }
}

struct Board: Griddable {
    var name: PieceType = .board
    var witdh: Int = 4
    var height: Int = 5
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
            self.pieces[piece.witdh].name == .empty &&
            self.pieces[piece.height].name == .empty
        }
    }
}

// MARK: Pieces
let tall1 = Piece(.tall, 1, 2)
let tall2 = Piece(.tall, 1, 2)
let tall3 = Piece(.tall, 1, 2)
let tall4 = Piece(.tall, 1, 2)

let fat = Piece(.fat, 2, 2)
let wide = Piece(.wide, 2, 1)

let normal1 = Piece(.normal, 1, 1)
let normal2 = Piece(.normal, 1, 1)
let normal3 = Piece(.normal, 1, 1)
let normal4 = Piece(.normal, 1, 1)

let empty1 = Piece(.empty, 1, 1)
let empty2 = Piece(.empty, 1, 1)
