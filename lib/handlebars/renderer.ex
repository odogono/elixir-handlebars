defmodule Handlebars.Renderer do
    @moduledoc """
        Converts a tokenized mustache document expression into a string
    """

    def execute( expr, context \\ %{}) do
        {:ok, eval(expr,context) }
    end

    defp eval( [{:mustache_open, line, term}|t], context) do
        # IO.puts "looking for closing '#{term}' in '#{inspect(t)}'"
        # split the forthcoming tokens into those that are part of the block, and everything that comes after
        case find_block_close(t, term, [], []) do
            {:ok, tokens, rest} -> 
                if eval_boolean(context, term) do
                    # IO.puts("ok good #{inspect(tokens ++ rest)} - #{inspect(context)}")
                    eval( tokens ++ rest, context )
                else
                   eval( rest, context ) 
                end
            _ -> {:error, "closing #{term} not found"}
        end
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

    defp eval( {:mustache, line, term}, context ) do
        to_char_list( Map.get( context, to_string(term), '' ) )
    end



    defp find_block_close([{:mustache_close, line, term}|t], search_term, accum, buffer) when term == search_term do
      {:ok, accum, t}
    end

    defp find_block_close([h|t], search_term, accum, buffer) do
        # IO.puts "find_block_close #{inspect(accum++[h])}"
        find_block_close(t, search_term, accum ++ [h], buffer)
    end

    defp find_block_close([], search_term, accum, buffer) do
        {:error, "#{search_term} not found"}
    end


    defp eval_boolean( context, term ) do
        value = Map.get(context, to_string(term))
    end

end