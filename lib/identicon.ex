defmodule Identicon do
@moduledoc """
  A module that will  create an identicon based on the name of the user. it will display vertical symmetry and and produces the same identicon for the same name.
"""
# 
# String
@doc """
  Main  operation call. It takes a single argument
"""
def main(input) do
  input
  |> hash_input
  |> pick_color
  |> build_grid
end

@doc """
  Computes MD5 hash of the string & Generate a list of numbers based on the string
  """
def hash_input(input) do
  hex = :crypto.hash(:md5, input)
  |> :binary.bin_to_list

  %Identicon.Image{hex: hex}
end

@doc """
 Pick RGB color based on the first 3 values of the list. and add it to the image struct
 """
 def pick_color(%Identicon.Image{hex: [r, g, b | _tail ]} = image) do
   %Identicon.Image{image | color: {r, g, b}}
 end

@doc """
Grid of square will consist of a five by five pattern read from L2R  3 number packets will be used to determine value. The first number => first square, second number=> second square third # => middle square value and then it mirrors. If the number is even then it will be  a colored square, if it is odd it will be white.  
"""
def build_grid(%Identicon.Image{hex: hex} = image) do
  hex
  |> Enum.chunk(3) #break into chunks of three
  #mirror_rows and put into a new list
  |> Enum.map(&mirror_row/1) #&mirror_row/1 tells it to pass everything to mirror_row with an arrity of 1
end

@doc """
helper function to mirror rows in build grid
"""
def mirror_row(row) do
    #[145, 46, 200]
    [first, second | _tail] = row
    #[145, 46, 200, 46, 145]
    row ++ [second, first]
  end
# Convert grid into image
# Save identicon to disk as an image

end
