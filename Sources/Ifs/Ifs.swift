import Foundation
import ArgumentParser
import Cocoa

@main
struct Ifs: ParsableCommand {
    static let configuration = CommandConfiguration(
      subcommands: [Image.self, Search.self, Export.self],
      defaultSubcommand: Image.self,
      helpNames: [.long, .customShort("?")])
}

extension Ifs {
    struct Image: ParsableCommand {
        static var configuration
          = CommandConfiguration(abstract: "Create PNG image file of the specified IFS file.")
        @Argument
        var inputFile: String
        @Option(name: .shortAndLong, help: "size of image width")
        var width: Int = 256
        @Option(name: .shortAndLong, help: "size of image height (default: equals to width)")
        var height: Int?
        @Option(name: [.customShort("N"), .long], help: "number of iterations")
        var iterations: Int = 100_000
        @Option(name: .shortAndLong, help: "number of high density")
        var density: Int = 1
        @Option(name: .shortAndLong, help: "output file path")
        var outputFile: String = "IFS.png"
    }
    struct Search: ParsableCommand {
        static var configuration
          = CommandConfiguration(abstract: "Search new IFS parameters.")
        @Option(name: .shortAndLong, help: "number of W length")
        var length: Int = 2
        @Option(name: .shortAndLong, help: "count of search result")
        var count: Int = 10
        @Option(name: [.customShort("N"), .long], help: "number of iterations")
        var iterations: Int = 1000
        @Option(name: .shortAndLong, help: "factor as a good image")
        var threshold: Float = 0.1
        @Option(name: [.customShort("C"), .long], help: "number of fails to concede")
        var concession: Int = 1000
        @Option(name: .shortAndLong, help: "attenuation rate")
        var rate: Float = 0.5
        @Option(name: .shortAndLong, help: "output file path (e.g. found.json)")
        var outputFile: String?
    }
    struct Export: ParsableCommand {
        static var configuration
          = CommandConfiguration(abstract: "Export as CSV file.")
        @Argument
        var inputFile: String
        @Option(name: .shortAndLong, help: "output file path (e.g. export.csv)")
        var outputFile: String?
    }
}
