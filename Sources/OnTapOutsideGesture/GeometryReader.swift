import SwiftUI

extension View {
  @MainActor func onGeometryFrameChange(perform action: @escaping (CGRect) -> Void) -> some View {
    self.background(
      GeometryReader {
        let frame = $0.frame(in: .global)

        Color.clear.task(id: frame) { [frame] in action(frame) }
      }
    )
  }
}
