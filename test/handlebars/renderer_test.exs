defmodule RendererTest do
  use ExUnit.Case
  require Handlebars.Renderer, as: R
  # doctest Handlebars


  test "basic text" do
    assert R.execute( {:text, 1, 'foo'} ) == {:ok, 'foo' }
  end

  test "basic mustache" do
    assert R.execute( {:mustache, 1, 'msg'}, %{ "msg" => "foo"} ) == {:ok, 'foo' }
  end

  test "text with mustache" do
    assert R.execute( 
      [{:text, 1, 'foo '}, {:mustache, 1, 'msg'}, {:text, 1, ' baz'}], %{"msg" => "bar"} 
      ) == {:ok, 'foo bar baz'}
  end

end
