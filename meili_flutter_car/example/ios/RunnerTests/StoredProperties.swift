/// The stored properties of a value, whatever their access level, keyed by name. A nil optional
/// is present with a nil value, so a missing label and a nil value stay distinguishable.
func storedProperties(of subject: Any) -> [String: AnyHashable?] {
    var properties: [String: AnyHashable?] = [:]
    for child in Mirror(reflecting: subject).children {
        guard let label = child.label else { continue }
        let mirror = Mirror(reflecting: child.value)
        let value: Any? = mirror.displayStyle == .optional ? mirror.children.first?.value : child.value
        properties[label] = value as? AnyHashable
    }
    return properties
}
