defmodule Recurse do
  def loopy([head | tail], total) do
    IO.puts "Head: #{head} Tail: #{inspect(tail)}"


    loopy(tail, total + head)

  end

  def loopy([], total), do: total

  def triple([head|tail]) do
    [head*3 | triple(tail)]
  end

  def triple([]), do: []

  def my_map([head | tail], fun) do

    [fun.(head) | my_map(tail, fun)]
  end

  def my_map([], _fun), do: []

end

# IO.inspect Recurse.triple([1, 2, 3, 4, 5])

IO.inspect Recurse.my_map([1, 2, 3, 4, 5], &(&1 * 4))

# IO.puts Recurse.loopy([1, 2, 3, 4, 5], 0)
# IO.puts Recurse.triple([1, 2, 3, 4, 5], [])

