import SwiftUI

// from: https://stackoverflow.com/a/76329393/13162032

#if canImport(UIKit)
  struct WindowReader: UIViewRepresentable {
    let willMoveHandler: (UIWindow?) -> Void

    @MainActor final class View: UIView {
      var willMoveHandler: ((UIWindow?) -> Void)

      init(willMoveHandler: (@escaping (UIWindow?) -> Void)) {
        self.willMoveHandler = willMoveHandler
        super.init(frame: .zero)
      }

      @available(*, unavailable) required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
      }

      override func willMove(toWindow newWindow: UIWindow?) {
        super.willMove(toWindow: newWindow)

        self.willMoveHandler(newWindow)
      }
    }

    func makeUIView(context: Context) -> View { .init(willMoveHandler: willMoveHandler) }

    func updateUIView(_ uiView: View, context: Context) {}
  }

  extension View {
    func onWindowChange(_ action: @escaping (UIWindow?) -> Void) -> some View {
      self.background { WindowReader(willMoveHandler: action) }
    }
  }
#elseif canImport(AppKit)
  struct WindowReader: NSViewRepresentable {
    let viewWillMoveHandler: (NSWindow?) -> Void

    @MainActor final class View: NSView {
      var viewWillMoveHandler: ((NSWindow?) -> Void)

      init(viewWillMoveHandler: (@escaping (NSWindow?) -> Void)) {
        self.viewWillMoveHandler = viewWillMoveHandler
        super.init(frame: .zero)
      }

      @available(*, unavailable) required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
      }

      override func viewWillMove(toWindow newWindow: NSWindow?) {
        super.viewWillMove(toWindow: newWindow)

        self.viewWillMoveHandler(newWindow)
      }
    }

    func makeNSView(context: Context) -> View { .init(viewWillMoveHandler: viewWillMoveHandler) }

    func updateNSView(_ nsView: View, context: Context) {}
  }

  extension View {
    func onWindowChange(_ action: @escaping (NSWindow?) -> Void) -> some View {
      self.background { WindowReader(viewWillMoveHandler: action) }
    }
  }
#endif
