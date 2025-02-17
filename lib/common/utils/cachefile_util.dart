import 'package:flutter_smallworld/common/model/index.dart';
import 'package:dio/dio.dart';
import 'dart:io';
import 'package:flutter_smallworld/common/net/http_manager.dart';
import 'package:flutter_smallworld/common/utils/index.dart';
import 'package:path_provider/path_provider.dart';

class CacheFileUtil {
  static final String sName = "CacheFileUtil";

  static String cacheDirection;
  static String commonDirection;
  static String appDirection;

  static setCacheFile(CacheFileType cacheFileType, String url,
      {CacheType cacheType = CacheType.CACHE,
        ProgressCallback onReceiveProgress,
        CancelToken cancelToken}) async {

    String tmpSavePath = _calculateCacheFilePath(url, cacheFileType: cacheFileType, cacheType: cacheType);

    try {
      Response response = await HttpManager.download(url, tmpSavePath,
          onReceiveProgress: onReceiveProgress, cancelToken: cancelToken);
      if (response.statusCode == 200) {
        String savePath = tmpSavePath;
        switch(cacheFileType) {
          case CacheFileType.IMAGE:
            savePath.replaceAll('.tmp', '.png');
            break;
          case CacheFileType.VIDEO:
            savePath.replaceAll('.tmp', '.mp4');
            break;
        }
        File(tmpSavePath).renameSync(savePath);
        CacheFile cacheFile = new CacheFile(cacheFileType, url, cacheType, savePath, DateTime.now());
        return cacheFile;
      }
      File tmpFile = File(tmpSavePath);
      if (tmpFile.existsSync()) tmpFile.deleteSync();
    } catch (e) {
      File tmpFile = File(tmpSavePath);
      if (tmpFile.existsSync()) tmpFile.deleteSync();
      LogUtil.i(sName, 'CacheUtil失败');
      LogUtil.i(sName, e);
    }
  }

  static CacheFile getCacheFile(String remoteUrl, { CacheFileType cacheFileType = CacheFileType.IMAGE,  CacheType cacheType = CacheType.CACHE }) {
    String filePath = _calculateCacheFilePath(remoteUrl, cacheFileType: cacheFileType, cacheType: cacheType);
    File file = new File(filePath);
    if (!file.existsSync()) {
      return null;
    }
    CacheFile findCacheFile = CacheFile.empty();
    findCacheFile.cacheType = cacheType;
    findCacheFile.filePath = filePath;
    findCacheFile.fileUrl = remoteUrl;
    return findCacheFile;
  }

  /// 根据url计算并拼接本地缓存文件路径，不判断文件是否存在
  static String _calculateCacheFilePath(String url, { CacheFileType cacheFileType = CacheFileType.IMAGE, CacheType cacheType = CacheType.CACHE }) {
    String fileNameAndSuffix = _calculateFileName(url) + '.tmp';

    String filePath;
    switch (cacheType) {
      case CacheType.CACHE:
        filePath = cacheDirection + fileNameAndSuffix;
        break;
      case CacheType.COMMON:
        filePath = commonDirection + fileNameAndSuffix;
        break;
    }
    return filePath;
  }

  /// 根据关键字计算唯一hash字符串
  static String _calculateFileName(String key) {
    int firstHalfLength =  (key.length / 2).floor();
    String localFilename = key.substring(0, firstHalfLength).hashCode.toString();
    localFilename += key.substring(firstHalfLength).hashCode.toString();
    return localFilename;
  }

  /// 清理缓存文件
  static clearCacheFile() {
    Directory(cacheDirection).deleteSync(recursive: true);
    Directory(cacheDirection).createSync(recursive: true);
  }

  static initDirection() async {
    Directory appDocDir = await getApplicationDocumentsDirectory();
    appDirection = appDocDir.path;
    cacheDirection = appDirection + '/file/cache/';
    commonDirection = appDirection + '/file/common/';

    new Directory(cacheDirection).create(recursive: true);
    new Directory(commonDirection).create(recursive: true);
  }
}
