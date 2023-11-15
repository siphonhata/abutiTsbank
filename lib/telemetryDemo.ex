defmodule TelemetryDemo do

  import Telemetry.Metrics


  def transformData() do
    :telemetry.execute([:telemetry_demo, :transform_data], %{})
    IO.inspect(counter("telemetry_demo.transform_data.count"))
  end
end
