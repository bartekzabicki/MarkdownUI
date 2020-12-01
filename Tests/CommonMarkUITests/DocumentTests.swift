import CommonMarkUI
import XCTest

final class DocumentTests: XCTestCase {
    func testEquatable() {
        // given
        let a = Document("# Hello")
        let b = Document("Lorem *ipsum*")
        let c = a
        let d = Document("Lorem _ipsum_")

        // then
        XCTAssertNotEqual(a, b)
        XCTAssertEqual(a, c)
        XCTAssertEqual(b, d)
    }

    func testLosslessConversion() {
        // given
        let text = "# __Hello__ *world*\n"
        let expected = "# **Hello** *world*\n"

        // when
        let result = Document(text)?.description

        // then
        XCTAssertEqual(result, expected)
    }

    func testBlockQuote() {
        // given
        let text = """
          >Hello
          >>World
        """
        let expected: [Document.Block] = [
            .blockQuote([
                .paragraph([.text("Hello")]),
                .blockQuote([
                    .paragraph([.text("World")]),
                ]),
            ]),
        ]

        // when
        let result = Document(text)?.blocks

        // then
        XCTAssertEqual(result, expected)
    }

    func testList() {
        // given
        let text = """
           1. one
           1. two
              - nested 1
              - nested 2
        """
        let expected: [Document.Block] = [
            .list(
                [
                    [.paragraph([.text("one")])],
                    [
                        .paragraph([.text("two")]),
                        .list(
                            [
                                [.paragraph([.text("nested 1")])],
                                [.paragraph([.text("nested 2")])],
                            ],
                            style: .bullet
                        ),
                    ],
                ],
                style: .ordered
            ),
        ]

        // when
        let result = Document(text)?.blocks

        // then
        XCTAssertEqual(result, expected)
    }

    func testCode() {
        // given
        let text = """
           ```swift
           let a = 5
           let b = 42
           ```
        """
        let expected: [Document.Block] = [
            .code(
                "let a = 5\nlet b = 42\n",
                language: "swift"
            ),
        ]

        // when
        let result = Document(text)?.blocks

        // then
        XCTAssertEqual(result, expected)
    }

    func testHTML() {
        // given
        let text = "<p>Hello world!</p>"
        let expected: [Document.Block] = [
            .html("<p>Hello world!</p>\n"),
        ]

        // when
        let result = Document(text)?.blocks

        // then
        XCTAssertEqual(result, expected)
    }

    func testParagraph() {
        // given
        let text = "Hello world!"
        let expected: [Document.Block] = [
            .paragraph([.text("Hello world!")]),
        ]

        // when
        let result = Document(text)?.blocks

        // then
        XCTAssertEqual(result, expected)
    }

    func testHeading() {
        // given
        let text = """
           # Hello
           ## World
        """
        let expected: [Document.Block] = [
            .heading([.text("Hello")], level: 1),
            .heading([.text("World")], level: 2),
        ]

        // when
        let result = Document(text)?.blocks

        // then
        XCTAssertEqual(result, expected)
    }

    func testSoftBreak() {
        // given
        let text = """
           Hello
               World
        """
        let expected: [Document.Block] = [
            .paragraph([
                .text("Hello"),
                .softBreak,
                .text("World"),
            ]),
        ]

        // when
        let result = Document(text)?.blocks

        // then
        XCTAssertEqual(result, expected)
    }

    func testLineBreak() {
        // given
        let text = "Hello  \n      World"
        let expected: [Document.Block] = [
            .paragraph([
                .text("Hello"),
                .lineBreak,
                .text("World"),
            ]),
        ]

        // when
        let result = Document(text)?.blocks

        // then
        XCTAssertEqual(result, expected)
    }

    func testCodeInline() {
        // given
        let text = "Returns `nil`."
        let expected: [Document.Block] = [
            .paragraph([
                .text("Returns "),
                .code("nil"),
                .text("."),
            ]),
        ]

        // when
        let result = Document(text)?.blocks

        // then
        XCTAssertEqual(result, expected)
    }

    func testHTMLInline() {
        // given
        let text = "Returns <code>nil</code>."
        let expected: [Document.Block] = [
            .paragraph([
                .text("Returns "),
                .html("<code>"),
                .text("nil"),
                .html("</code>"),
                .text("."),
            ]),
        ]

        // when
        let result = Document(text)?.blocks

        // then
        XCTAssertEqual(result, expected)
    }

    func testEmphasis() {
        // given
        let text = "Hello _world_."
        let expected: [Document.Block] = [
            .paragraph([
                .text("Hello "),
                .emphasis([.text("world")]),
                .text("."),
            ]),
        ]

        // when
        let result = Document(text)?.blocks

        // then
        XCTAssertEqual(result, expected)
    }

    func testStrong() {
        // given
        let text = "Hello __world__."
        let expected: [Document.Block] = [
            .paragraph([
                .text("Hello "),
                .strong([.text("world")]),
                .text("."),
            ]),
        ]

        // when
        let result = Document(text)?.blocks

        // then
        XCTAssertEqual(result, expected)
    }

    func testLink() {
        // given
        let text = "Hello [world](https://example.com)."
        let expected: [Document.Block] = [
            .paragraph([
                .text("Hello "),
                .link([.text("world")], url: "https://example.com"),
                .text("."),
            ]),
        ]

        // when
        let result = Document(text)?.blocks

        // then
        XCTAssertEqual(result, expected)
    }

    func testImage() {
        // given
        let text = "Hello ![world](https://example.com/world.jpg)."
        let expected: [Document.Block] = [
            .paragraph([
                .text("Hello "),
                .image([.text("world")], url: "https://example.com/world.jpg"),
                .text("."),
            ]),
        ]

        // when
        let result = Document(text)?.blocks

        // then
        XCTAssertEqual(result, expected)
    }
}