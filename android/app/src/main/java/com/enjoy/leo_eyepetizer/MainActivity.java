package com.enjoy.leo_eyepetizer;

import android.app.AlertDialog;
import android.content.DialogInterface;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.net.Uri;
import android.os.Build;
import android.os.Bundle;
import android.provider.Settings;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodChannel;

import org.devio.flutter.splashscreen.SplashScreen;

public class MainActivity extends FlutterActivity {

    SpeechPlugin mSpeechPlugin;

    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        SplashScreen.show(this, true);
        super.onCreate(savedInstanceState);
        // 初始化
        SpeechManager.getInstance().init(this);
    }

    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        super.configureFlutterEngine(flutterEngine);
        mSpeechPlugin = new SpeechPlugin(this);
        //通过MethodChannel与原生通信
        new MethodChannel(flutterEngine.getDartExecutor(), "speech_plugin")
                .setMethodCallHandler(mSpeechPlugin);
    }


    @Override
    public void onRequestPermissionsResult(int requestCode, String[] permissions, int[] grantResults) {
        super.onRequestPermissionsResult(requestCode, permissions, grantResults);
        if (requestCode == SpeechPlugin.RECOGNIZER_REQUEST_CODE) {
            if (grantResults.length > 0) {
                int grantedSize = 0;
                for (int grantResult : grantResults) {
                    if (grantResult == PackageManager.PERMISSION_GRANTED) {
                        grantedSize++;
                    }
                }
                if (grantedSize == grantResults.length) {
                    mSpeechPlugin.startRecognizer();
                } else {
                    showWaringDialog();
                }
            } else {
                showWaringDialog();
            }
        }
    }

    private void showWaringDialog() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.HONEYCOMB) {
            new AlertDialog.Builder(this, android.R.style.Theme_Material_Light_Dialog_Alert)
                    .setTitle(R.string.waring)
                    .setMessage(R.string.permission_waring)
                    .setPositiveButton(R.string.sure, new DialogInterface.OnClickListener() {
                        @Override
                        public void onClick(DialogInterface dialog, int which) {
                            go2AppSettings();
                        }
                    }).setNegativeButton(R.string.cancel, null).show();
        }
    }


    private void go2AppSettings() {
        Intent intent = new Intent(Settings.ACTION_APPLICATION_DETAILS_SETTINGS);
        Uri uri = Uri.fromParts("package", getPackageName(), null);
        intent.setData(uri);
        intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
        startActivity(intent);
    }

}
