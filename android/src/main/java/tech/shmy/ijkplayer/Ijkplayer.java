package tech.shmy.ijkplayer;

import android.media.AudioManager;
import android.os.Handler;

import java.io.IOException;
import java.util.HashMap;

import io.flutter.plugin.common.EventChannel;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.PluginRegistry;
import io.flutter.view.TextureRegistry;
import tv.danmaku.ijk.media.player.IMediaPlayer;
import tv.danmaku.ijk.media.player.IjkMediaPlayer;
import tv.danmaku.ijk.media.player.TextureMediaPlayer;

public class Ijkplayer {
    private final TextureRegistry.SurfaceTextureEntry textureEntry;
    private final EventChannel eventChannel;
    private TextureMediaPlayer textureMediaPlayer;
    private EventChannel.EventSink eventSink;
    private Handler handler = new Handler();
    private Runnable runnable = new Runnable() {
        @Override
        public void run() {
            sendState();
            System.out.println("------时间轮询-------");
            handler.postDelayed(runnable, 300);
        }
    };
    private boolean isBuffering = false;
    private int bufferingProgress = 0;
    private boolean isCompleted = false;
    private int errorCode = -1;
    private boolean initialized = false;
    private int netWorkSpeed = 0;

    Ijkplayer(PluginRegistry.Registrar registrar,
              EventChannel eventChannel,
              TextureRegistry.SurfaceTextureEntry textureEntry,
              String dataSource,
              MethodChannel.Result result) {
        this.eventChannel = eventChannel;
        this.textureEntry = textureEntry;
        setUpVideo(dataSource, result);

    }

    private void setUpVideo(String dataSource, MethodChannel.Result result) {
        eventChannel.setStreamHandler(new EventChannel.StreamHandler() {
            @Override
            public void onListen(Object o, EventChannel.EventSink _eventSink) {
                eventSink = _eventSink;
            }

            @Override
            public void onCancel(Object o) {
                eventSink = null;
            }
        });
        IjkMediaPlayer iMediaPlayer = new IjkMediaPlayer();
        textureMediaPlayer = new TextureMediaPlayer(iMediaPlayer);
        textureMediaPlayer.setSurfaceTexture(textureEntry.surfaceTexture());
        textureMediaPlayer.setOnPreparedListener(new IMediaPlayer.OnPreparedListener() {
            @Override
            public void onPrepared(IMediaPlayer iMediaPlayer) {
                initialized = true;
                handler.post(runnable);
            }
        });
        textureMediaPlayer.setOnCompletionListener(new IMediaPlayer.OnCompletionListener() {
            @Override
            public void onCompletion(IMediaPlayer iMediaPlayer) {
                isCompleted = true;
            }
        });
        textureMediaPlayer.setOnErrorListener(new IMediaPlayer.OnErrorListener() {
            @Override
            public boolean onError(IMediaPlayer iMediaPlayer, int i, int i1) {
                errorCode = i1;
                return false;
            }
        });
        textureMediaPlayer.setOnBufferingUpdateListener(new IMediaPlayer.OnBufferingUpdateListener() {
            @Override
            public void onBufferingUpdate(IMediaPlayer iMediaPlayer, int i) {
                bufferingProgress = i;
            }
        });

        textureMediaPlayer.setOnInfoListener(new IMediaPlayer.OnInfoListener() {
            @Override
            public boolean onInfo(IMediaPlayer iMediaPlayer, int i, int i1) {
                if (i == iMediaPlayer.MEDIA_INFO_BUFFERING_START) {
                    isBuffering = true;
                } else if (i == iMediaPlayer.MEDIA_INFO_BUFFERING_END) {
                    isBuffering = false;
                } else if (i == iMediaPlayer.MEDIA_INFO_NETWORK_BANDWIDTH) {
                    netWorkSpeed = i1;
                }
                return false;
            }
        });
        try {
            textureMediaPlayer.setDataSource(dataSource);
            textureMediaPlayer.setAudioStreamType(AudioManager.STREAM_MUSIC);
            textureMediaPlayer.prepareAsync();
        } catch (IOException e) {
            e.printStackTrace();
        }
        long id = textureEntry.id();
        System.out.println(id);
        result.success(id);
    }

    // 发送给 flutter 端
    private void sendState() {
        if (eventSink != null && textureMediaPlayer != null) {
            HashMap m = new HashMap();
            m.put("width", textureMediaPlayer.getVideoWidth());
            m.put("height", textureMediaPlayer.getVideoHeight());
            m.put("initialized", initialized);
            m.put("isBuffering", isBuffering);
            m.put("isPlaying", !isBuffering && textureMediaPlayer.isPlaying());
            m.put("isCompleted", isCompleted);
            m.put("bufferingProgress", bufferingProgress);
            m.put("netWorkSpeed", netWorkSpeed);
            m.put("duration", textureMediaPlayer.getDuration());
            m.put("position", textureMediaPlayer.getCurrentPosition());
            m.put("errorCode", errorCode);
            eventSink.success(m);
        }
    }

    public void start() {
        textureMediaPlayer.start();
    }

    public void pause() {
        textureMediaPlayer.pause();
    }

    public void seekTo(long position) {
        textureMediaPlayer.seekTo(position);
    }

    public void dispose() {
        textureMediaPlayer.stop();
        textureMediaPlayer.releaseSurfaceTexture();
        textureMediaPlayer.release();
        eventChannel.setStreamHandler(null);
        handler.removeCallbacks(runnable);
        handler = null;
    }

}