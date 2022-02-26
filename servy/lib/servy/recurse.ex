defmodule Recurse do
  def loopy([head | tail], total) do
    IO.puts "Head: #{head} Tail: #{inspect(tail)}"


    loopy(tail, total + head)

  end

  def loopy([], total), do: total


#   def triple([head | tail], returnList) do
#     IO.puts "Head: #{inspect(head)} Tail: #{inspect(tail)}"

#     triple(tail, returnList ++ [head * 3])

#   end

#   def triple([], returnList) do
#       IO.puts "#{inspect(returnList)}"
#   end

  def triple([head|tail]) do
    [head*3 | triple(tail)]
  end

  def triple([]), do: []
end

IO.inspect Recurse.triple([1, 2, 3, 4, 5])

# IO.puts Recurse.loopy([1, 2, 3, 4, 5], 0)
# IO.puts Recurse.triple([1, 2, 3, 4, 5], [])

