package com.doraemon.meizizi;

import android.Manifest;
import android.app.ProgressDialog;
import android.content.ComponentName;
import android.content.Context;
import android.content.pm.PackageManager;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.net.Uri;
import android.os.AsyncTask;
import android.os.Build;
import android.os.Bundle;

import io.flutter.app.FlutterActivity;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugins.GeneratedPluginRegistrant;

import com.sch.share.WXShareMultiImageHelper;

import android.content.ContextWrapper;
import android.content.Intent;
import android.content.IntentFilter;
import android.os.StrictMode;
import android.provider.MediaStore;
import android.util.Log;

import org.json.JSONObject;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.ArrayList;
import java.util.List;

public class MainActivity extends FlutterActivity {
  public static String IMAGE_NAME = "iv_share_";
  public static int i = 0;
  private static final String CHANNEL = "com.doraemon.meizizi/door";

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
            } else if (call.method.equals("upload")) {
              upload(call.arguments, result);
            }
          }
        });
  }

  private void upload(Object arguments, Result result) {

  }

  protected void share(Object paths) {
    ArrayList<String> urls = (ArrayList<String>) paths;

    loadImage(urls, new OnLoadImageEndCallback() {
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
