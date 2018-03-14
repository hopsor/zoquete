defmodule ZoqueteWeb.PageController do
  use ZoqueteWeb, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
