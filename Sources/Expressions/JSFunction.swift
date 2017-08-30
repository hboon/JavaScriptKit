/**
 *  JavaScriptKit
 *  Copyright (c) 2017 Alexis Aubry. Licensed under the MIT license.
 */

import Foundation

///
/// A concrete JavaScript expression that executes a function in the current JavaScript `this`. The
/// function variable is represented by a key path relative to the current `this`.
///
/// For instance, to present an alert:
///
/// ~~~swift
/// let alert = JSFreeFunction<Void>("window.alert", arguments: "Hello from Swift!")
/// // equivalent to the JS script `this.window.alert("Hello from Swift!");`
/// ~~~
///
/// Instances of this class are specialized with the `T` generic parameter. It must be set to the
/// return type of the JavaScript function to execute. Check the documentation of the JavaScript
/// function to know what to set the parameter to.
///
/// `T` must be a compatible type. Compatible types include:
/// - `Void`
/// - Primitive values (`JSPrimitiveType`)
/// - Enum cases with a primitive `RawValue`
/// - Objects (`JSObject`)
/// - Arrays of primitive values
/// - Arrays of enum cases with a primitive `RawValue`
/// - Arrays of objects.
///

public final class JSFunction<T>: JSExpression {

    public typealias ReturnType = T

    /// The key path to the function to execute, relative the current `this` object tree.
    public let keyPath: String

    /// The arguments to pass to the function.
    public let arguments: [JSConvertible]

    ///
    /// Creates a new method description.
    ///
    /// - parameter keyPath: A dot-separated key path to the function to execute, relative the
    /// current `this` object tree.
    /// - parameter arguments: The arguments to pass to the function. You can omit this paramter if
    /// the JavaScript function you are calling takes no arguments.
    ///
    /// For instance, to present an alert:
    ///
    /// ~~~swift
    /// let alert = JSFreeFunction<Void>("window.alert", arguments: "Hello from Swift!")
    /// // equivalent to the JS script `this.window.alert("Hello from Swift!");`
    /// ~~~
    ///

    public init(_ keyPath: String, arguments: JSConvertible...) {
        self.keyPath = keyPath
        self.arguments = arguments
    }

    public func makeExpressionString() -> String {
        
        let argumentsList = arguments.reduce("") {
            partialResult, argument in

            let separator = partialResult.isEmpty ? "" : ", "
            return partialResult + separator + argument.jsRepresentation

        }

        return "this.\(keyPath)" + "(" + argumentsList + ");"

    }

}
