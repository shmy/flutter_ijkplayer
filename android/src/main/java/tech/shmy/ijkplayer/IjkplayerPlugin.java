package tech.shmy.ijkplayer;


import android.annotation.SuppressLint;

import java.util.HashMap;

import io.flutter.plugin.common.EventChannel;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.PluginRegistry;
import io.flutter.plugin.common.PluginRegistry.Registrar;
import io.flutter.view.FlutterNativeView;
import io.flutter.view.TextureRegistry;

/**
 * IjkplayerPlugin
 */
public class IjkplayerPlugin implements MethodChannel.MethodCallHandler {
    private static final String CHANNEL_NAME = "tech.shmy.ijkplayer";
    private final Registrar registrar;
    @SuppressLint("UseSparseArrays")
    private HashMap<Long, Ijkplayer> players = new HashMap<>();

    @Override
    public void onMethodCall(MethodCall methodCall, MethodChannel.Result result) {
        TextureRegistry textures = registrar.textures();
        if (textures == null) {
            result.error("no_activity", "video_player plugin requires a foreground activity", null);
            return;
        }
        switch (methodCall.method) {
            case "init": {
                TextureRegistry.SurfaceTextureEntry surfaceTexture = textures.createSurfaceTexture();
                long id = surfaceTexture.id();
                String url = (String) methodCall.arguments;
                EventChannel eventChannel =
                        new EventChannel(
                                registrar.messenger(), CHANNEL_NAME + "/" + id);
                Ijkplayer player = new Ijkplayer(registrar, eventChannel, surfaceTexture, url, result);
                players.put(id, player);
            }
            break;
            case "dispose":
                dispose((Integer) methodCall.arguments, result);
                break;
            case "play":
                play((Integer) methodCall.arguments, result);
                break;
            case "pause":
                pause((Integer) methodCall.arguments, result);
                break;
            case "seekTo": {
                Integer position = methodCall.argument("position");
                Integer id = methodCall.argument("id");
                seekTo(id, position, result);
            }

            break;
            default:
                result.notImplemented();
        }
    }

    private IjkplayerPlugin(Registrar registrar) {
        this.registrar = registrar;
    }

    private void onDestroy() {
        System.out.println("onDestroy");
    }

    public static void registerWith(Registrar registrar) {
        final IjkplayerPlugin ijkplayerPlugin = new IjkplayerPlugin(registrar);
        MethodChannel methodChannel = new MethodChannel(registrar.messenger(), CHANNEL_NAME + "/method");
        methodChannel.setMethodCallHandler(ijkplayerPlugin);
        registrar.addViewDestroyListener(
                new PluginRegistry.ViewDestroyListener() {
                    @Override
                    public boolean onViewDestroy(FlutterNativeView view) {
                        ijkplayerPlugin.onDestroy();
                        return false; // We are not interested in assuming ownership of the NativeView.
                    }
                });
    }

    // 播放
    private void play(long id, MethodChannel.Result result) {
        Ijkplayer ijkplayer = players.get(id);
        if (ijkplayer != null) {
            ijkplayer.start();
        }
        result.success(null);
    }

    // 暂停
    private void pause(long id, MethodChannel.Result result) {

        Ijkplayer ijkplayer = players.get(id);
        if (ijkplayer != null) {
            ijkplayer.pause();
        }
        result.success(null);
        result.success(null);
    }

    // 跳转进度
    private void seekTo(long id, long position, MethodChannel.Result result) {
        Ijkplayer ijkplayer = players.get(id);
        if (ijkplayer != null) {
            ijkplayer.seekTo(position);
        }
        result.success(null);
    }

    // 销毁
    private void dispose(long id, MethodChannel.Result result) {
        Ijkplayer ijkplayer = players.get(id);
        if (ijkplayer != null) {
            ijkplayer.dispose();
            players.remove(id);
        }

        result.success(null);
    }
}
