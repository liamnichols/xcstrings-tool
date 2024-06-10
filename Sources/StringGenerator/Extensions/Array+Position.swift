extension Array {
    struct Position {
        let isFirst: Bool
        let isLast: Bool
        let index: Int
    }

    var withPosition: some Collection<(Position, Element)> {
        zip(indices, self)
            .lazy
            .map { (index, element) in
                let position = Position(
                    isFirst: index == indices.first,
                    isLast: index == indices.last,
                    index: index
                )

                return (position, element)
            }
    }
}
