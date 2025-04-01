import Foundation
import Testing
@testable import Recipes

struct RecipesFetcherTests {
  private func getExpectedRecipesModel(from testDataFile:String) throws -> [RecipeModel] {
    let pathTestToDataFile = try #require(Bundle(for: NetworkClientMock.self).url(forResource: testDataFile, withExtension: "json"))
    let expectedData = try Data(contentsOf:pathTestToDataFile)
    let decoder = JSONDecoder()
    decoder.keyDecodingStrategy = .convertFromSnakeCase
    return try decoder.decode(RecipesResponseModel.self, from: expectedData).recipes.sorted {$0.name < $1.name}
  }
  
  @Test func testFetchingWellformedData() async throws {
    let testDataFile = "wellformedData"
    let expectedRecipesModel = try getExpectedRecipesModel(from:testDataFile)
    
    let recipesFetcher = RecipesFetcher(networkClient: NetworkClientMock())
    let actualLoadingState = await recipesFetcher.fetchRecipes(try #require(URL(string:testDataFile)))
    #expect(actualLoadingState == .isFinishedLoading(expectedRecipesModel))
    if case .isFinishedLoading(let array) = actualLoadingState {
      #expect(array == expectedRecipesModel)
    }
  }
  
  @Test func testFetchingMalformedData() async throws {
    let recipesFetcher = RecipesFetcher(networkClient: NetworkClientMock())
    let actualLoadingState = await recipesFetcher.fetchRecipes(try #require(URL(string:"malformedData")))
    #expect(actualLoadingState == .hasError(NSError(domain: "", code: 0)))
  }
            
  @Test func testFetchingEmptyData() async throws {
    let recipesFetcher = RecipesFetcher(networkClient: NetworkClientMock())
    let actualLoadingState = await recipesFetcher.fetchRecipes(try #require(URL(string:"emptyData")))
    #expect(actualLoadingState == .isFinishedLoading([]))
    if case .isFinishedLoading(let array) = actualLoadingState {
      #expect(array == [])
    }
  }

}
