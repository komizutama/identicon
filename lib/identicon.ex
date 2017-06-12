defmodule Identicon do
@moduledoc """
  A module that will  create an identicon based on the name of the user. it will display vertical symmetry and and produces the same identicon for the same name.
"""
# 
# String
@doc """
  This function is the main 
"""
def main(input) do
  input
  |> hash_input
end

# Compute MD5 hash of the string & Generate a list of numbers based on the string
def hash_input(input) do
  :crypto.hash(:md5, input)
  |> :binary.bin_to_list
end

# Pick a color
# Build a grid of squares
# Convert grid into image
# Save identicon to disk as an image

end
