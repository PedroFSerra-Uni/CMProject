package dk.cachet.light;

import android.content.Context;
import android.hardware.Sensor;
import android.hardware.SensorEvent;
import android.hardware.SensorEventListener;
import android.hardware.SensorManager;

import androidx.annotation.NonNull;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.EventChannel;
import io.flutter.plugin.common.EventChannel.EventSink;
import io.flutter.plugin.common.EventChannel.StreamHandler;

/** LightPlugin */
public class LightPlugin implements FlutterPlugin, StreamHandler, SensorEventListener {
  private SensorManager sensorManager;
  private Sensor lightSensor;
  private EventSink events;
  private Context context;

  @Override
  public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
    context = flutterPluginBinding.getApplicationContext();
    sensorManager = (SensorManager) context.getSystemService(Context.SENSOR_SERVICE);
    lightSensor = sensorManager.getDefaultSensor(Sensor.TYPE_LIGHT);

    final EventChannel channel = new EventChannel(flutterPluginBinding.getBinaryMessenger(), "light");
    channel.setStreamHandler(this);
  }

  @Override
  public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
    sensorManager.unregisterListener(this);
  }

  @Override
  public void onListen(Object arguments, EventSink events) {
    this.events = events;
    sensorManager.registerListener(this, lightSensor, SensorManager.SENSOR_DELAY_NORMAL);
  }

  @Override
  public void onCancel(Object arguments) {
    sensorManager.unregisterListener(this);
  }

  @Override
  public void onSensorChanged(SensorEvent event) {
    if (events != null) {
      events.success((int) event.values[0]);
    }
  }

  @Override
  public void onAccuracyChanged(Sensor sensor, int accuracy) {
    // No-op
  }
}
