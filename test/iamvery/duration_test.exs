defmodule Iamvery.DurationTest do
  use ExUnit.Case
  @subject Iamvery.Duration

  test "validating hours" do
    assert @subject.parse("24:00") == :error
    assert @subject.parse("-4:00") == :error
    assert @subject.parse("100:00") == :error
    assert @subject.parse(":") == :error
    refute @subject.parse("23:00") == :error
    refute @subject.parse("0:0") == :error
  end

  test "validating minutes" do
    assert @subject.parse("00:60") == :error
    assert @subject.parse("00:-6") == :error
    assert @subject.parse("00:-1:00") == :error
    assert @subject.parse("00:60:00") == :error
    refute @subject.parse("00:59") == :error
    refute @subject.parse("00:59:00") == :error
    refute @subject.parse("00:00:00") == :error
  end

  test "validating seconds" do
    assert @subject.parse("00:00:60") == :error
    assert @subject.parse("00:00:-9") == :error
    refute @subject.parse("00:00:34") == :error
  end

  test "validating milliseconds" do
    assert @subject.parse("00:00:00.1000") == :error
    assert @subject.parse("00:00:00.-9") == :error
    refute @subject.parse("00:00:00.123") == :error
  end

  test "parsing hours and minutes" do
    assert @subject.parse("01:59") == {:ok, 7_140_000}
    assert @subject.parse("20:00") == {:ok, 72_000_000}
    assert @subject.parse("00:10") == {:ok, 600_000}
  end

  test "parsing hours and minutes and seconds" do
    assert @subject.parse("00:00:01") == {:ok, 1000}
    assert @subject.parse("01:10:05") == {:ok, 4_205_000}
  end

  test "parsing hours and minutes and seconds and milliseconds" do
    assert @subject.parse("00:00:00.001") == {:ok, 1}
    assert @subject.parse("01:10:05.123") == {:ok, 4_205_123}
  end

  test "validate format" do
    assert @subject.format(86_400_000) == :error
    assert @subject.format(-1) == :error
    refute @subject.format(1_000) == :error
  end

  test "formatting" do
    assert @subject.format(7_140_000) == {:ok, "01:59:00"}
    assert @subject.format(7_150_000) == {:ok, "01:59:10"}
    assert @subject.format(45_296_000) == {:ok, "12:34:56"}
    assert @subject.format(45_296_003) == {:ok, "12:34:56.003"}
  end
end
