defmodule Identicon.Image do
  @moduledoc """
  This module creates the image storage structure
  """
  defstruct hex: nil, color: nil, grid: nil, pixel_map: nil
end