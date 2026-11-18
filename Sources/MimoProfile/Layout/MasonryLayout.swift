import SwiftUI

/// Grade em alvenaria: cada item entra na coluna mais curta,
/// com a altura que pedir para a largura da coluna.
struct MasonryLayout: Layout {
    var columns: Int = 2
    var spacing: CGFloat = 10

    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let width = proposal.width ?? 360
        return CGSize(width: width, height: arrange(width: width, subviews: subviews).height)
    }

    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let frames = arrange(width: bounds.width, subviews: subviews).frames
        for (index, frame) in frames.enumerated() {
            subviews[index].place(
                at: CGPoint(x: bounds.minX + frame.minX, y: bounds.minY + frame.minY),
                proposal: ProposedViewSize(width: frame.width, height: frame.height)
            )
        }
    }

    private func arrange(width: CGFloat, subviews: Subviews) -> (frames: [CGRect], height: CGFloat) {
        let columnCount = max(columns, 1)
        let columnWidth = (width - spacing * CGFloat(columnCount - 1)) / CGFloat(columnCount)
        var heights = Array(repeating: CGFloat.zero, count: columnCount)
        var frames: [CGRect] = []
        frames.reserveCapacity(subviews.count)

        for subview in subviews {
            let size = subview.sizeThatFits(ProposedViewSize(width: columnWidth, height: nil))
            let column = heights.indices.min { heights[$0] < heights[$1] } ?? 0
            let x = CGFloat(column) * (columnWidth + spacing)
            frames.append(CGRect(x: x, y: heights[column], width: columnWidth, height: size.height))
            heights[column] += size.height + spacing
        }

        let height = max((heights.max() ?? 0) - spacing, 0)
        return (frames, height)
    }
}
