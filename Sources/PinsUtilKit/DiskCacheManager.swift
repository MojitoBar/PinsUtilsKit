//
//  File.swift
//  
//
//  Created by 주동석 on 1/3/24.
//

import UIKit
import OSLog
import CryptoKit

public enum DiskCacheManager {
    public static func cacheImage(_ image: UIImage, withFilename filename: String) {
        let hash = CryptoUtils.sha256(filename)
        if let data = image.jpegData(compressionQuality: 0.7) ?? image.pngData() {
            let fileManager = FileManager.default
            if let cacheDirectory = fileManager.urls(for: .cachesDirectory, in: .userDomainMask).first {
                let fileURL = cacheDirectory.appendingPathComponent(hash)
                try? data.write(to: fileURL)
            }
        }
    }
    public static func retrieveCachedImage(withFilename filename: String) -> UIImage? {
        let hash = CryptoUtils.sha256(filename)
        let fileManager = FileManager.default
        if let cacheDirectory = fileManager.urls(for: .cachesDirectory, in: .userDomainMask).first {
            let fileURL = cacheDirectory.appendingPathComponent(hash)
            if let imageData = try? Data(contentsOf: fileURL) {
                return UIImage(data: imageData)
            }
        }
        return nil
    }
    public static func clearCache() {
        let fileManager = FileManager.default
        if let cacheDirectory = fileManager.urls(for: .cachesDirectory, in: .userDomainMask).first {
            do {
                let fileURLs = try fileManager.contentsOfDirectory(at: cacheDirectory, includingPropertiesForKeys: nil)
                for fileURL in fileURLs {
                    try fileManager.removeItem(at: fileURL)
                }
            } catch {
                print("Error clearing cache: \(error)")
            }
        }
    }
    public static func calculateCacheSize() -> Int {
        let fileManager = FileManager.default
        var totalSize: Int = 0

        if let cacheDirectory = fileManager.urls(for: .cachesDirectory, in: .userDomainMask).first {
            do {
                let fileURLs = try fileManager.contentsOfDirectory(at: cacheDirectory, includingPropertiesForKeys: nil)
                for fileURL in fileURLs {
                    let fileAttributes = try fileManager.attributesOfItem(atPath: fileURL.path)
                    if let fileSize = fileAttributes[.size] as? Int {
                        totalSize += fileSize
                    }
                }
            } catch {
                os_log("Error calculating cache size: \(error)")
            }
        }
        return totalSize
    }
    public static func formatBytes(_ bytes: Int) -> String {
        let formatter = ByteCountFormatter()
        formatter.allowedUnits = [.useMB, .useGB]
        formatter.countStyle = .file
        return formatter.string(fromByteCount: Int64(bytes))
    }
}
