//
//  ImageCacheTests.swift
//  RecipesTests
//
//  Created by peter on 3/28/25.
//
import UIKit
import Testing
@testable import Recipes

class ImageCacheTests {
  
  private func getCacheDirectoryUrl() throws -> URL {
    let cacheDirectory = try FileManager.default.url(
      for: .cachesDirectory,
      in: .userDomainMask,
      appropriateFor: nil,
      create: false
    )
    return cacheDirectory.appendingPathComponent(ImageCache.imageCacheDirectory)
  }
  
  @Test func testSaveImageToCache() async throws {
    let fileUrl = try #require(URL(string:"\testDirectory\testImage.png"))
    let fileId = "123"
    let testImage = try #require(
      UIImage(named: "testImage",
              in: Bundle(for: type(of:self)),
              compatibleWith:nil)
    )
    let testImageData = try #require(testImage.pngData())
    // Surpress Swift 6 warning for test
    nonisolated(unsafe) let memoryCache = NSCache<NSString, UIImage>()
    let imageCache = ImageCache(memoryCache: {memoryCache})
    await imageCache.saveImageToCache(imageData: testImageData, fileUrl: fileUrl, fileId: fileId)
    
    // Verify image exists in memory cache
    let memoryCacheImageData = try #require(memoryCache.object(forKey: fileId as NSString)?.pngData())
    #expect(testImageData == memoryCacheImageData)
    
    // Verify cache directory exists
    let cacheDirectory = try getCacheDirectoryUrl()
    #expect(FileManager.default.fileExists(atPath: cacheDirectory.relativePath))
    
    // Verify file exists on disk
    let actualImageData =  try #require(try Data(
      contentsOf:cacheDirectory.appendingPathComponent(fileId)
    ))
    #expect(testImageData == actualImageData)
    
    // Verify file can be loaded
    let actualLoadedImageResult = await imageCache.loadImageFromCache(imageUrl: fileUrl, imageId: fileId)
    guard case .success(let actualLoadedImage) = actualLoadedImageResult else {
      Issue.record("Could not load image after saving")
      return
    }
    let actualLoadedImageData = try #require(actualLoadedImage.pngData())
    #expect(testImageData == actualLoadedImageData)
  }
  
  deinit {
    do {
      // clear the cache directory
      let cacheDirectory = try getCacheDirectoryUrl()
      try FileManager.default.removeItem(at: cacheDirectory)
    } catch {
      print(error)
    }
    
  }
}
