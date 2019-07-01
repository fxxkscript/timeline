package com.meizizi.doraemon;

import android.Manifest;
import android.app.ProgressDialog;
import android.content.pm.PackageManager;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.os.Build;
import android.os.Bundle;

import io.flutter.app.FlutterActivity;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugins.GeneratedPluginRegistrant;

import com.sch.share.WXShareMultiImageHelper;


import android.util.Log;

import org.json.JSONObject;


import java.io.InputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

public class MainActivity extends FlutterActivity {
  private static final String CHANNEL = "com.meizizi.doraemon/door";

  @Override
  protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    GeneratedPluginRegistrant.registerWith(this);


    new MethodChannel(getFlutterView(), CHANNEL).setMethodCallHandler(
        new MethodCallHandler() {
          @Override
          public void onMethodCall(MethodCall call, Result result) {
            if (call.method.equals("weixin")) {
              share(call.arguments);
            }
          }
        });
  }

  @SuppressWarnings("unchecked")
  protected void share(Object params) {
    HashMap<String, Object> map = (HashMap<String, Object>) params;

    loadImage((List<String>) map.get("pics"), new OnLoadImageEndCallback() {
      @Override
      public void onEnd(List<Bitmap> bitmapList) {
        shareToTimeline(bitmapList);
      }
    });
  }

  // 分享到朋友圈。
  private void shareToTimeline(List<Bitmap> bitmapList) {
    WXShareMultiImageHelper.shareToTimeline(this, bitmapList, "hello");
  }


  @Override
  public void onRequestPermissionsResult(int requestCode, String[] permissions, int[] grantResults) {
    super.onRequestPermissionsResult(requestCode, permissions, grantResults);
    if (grantResults[0] != PackageManager.PERMISSION_GRANTED) {
      requestStoragePermission();
    }
  }

  @Override
  protected void onDestroy() {
    // 清理临时文件。
    WXShareMultiImageHelper.clearTmpFile(this);
    super.onDestroy();
  }

  private void requestStoragePermission() {
    // 申请内存权限。
    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M &&
        !WXShareMultiImageHelper.hasStoragePermission(this)) {
      requestPermissions(new String[]{Manifest.permission.WRITE_EXTERNAL_STORAGE}, 1);
    }
  }

  private Bitmap downloadImage(String imageUrl) {
    Bitmap bitmap = null;

    try {
      URL url = new URL(imageUrl);
      HttpURLConnection conn = null;
      conn = (HttpURLConnection) url.openConnection();
      conn.setConnectTimeout(6000); //超时设置
      conn.setDoInput(true);
      conn.setUseCaches(false); //设置不使用缓存
      InputStream is = conn.getInputStream();
      bitmap = BitmapFactory.decodeStream(is);
      is.close();


    } catch (Exception e) {
      e.printStackTrace();
    }

    return bitmap;
  }

  private void loadImage(List<String>imgUrls, final OnLoadImageEndCallback callback) {
    final ProgressDialog dialog = new ProgressDialog(this);
    dialog.setMessage("正在加载图片...");
    dialog.show();
    new Thread(new Runnable() {
      @Override
      public void run() {
        List<Bitmap> bitmapList = new ArrayList<>();

        for (String url : imgUrls) {
          Bitmap bitmap = downloadImage(url);
          if (bitmap != null) {
            bitmapList.add(bitmap);
          }
        }
        runOnUiThread(new Runnable() {
          @Override
          public void run() {
            dialog.cancel();
          }
        });
        callback.onEnd(bitmapList);
      }
    }).start();
  }



  private interface OnLoadImageEndCallback {
    void onEnd(List<Bitmap> bitmapList);
  }
}
