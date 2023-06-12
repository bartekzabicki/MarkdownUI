import Foundation

/// A protocol that represents any Markdown inline content.
public protocol InlineContentProtocol {
  var _inlineContent: InlineContent { get }
}

/// A Markdown inline content value.
///
/// A Markdown inline content value represents the inline text inside a leaf Markdown block,
/// like a paragraph, heading, or table cell. Some inline elements, like emphasized or strong
/// text, can contain other inlines, allowing a piece of text to have multiple styles
/// simultaneously.
///
/// You don't use this type directly to create Markdown inline content. Instead, you create
/// inline content by composing specific inline instances inside a closure annotated with
/// the `@InlineContentBuilder` attribute. Types like ``Paragraph``,
/// ``Heading`` or ``TextTableColumn`` provide initializers for composing
/// inline content.
///
/// The following example shows how you can create a paragraph by composing inline
/// content.
///
/// ```swift
/// Markdown {
///   Paragraph {
///     "You can try "
///     Strong("CommonMark")
///     SoftBreak()
///     InlineLink("here", destination: URL(string: "https://spec.commonmark.org/dingus/")!)
///     "."
///   }
/// }
/// ```
public struct InlineContent: Equatable, InlineContentProtocol {
  public var _inlineContent: InlineContent { self }
  let inlines: [InlineNode]
  let range: NSRange

  init(inlines: [InlineNode] = [], range: NSRange) {
    self.inlines = inlines
    self.range = range
  }

  init(_ components: [InlineContentProtocol], range: NSRange) {
    self.init(inlines: components.map(\._inlineContent).flatMap(\.inlines), range: range)
  }

    init(_ text: String, range: NSRange) {
    self.init(inlines: [.text(text, range: range)], range: .init(location: 0, length: text.count))
  }
}
