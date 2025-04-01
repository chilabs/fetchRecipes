@testable import Recipes
import Foundation

class NetworkClientMock : NetworkClientProtocol {
  func fetchData(from endpointUrl: URL) async throws -> Data {
  guard let pathString = Bundle(for: type(of: self)).path(forResource: endpointUrl.relativePath, ofType: "json") else {
      fatalError("\(endpointUrl) not found")
   }
    print(pathString)
    return try Data(contentsOf: URL(fileURLWithPath: pathString))
  }
}
