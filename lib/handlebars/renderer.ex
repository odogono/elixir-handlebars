defmodule Handlebars.Renderer do
    @moduledoc """
        Converts a tokenized mustache document expression into a string
    """

    def execute( expr, context \\ %{}) do
        {:ok, eval(expr,context) }
    end

    defp eval( [h|t], context ) do
        eval(h,context) ++ eval(t,context)
    end

    defp eval( [], context ) do
        ''    
    end

    defp eval( {:text, line, text}, context ) do
        text
    end

    defp eval( {:mustache, line, data}, context ) do
        to_char_list( Map.get( context, to_string(data), '' ) )
    end


end