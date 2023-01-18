defmodule Iamvery.Type.Duration do
  use Ecto.Type
  alias Iamvery.Duration

  def type, do: :integer

  def cast(string) when is_binary(string) do
    {:ok, string}
  end

  def cast(integer) when integer >= 0 and integer < 86_400_000 do
    Duration.format(integer)
  end

  def cast(_), do: :error

  def load(integer) when is_integer(integer) do
    Duration.format(integer)
  end

  def dump(string) when is_binary(string) do
    Duration.parse(string)
  end

  def dump(integer) when integer >= 0 and integer < 86_400_000 do
    {:ok, integer}
  end

  def dump(_), do: :error
end
