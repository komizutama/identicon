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
  |> filter_odd_squares
  |> build_pixel_map
  |> draw_image
  |> save_image(input)
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
  grid = 
    hex
    |> Enum.chunk(3) #break into chunks of three
    #mirror_rows and put into a new list
    |> Enum.map(&mirror_row/1) #&mirror_row/1 tells it to pass everything to mirror_row with an arrity of 1
    |> List.flatten
    |> Enum.with_index

  %Identicon.Image{image | grid: grid}
end

@doc """
A helper function to mirror rows in build grid
"""
def mirror_row(row) do
    #[145, 46, 200]
    [first, second | _tail] = row
    #[145, 46, 200, 46, 145]
    row ++ [second, first]
end

@doc """
  Filters out the odd numbers and updates the struct
"""
def filter_odd_squares(%Identicon.Image{grid: grid} = image) do
  grid = Enum.filter grid, fn({code, _index}) -> 
    rem(code, 2) == 0
  end

  %Identicon.Image{image | grid: grid}#return updated version of grid in image struct
end

@doc """
 This builds a set of tuples. That will act as the defining grid points for the image
 """
def build_pixel_map(%Identicon.Image{grid: grid} = image) do
  #generate top left and bottom right points for each colored square
  pixel_map = Enum.map grid, fn({ _code, index}) ->
    horizontal = rem(index, 5) * 50
    vertical = div(index, 5) * 50

    top_left = {horizontal, vertical}
    bottom_right = {horizontal + 50, vertical + 50}

    {top_left, bottom_right}
  end

  %Identicon.Image{image | pixel_map: pixel_map}
end

@doc """
  Draws the actual image.
"""
def draw_image (%Identicon.Image{color: color, pixel_map: pixel_map}) do
  image = :egd.create(250, 250) #creates a 250px square blank canvas
  fill = :egd.color(color) #creates a color variable for use later

  #creates the filled rectangles
  Enum.each pixel_map, fn({start,stop}) ->
    :egd.filledRectangle(image, start, stop, fill)
  end

  #renders the image
  :egd.render(image)
end

# Save identicon to disk as an image
  def save_image(image, input) do
  File.write("#{input}.png", image)
  end
end
