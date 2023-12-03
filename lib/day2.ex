defmodule Day2 do

  def get_lines(file) do
    File.read!(file) |> String.split("\n")
  end

  def parse_line(line) do
    [game, pulls] = String.split(line, ":")
    [_, game_id] = String.split(game, " ")
    {game_id, _} = Integer.parse(game_id)
    pulls = String.split(pulls, ";")
    pulls = Stream.map(pulls, fn pull ->
      pull = String.split(pull, ",")
      Stream.map(pull, fn subpull ->
        [quantity, category] = String.trim(subpull) |> String.split(" ")
        {quantity, _} = Integer.parse(quantity)
        {quantity, category}
      end) |> Enum.to_list()
    end) |> Enum.to_list()
    {game_id, pulls}
  end

  def is_less_max({_game_id, pulls}, maxs) do
    Enum.all?(pulls, fn pull ->
      Enum.all?(pull, fn {quantity, category} ->
        Map.get(maxs, category) >= quantity
      end)
    end)
  end

  def part1() do
    get_lines("inputs/02/input")
    |> Stream.map(&(parse_line(&1)))
    |> Stream.filter(&(is_less_max(&1, %{"red" => 12, "green" => 13, "blue" => 14})))
    |> Stream.map(fn {game_id, _} -> game_id end)
    |> Enum.sum()
  end

  def min_usage({_game_id, pulls}) do
    {:ok, agent} = Agent.start(fn -> %{} end)
    Enum.each(pulls, fn pull ->
      Enum.each(pull, fn {quantity, category} ->
        map = Agent.get(agent, & &1)
        previous_min = Map.get(map, category, 0)
        Agent.update(agent, &(Map.put(&1, category, max(previous_min, quantity))))
      end)
    end)
    Agent.get(agent, & &1)
  end

  def power(map) do
    map
    |> Map.values()
    |> Enum.reduce(1, &(&1 * &2))
  end

  def part2() do
    get_lines("inputs/02/input")
    |> Stream.map(&(parse_line(&1)))
    |> Stream.map(&(min_usage(&1)))
    |> Stream.map(&(power(&1)))
    |> Enum.sum()
  end
end
