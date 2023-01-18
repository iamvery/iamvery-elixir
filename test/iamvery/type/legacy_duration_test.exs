defmodule Iamvery.Type.LegacyDurationTest do
  use ExUnit.Case, async: true
  @subject Iamvery.Type.LegacyDuration

  test "data" do
    {:ok, "00:02:03"} = Ecto.Type.cast(@subject, 123)
    {:ok, "12:34:56"} = Ecto.Type.cast(@subject, "12:34:56")

    {:ok, "00:02:03"} = Ecto.Type.load(@subject, 123)

    {:ok, 123} = Ecto.Type.dump(@subject, "00:02:03")
    {:ok, 123} = Ecto.Type.dump(@subject, 123)
  end
end
