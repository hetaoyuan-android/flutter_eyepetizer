package com.enjoy.leo_eyepetizer;

import android.Manifest;
import android.app.Activity;
import android.content.Context;
import android.content.pm.PackageManager;
import android.os.Build;
import android.text.TextUtils;
import android.widget.Toast;

import androidx.annotation.NonNull;
import androidx.core.app.ActivityCompat;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.List;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

public class SpeechPlugin implements MethodChannel.MethodCallHandler, FlutterPlugin {

    public static final int RECOGNIZER_REQUEST_CODE = 0x0010;

    private ResultStateful mResultStateful;

    private Context context;

    public SpeechPlugin(Context context) {
        this.context = context;
    }

    @Override
    public void onMethodCall(@NonNull MethodCall methodCall, @NonNull MethodChannel.Result result) {
        switch (methodCall.method) {
            case "time":
                result.success(new SimpleDateFormat("yyyy-MM-dd hh:mm:ss").format(System.currentTimeMillis()));
                break;
            case "toast":
                if (methodCall.hasArgument("msg") && !TextUtils.isEmpty(methodCall.argument("msg").toString())) {
                    Toast.makeText(context, methodCall.argument("msg").toString(), Toast.LENGTH_LONG).show();
                } else {
                    Toast.makeText(context, "msg 不能为空", Toast.LENGTH_SHORT).show();
                }
                break;
            case "start":
                mResultStateful = ResultStateful.of(result);
                startRecognizer();
                break;
            default:
                // 表明没有对应实现
                result.notImplemented();
                break;
        }
    }

    // 启动识别器
    public void startRecognizer() {
        List<String> checkResultList = checkPermissions();
        if (checkResultList.size() > 0) {
            ActivityCompat.requestPermissions((Activity) context, checkResultList.toArray(new String[0]), RECOGNIZER_REQUEST_CODE);
        } else {
            SpeechManager.getInstance().recognize(recognizerResultListener);
        }
    }

    private SpeechManager.RecognizerResultListener recognizerResultListener = new SpeechManager.RecognizerResultListener() {
        @Override
        public void onResult(String result) {
            if (mResultStateful != null) {
                mResultStateful.success(result);
            }
        }

        @Override
        public void onError(String errorMsg) {
            if (mResultStateful != null) {
                mResultStateful.error(errorMsg, null, null);
            }
        }
    };

    private List<String> checkPermissions() {
        List<String> checkResultList = new ArrayList<>();

        if (Build.VERSION.SDK_INT >= 23) {
            String[] permissions = new String[]
                    {Manifest.permission.WRITE_EXTERNAL_STORAGE,
                            Manifest.permission.READ_PHONE_STATE,
                            Manifest.permission.READ_EXTERNAL_STORAGE,
                            Manifest.permission.RECORD_AUDIO, Manifest.permission.READ_CONTACTS,
                            Manifest.permission.ACCESS_COARSE_LOCATION, Manifest.permission.ACCESS_FINE_LOCATION};

            for (String permission : permissions) {
                if (ActivityCompat.checkSelfPermission(context,
                        permission) != PackageManager.PERMISSION_GRANTED) {
                    checkResultList.add(permission);
                }
            }
        }

        return checkResultList;
    }

    @Override
    public void onAttachedToEngine(@NonNull FlutterPluginBinding binding) {
//        MethodChannel methodChannel = new MethodChannel(binding.getBinaryMessenger(), "speech_plugin");
//        methodChannel.setMethodCallHandler(this);
    }

    @Override
    public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {

    }
}
