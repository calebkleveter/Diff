import XCTest
@testable import Diff

final class DiffTests: XCTestCase {
    func testUniverseWorks() {
        XCTAssert(true)
    }

    func testGetSet() throws {
        var diff = try Diff(User.self)

        XCTAssertEqual(diff.firstName, .unchanged)
        diff.firstName = .update("Homer")
        XCTAssertEqual(diff.firstName, .update("Homer"))

        XCTAssertEqual(diff.lastName, .unchanged)
        diff.lastName = .update("Finnley")
        XCTAssertEqual(diff.lastName, .update("Finnley"))
    }

    func testInit() throws {
        let diff = try Diff<User>([\.firstName ~ "Caleb", \.lastName ~ "Kleveter", \.guest ~ false])

        XCTAssertEqual(diff.firstName, .update("Caleb"))
        XCTAssertEqual(diff.lastName, .update("Kleveter"))
        XCTAssertEqual(diff.guest, .update(false))
        XCTAssertEqual(diff.age, .unchanged)
        XCTAssertEqual(diff.password, .unchanged)
    }

    @available(OSX 10.13, *)
    func testDiffEncoding() throws {
        var diff = try Diff(User.self)
        diff.firstName = .update("Caleb")
        diff.lastName = .update("Kleveter")
        diff.guest = .update(false)

        let encoder = JSONEncoder()
        encoder.outputFormatting = [.sortedKeys, .prettyPrinted]

        let data = try encoder.encode(diff)
        let json = String(decoding: data, as: UTF8.self)

        let expected = """
        {
          "firstName" : "Caleb",
          "guest" : false,
          "lastName" : "Kleveter"
        }
        """

        XCTAssertEqual(json, expected)
    }

    func testDiffDecoding() throws {
        let json = """
        {
          "firstName" : "Caleb",
          "guest" : false,
          "lastName" : "Kleveter"
        }
        """
        let data = Data(json.utf8)

        let diff = try JSONDecoder().decode(Diff<User>.self, from: data)
        XCTAssertEqual(diff.firstName, .update("Caleb"))
        XCTAssertEqual(diff.lastName, .update("Kleveter"))
        XCTAssertEqual(diff.guest, .update(false))
        XCTAssertEqual(diff.age, .unchanged)
        XCTAssertEqual(diff.password, .unchanged)
    }

    func testApply() throws {
        var diff = try Diff(User.self)
        diff.firstName = .update("Caleb")
        diff.lastName = .update("Kleveter")
        diff.guest = .update(false)

        var user = User(firstName: "Homer", lastName: "Finnley", age: 36, password: "youSHALLnotPASS", guest: true)
        try diff.apply(to: &user)

        XCTAssertEqual(user.firstName, "Caleb")
        XCTAssertEqual(user.lastName, "Kleveter")
        XCTAssertEqual(user.age, 36)
        XCTAssertEqual(user.password, "youSHALLnotPASS")
        XCTAssertEqual(user.guest, false)
    }
}

struct User: Codable {
    var firstName: String
    var lastName: String
    var age: Int
    var password: String
    var guest: Bool
}
