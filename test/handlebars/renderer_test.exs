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
    expr = [{:text, 1, 'Goodbye\n'}, {:mustache, 1, 'adj'}, {:text,1,'\n'}, {:mustache, 1, 'noun'},{:text,1,'!'}] 
    
    assert R.execute(expr, %{"adj" => "cruel", "noun" => "world"}) 
      == {:ok, 'Goodbye\ncruel\nworld!'}
  end

  test "booleans" do
    expr = [ 
      {:mustache_open, 1, 'goodbye'},
      {:text, 1, 'GOODBYE '},
      {:mustache_close, 1, 'goodbye'},
      {:text, 1, 'cruel '},
      {:mustache, 1, 'noun'},
      {:text, 1, '!'},
    ]

    # booleans show the contents when true
    assert R.execute( expr, %{ "goodbye" => true, "noun" => "world"}) == {:ok,'GOODBYE cruel world!'}

    # booleans do not show the contents when false
    assert R.execute( expr, %{ "goodbye" => false, "noun" => "world"}) == {:ok,'cruel world!'}
  end


  # test "eval boolean" do
  #   assert R.eval_boolean( %{"value" => true}, "value") == true
  # end
end
