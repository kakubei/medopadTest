import UIKit
import XCTest

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
            return 2
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
            return 1
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

struct Position {
    let x: Int
    let y: Int
    
    init(_ x: Int, _ y: Int) {
        self.x = x
        self.y = y
    }
}

extension Position: Equatable {
    static func ==(lhs: Position, rhs: Position) -> Bool {
        return lhs.x == rhs.x && lhs.y == rhs.y
    }
}


// MARK: Typeliases
//typealias Region = (Position) -> Bool

//: Instead of defining an object or struct to represent regions, we represent a region by a *function* that determines if a given point is in the region or not

typealias GridSpace = [Position]
typealias GridSpaces = ([Piece]) -> [Position]


// MARK: Piece
struct Piece: Griddable {
    var name: PieceName
    var type: PieceType
    var position = Position(0,0) // 0,0 means not on the board
    
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
    
    enum Direction {
        case right, left, down, up
    }
    
    let minPosion = Position(1,1)
    let maxPosition = Position(4,5)
    
    init() {
        setupBoard()
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
        
        initialPiecesPosition()
    }
    
    // Initial position for each piece
    mutating func initialPiecesPosition() {
        
        pieces.forEach { piece in
            guard let pieceIndex = (pieces.firstIndex() { $0.name == piece.name }) else { return }
            
            switch piece.name {
            case .tall1:
                pieces[pieceIndex].position = Position(1,1)
            case .fatPiece:
                pieces[pieceIndex].position = Position(2,1)
            case .tall2:
                pieces[pieceIndex].position = Position(4,1)
            case .tall3:
                pieces[pieceIndex].position = Position(1,3)
            case .widePiece:
                pieces[pieceIndex].position = Position(2,3)
            case .tall4:
                pieces[pieceIndex].position = Position(4,3)
            case .normal1:
                pieces[pieceIndex].position = Position(2,4)
            case .normal2:
                pieces[pieceIndex].position = Position(3,4)
            case .normal3:
                pieces[pieceIndex].position = Position(1,5)
            case .normal4:
                pieces[pieceIndex].position = Position(4,5)
            case .empty1:
                pieces[pieceIndex].position = Position(2,5)
            case .empty2:
                pieces[pieceIndex].position = Position(3,5)
            default:
                break
            }
        }
    }
    
    // WARNING: Needs implementation
    public func moveRight(for piece: Piece) -> Bool {
        return false
    }
    
    // WARNING: Needs implementation
    public func moveLeft(for piece: Piece) -> Bool {
        return false
    }
    
    // WARNING: Needs implementation
    public func moveDown(for piece: Piece) -> Bool {
        return false
    }
    
    // WARNING: Needs implementation
    public func moveUp(for piece: Piece) -> Bool {
        return false
    }
    
    // TODO: Make this functional!
    internal func canMove(piece: Piece, to position: Position) -> Bool {
        // 1. can only move if positions are empty
        // 2. if empty, does the piece fit?
        let positionIsEmpty = isEmpty(position: position)
        
        // No need to keep going to iterate through whether the piece fits, space is not empty so return false immediately
        if !positionIsEmpty {
            return false
        }
        
        let pieceFits = fits(piece: piece, in: position)
        
        return positionIsEmpty && pieceFits
    }
    
    private func shiftPosition(_ position: Position, to direction: Direction) -> Position {
        switch direction {
        case .right:
            return Position(position.x + 1, position.y)
        case .left:
            return Position(position.x - 1, position.y)
        case .down:
            return Position(position.x, position.y + 1)
        case .up:
            return Position(position.x, position.y - 1)
        }
    }
    
    // TODO: Make this functional
    //... we could throw an error if position is invalid or out of bounds
    //... but the outcome of it not being empty is the same, really: can't move into it
    internal func isEmpty(position: Position) -> Bool {
        guard let piece = (pieces.filter { $0.position == position }.first) else {
            return false
        }
        
        return piece.type == .empty
    }
    
    
    internal func fits(piece: Piece, in newPosition: Position) -> Bool {
        var potentialPiece = piece
        potentialPiece.position = newPosition
        let gridSpace = gridSpaces(for: potentialPiece)
        
        return gridSpace.allSatisfy { newPosition in
            isEmpty(position: newPosition)
        }
    }

    /* Maps piece to grid spaces it occupies, based on its width and height and position */
    internal func  gridSpaces(for piece: Piece) -> GridSpace {
        var gridSpace = [Position(piece.position.x, piece.position.y)]
        
        let extraX = piece.type.width > 1 ? piece.position.x + 1 : piece.position.x
        let extraY = piece.type.height > 1 ? piece.position.y + 1 : piece.position.y
        
        // TODO: Better, more succinct code below?
        
        let hasExtraX = extraX != piece.position.x
        let hasExtraY = extraY != piece.position.y
        
        if hasExtraX {
            gridSpace.append(Position(extraX, piece.position.y))
        }
        
        if hasExtraY {
            gridSpace.append(Position(piece.position.x, extraY))
        }
        
        if hasExtraX && hasExtraY {
            gridSpace.append(Position(extraX, extraY))
        }
        
        return gridSpace
    }
}

let board = Board()

class Tests: XCTestCase {
   
    let board = Board()
    
    // MARK: Initial pieces position
    func testTall1GridSpace() {
        let tall1 = try! pieceFromArray(for: .tall1)
        testDimesions(for: tall1)
        
        let pieceSpace = board.gridSpaces(for: tall1)
        let expectedSpace = [Position(1,1), Position(1,2)]
        XCTAssertEqual(pieceSpace, expectedSpace, "wrong grid space for piece")
    }
    
    func testTall2GridSpace() {
        let tall2 = try! pieceFromArray(for: .tall2)
        testDimesions(for: tall2)
        
        let pieceSpace = board.gridSpaces(for: tall2)
        let expectedSpace = [Position(4,1), Position(4,2)]
        XCTAssertEqual(pieceSpace, expectedSpace, "Wrong grid space for piece")
    }
    
    func testFatPieceGridSpace() {
        let fatPiece = try! pieceFromArray(for: .fatPiece)
        testDimesions(for: fatPiece)
        
        let pieceSpace = board.gridSpaces(for: fatPiece)
        let expectedSpace = [Position(2,1), Position(3,1), Position(2,2), Position(3,2)]
        XCTAssertEqual(pieceSpace, expectedSpace, "Wrong grid space for piece")
    }
    
    func testTall3GridSpace() {
        let tall3 = try! pieceFromArray(for: .tall3)
        testDimesions(for: tall3)
        
        let pieceSpace = board.gridSpaces(for: tall3)
        let expectedSpace = [Position(1,3), Position(1,4)]
        XCTAssertEqual(pieceSpace, expectedSpace, "Wrong grid space for piece")
    }
    
    func testWidePieceGridSpace() {
        let widePiece = try! pieceFromArray(for: .widePiece)
        testDimesions(for: widePiece)
        
        let pieceSpace = board.gridSpaces(for: widePiece)
        let expectedSpace = [Position(2,3), Position(3,3)]
        XCTAssertEqual(pieceSpace, expectedSpace, "Wrong grid space for piece")
    }
    
    func testNormal1GridSpace() {
        let normal1 = try! pieceFromArray(for: .normal1)
        testDimesions(for: normal1)
        
        let pieceSpace = board.gridSpaces(for: normal1)
        let expectedSpace = [Position(2,4)]
        XCTAssertEqual(pieceSpace, expectedSpace, "Wrong grid space for piece")
    }
    
    func testNormal2GridSpace() {
        let normal2 = try! pieceFromArray(for: .normal2)
        testDimesions(for: normal2)
        
        let pieceSpace = board.gridSpaces(for: normal2)
        let expectedSpace = [Position(3,4)]
        XCTAssertEqual(pieceSpace, expectedSpace, "Wrong grid space for piece")
    }
    
    func testNormal3GridSpace() {
        let normal3 = try! pieceFromArray(for: .normal3)
        testDimesions(for: normal3)
        
        let pieceSpace = board.gridSpaces(for: normal3)
        let expectedSpace = [Position(1,5)]
        XCTAssertEqual(pieceSpace, expectedSpace, "Wrong grid space for piece")
    }
    
    func testNormal4GridSpace() {
        let normal4 = try! pieceFromArray(for: .normal4)
        testDimesions(for: normal4)
        
        let pieceSpace = board.gridSpaces(for: normal4)
        let expectedSpace = [Position(4,5)]
        XCTAssertEqual(pieceSpace, expectedSpace, "Wrong grid space for piece")
    }
    
    func testEmptyGridSpace() {
        let empty1 = try! pieceFromArray(for: .empty1)
        let empty2 = try! pieceFromArray(for: .empty2)
        
        let empty1Space = board.gridSpaces(for: empty1)
        let empty2Space = board.gridSpaces(for: empty2)
        
        let empty1ExpectedSpace = [Position(2,5)]
        let empty2ExpectedSpace = [Position(3,5)]
        
        XCTAssertEqual(empty1Space, empty1ExpectedSpace)
        XCTAssertEqual(empty2Space, empty2ExpectedSpace)
    }
    
    func testInitialEmpties() {
        let shouldBeEmpty1 = board.isEmpty(position: Position(2,5))
        let shouldBeEmtpy2 = board.isEmpty(position: Position(3,5))
        
        XCTAssertTrue(shouldBeEmpty1)
        XCTAssertTrue(shouldBeEmtpy2)
    }
    
    func testNotEmpty() {
        let fatPiece = try! pieceFromArray(for: .fatPiece)
        let pieceSpace = board.gridSpaces(for: fatPiece)
        XCTAssertFalse(board.isEmpty(position: fatPiece.position))
        
        let fatSpacesEmpty = pieceSpace.allSatisfy { board.isEmpty(position: $0) }
        XCTAssertFalse(fatSpacesEmpty)
    }
    
    func testShouldFit() {
        let normal1 = try! pieceFromArray(for: .normal1)
        let newPosition = Position(2,5)
        XCTAssertTrue(board.fits(piece: normal1, in: newPosition))
    }
    
    func testShouldNotFit() {
        let fatPiece = try! pieceFromArray(for: .fatPiece)
        let newPosition = Position(2,3)
        XCTAssertFalse(board.fits(piece: fatPiece, in: newPosition))
    }
    
    func testShouldMove() {
        let normal1 = try! pieceFromArray(for: .normal1)
        let newPosition = Position(2,5)
        XCTAssertTrue(board.canMove(piece: normal1, to: newPosition))
    }
    
    func testShouldNotMove() {
        let normal1 = try! pieceFromArray(for: .normal1)
        let newPosition = Position(1,3)
        XCTAssertFalse(board.canMove(piece: normal1, to: newPosition))
    }
    
    func testEmptyRegion() {
        let emptySpace = board.gridSpaces(for: try! pieceFromArray(for: .empty1))
        
        
    }
    
    
    //: ------------------------------
    
    // MARK: Test Helpers
    
    enum CustomError: Error {
        case badPieceName
    }
    
    func pieceFromArray(for name: PieceName) throws -> Piece {
        guard let pieceIndex = (board.pieces.firstIndex { $0.name == name }) else {
            throw CustomError.badPieceName
        }
        
        return board.pieces[pieceIndex]
    }
    
    func testDimesions(for piece: Piece) {
        var expectedWidth: Int = 0
        var expectedHeight: Int = 0
        
        switch piece.type {
        case .tall:
            expectedWidth = 1
            expectedHeight = 2
        case .fat:
            expectedWidth = 2
            expectedHeight = 2
        case .wide:
            expectedWidth = 2
            expectedHeight = 1
        case .normal:
            expectedWidth = 1
            expectedHeight = 1
        case .empty:
            expectedWidth = 1
            expectedHeight = 1
        default:
            print("nothing to do")
        }
        
        XCTAssertEqual(piece.type.width, expectedWidth, "Incorrect width")
        XCTAssertEqual(piece.type.height, expectedHeight, "Incorrect height")
        
    }
    
}

Tests.defaultTestSuite.run()

