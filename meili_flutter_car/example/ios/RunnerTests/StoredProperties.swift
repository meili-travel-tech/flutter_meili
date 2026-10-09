/// The non-nil stored properties of a value, whatever their access level, keyed by name.
func storedProperties(of subject: Any) -> [String: AnyHashable] {
    var properties: [String: AnyHashable] = [:]
    for child in Mirror(reflecting: subject).children {
        guard let label = child.label else { continue }
        let mirror = Mirror(reflecting: child.value)
        let value: Any? = mirror.displayStyle == .optional ? mirror.children.first?.value : child.value
        if let hashable = value as? AnyHashable {
            properties[label] = hashable
        }
    }
    return properties
}
