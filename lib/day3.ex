defmodule Day3 do

  def get_lines(file) do
    File.read!(file) |> String.split("\n")
  end

  def process(lines) do
    {:ok, agent} = Agent.start(fn -> %{} end)
    {:ok, symbols} = Agent.start(fn -> %{} end)
    for i <- 0..length(lines)-1  do
      {:ok, line} = Enum.fetch(lines, i)
      for j <- 0..String.length(line)-1 do
          elem = String.slice(line, j..String.length(line)-1)
          char = String.slice(line, j..j)
          previous = Agent.get(agent, fn map -> Map.get(map, {i, j-1}, :missing) end)
          case Integer.parse(char) do
            :error->
              symbol = String.slice(line, j..j)
              if symbol != "." do
                Agent.update(symbols, fn state ->
                  Map.put(state, {i, j}, symbol)
                end)
              end
            {_value, _rem} when previous == :missing ->
              Agent.update(agent, fn map -> Map.put(map, {i, j}, Integer.parse(elem) |> elem(0)) end)
            {_value, _rem} ->
              Agent.update(agent, fn map -> Map.put(map, {i, j}, :invalid) end)
          end
      end
    end
    numbers = Agent.get(agent, & &1)
    numbers = Map.filter(numbers, fn {_key, value} -> value != :invalid end)
    {numbers, Agent.get(symbols, & &1)}
  end

  def generate_adj(i, j, length) do
    left_right = [{i, j-1}, {i, j+length}]
    diag = [{i-1, j-1}, {i-1, j+length}, {i+1, j-1}, {i+1, j+length}]
    up=
      for offset <- 0..length-1 do
        {i-1, j+offset}
      end

    bottom=
      for offset <- 0..length-1 do
        {i+1, j+offset}
      end

    left_right ++ diag ++ up ++ bottom
  end

  def filter_number(numbers, symbols) do
    Map.filter(numbers, fn {{i, j}, value} ->
      adj = generate_adj(i, j, Integer.digits(value) |> length())
      Enum.any?(adj, fn pos ->
        Map.get(symbols, pos, :missing) != :missing
      end)
    end)
  end

  def get_gears(numbers, symbols) do
    {:ok, gears} = Agent.start(fn -> %{} end)
    Enum.each(numbers, fn {{i, j}, value} ->
      adj = generate_adj(i, j, Integer.digits(value) |> length())
      Enum.each(adj, fn pos ->
        if Map.get(symbols, pos, :missing) == "*" do
          Agent.update(gears, fn map -> Map.update(map, pos, [value], fn prev ->  [value] ++ prev end) end)
        end
      end)
    end)
    Agent.get(gears, & &1)
  end

  def part1() do
    lines = get_lines("inputs/03/input")
    {numbers, symbols} = process(lines)
    filter_number(numbers, symbols)
    |> Map.values()
    |> Enum.sum()
  end

  def part2() do
    lines = get_lines("inputs/03/input")
    {numbers, symbols} = process(lines)
    get_gears(numbers, symbols)
    |> Enum.filter(fn {_key, value} -> length(value) == 2 end)
    |> Enum.map(fn {_key, value} -> Enum.reduce(value, 1, &( &1 * &2)) end)
    |> Enum.sum()
  end
end
