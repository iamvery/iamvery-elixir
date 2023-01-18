defmodule Iamvery.Type.LegacyDuration do
  use Ecto.Type
  alias Iamvery.Duration

  def type, do: :integer

  def cast(string) when is_binary(string) do
    {:ok, string}
  end

  def cast(integer) when integer >= 0 and integer < 86_400 do
    Duration.format(integer * 1000)
  end

  def cast(_), do: :error

  def load(integer) when is_integer(integer) do
    Duration.format(integer * 1000)
  end

  def dump(string) when is_binary(string) do
    {:ok, ms} = Duration.parse(string)
    {:ok, div(ms, 1000)}
  end

  def dump(integer) when integer >= 0 and integer < 86_400 do
    {:ok, integer}
  end

  def dump(_), do: :error
end
