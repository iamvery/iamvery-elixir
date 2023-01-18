defmodule Iamvery.Duration do
  @moduledoc """
  This duration module parses and formats strings for a time duration in hours
  and minutes and seconds and milliseconds (e.g. 01:00 for an hour, 00:01:10
  for one minute and ten seconds).

  Adapted from: https://gist.github.com/rcdilorenzo/84e47b451972ef4c6f46
  """
  @match ~r/^(?<hour>\d{1,2}):(?<min>\d{1,2}):?(?<sec>\d{0,2})\.?(?<mil>\d{0,3})$/

  @ms_per_sec 1000
  @secs_per_min 60
  @mins_per_hr 60
  @hrs_per_day 24
  @ms_per_min @secs_per_min * @ms_per_sec
  @ms_per_hr @mins_per_hr * @ms_per_min
  @ms_per_day @hrs_per_day * @ms_per_hr

  def parse(string) do
    case Regex.named_captures(@match, string) do
      nil ->
        :error

      %{"hour" => hour_str, "min" => min_str, "sec" => sec_str, "mil" => mil_str} ->
        with {:ok, hours} <- parse_integer(hour_str),
             {:ok, minutes} <- parse_integer(min_str),
             {:ok, seconds} <- parse_integer(sec_str),
             {:ok, milliseconds} <- parse_integer(mil_str),
             do: validate(hours, minutes, seconds, milliseconds)
    end
  end

  def format(integer) when integer >= 0 and integer < @ms_per_day do
    hours = div(integer, @ms_per_hr)
    minutes = div(integer - hours * @ms_per_hr, @ms_per_min)
    seconds = div(integer - hours * @ms_per_hr - minutes * @ms_per_min, @ms_per_sec)
    milliseconds = integer - hours * @ms_per_hr - minutes * @ms_per_min - seconds * @ms_per_sec

    case milliseconds do
      0 -> {:ok, "#{pad(hours)}:#{pad(minutes)}:#{pad(seconds)}"}
      _ -> {:ok, "#{pad(hours)}:#{pad(minutes)}:#{pad(seconds)}.#{pad(milliseconds, 3)}"}
    end
  end

  def format(_), do: :error

  defp pad(integer, count \\ 2) do
    to_string(integer) |> String.pad_leading(count, "0")
  end

  defp parse_integer(""), do: {:ok, 0}

  defp parse_integer(string) when is_binary(string) do
    case Integer.parse(string) do
      {value, _} -> {:ok, value}
      :error -> :error
    end
  end

  defp validate(hours, minutes, seconds, milliseconds) do
    cond do
      hours < @hrs_per_day and minutes < @mins_per_hr and seconds < @secs_per_min and
          milliseconds < @ms_per_sec ->
        {:ok, hours * @ms_per_hr + minutes * @ms_per_min + seconds * @ms_per_sec + milliseconds}

      true ->
        :error
    end
  end
end
