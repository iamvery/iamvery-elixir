defmodule Iamvery.Type.DurationTest do
  use ExUnit.Case, async: true
  @subject Iamvery.Type.Duration

  test "data" do
    {:ok, "00:02:03"} = Ecto.Type.cast(@subject, 123_000)
    {:ok, "12:34:56"} = Ecto.Type.cast(@subject, "12:34:56")

    {:ok, "00:02:03"} = Ecto.Type.load(@subject, 123_000)

    {:ok, 123_000} = Ecto.Type.dump(@subject, "00:02:03")
    {:ok, 123_000} = Ecto.Type.dump(@subject, 123_000)
  end
end
