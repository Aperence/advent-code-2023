defmodule Day1 do

  def get_lines(file) do
    File.read!(file) |> String.split("\n")
  end

  def get_number(string) do
    lst = for i <- 0..String.length(string) do
      char = String.slice(string, i..i)
      case Integer.parse(char) do
        :error -> -1;
        {value, _rem} -> value
      end
    end

    numbers =
      lst
      |> Stream.filter(fn x -> x != -1 end)
      |> Enum.to_list()

    if length(numbers) == 0 do
      0
    end

    {:ok, first} = Enum.fetch(numbers, 0)
    {:ok, last} = Enum.fetch(numbers, -1)
    first * 10 + last
  end

  def part1() do
    get_lines("inputs/01/input")
    |> Stream.map(fn elem -> get_number(elem) end)
    |> Enum.reduce(0, fn x, acc -> x + acc end)
  end

  def get_number2(string) do
    lst = for i <- 0..String.length(string) do
      char = String.slice(string, i..i)
      ret = case Integer.parse(char) do
        :error -> -1;
        {value, _rem} -> value
      end

      if ret == -1 do
        num =
        for {num, index} <- [{"one", 1}, {"two", 2}, {"three", 3}, {"four", 4}, {"five", 5}, {"six", 6}, {"seven", 7}, {"eight", 8}, {"nine", 9}]  do
          sub = String.slice(string, i..i+String.length(num)-1)
          if num == sub do
            index
          else
            -1
          end
        end |> Enum.filter(fn x -> x != -1 end)
        case num do
          [] -> -1
          [value] -> value
        end
      else
        ret
      end
    end

    numbers =
      lst
      |> Stream.filter(fn x -> x != -1 end)
      |> Enum.to_list()

    if length(numbers) == 0 do
      0
    end

    {:ok, first} = Enum.fetch(numbers, 0)
    {:ok, last} = Enum.fetch(numbers, -1)
    first * 10 + last
  end

  def part2() do
    get_lines("inputs/01/input")
    |> Stream.map(fn elem -> get_number2(elem) end)
    |> Enum.reduce(0, fn x, acc -> x + acc end)
  end
end
