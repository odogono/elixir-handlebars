defmodule Handlebars.Tokenizer do
    @moduledoc """
    
    """

    # define default values
    def tokenize(list, line \\ 1, opts \\ [])


    def tokenize(bin, line, opts) when is_binary(bin) do
      tokenize(String.to_char_list(bin), line, opts)
    end

    def tokenize(list, line, opts) do
      tokenize(list, line, opts, [], [])
    end


    
    # handle the escaped mustache expression
    defp tokenize('{{{' ++ t, line, opts, buffer, acc) do
      case escaped_expr(t,line,[]) do
        {:error, _, _} = error -> error
        {:ok, expr, new_line, rest} ->
          # wrap up whatever text came before this token into the accumulator
          acc   = tokenize_text(buffer, acc)
          final = {:escaped_mustache, line, Enum.reverse(expr)}
          tokenize rest, new_line, opts, [], [final | acc]
      end
    end

    defp tokenize('{{&' ++ t, line, opts, buffer, acc) do
      case expr(t,line,[]) do
        {:error, _, _} = error -> error
        {:ok, expr, new_line, rest} ->
          # wrap up whatever text came before this token into the accumulator
          acc   = tokenize_text(buffer, acc)
          final = {:escaped_mustache, line, Enum.reverse(expr)}
          tokenize rest, new_line, opts, [], [final | acc]
      end
    end

    defp tokenize('{{' ++ t, line, opts, buffer, acc) do
      case expr(t,line,[]) do
        {:error, _, _} = error -> error
        {:ok, expr, new_line, rest} ->
          # wrap up whatever text came before this token into the accumulator
          acc   = tokenize_text(buffer, acc)
          final = {:mustache, line, Enum.reverse(expr)}
          tokenize rest, new_line, opts, [], [final | acc]
      end
    end

    # an escaped mustache opening tag - we simply add this to the buffer and continue
    defp tokenize('\\{{' ++ t, line, opts,buffer,acc) do
      tokenize t, line, opts, [?{,?{|buffer], acc
    end

    defp tokenize('\n' ++ t, line, opts, buffer, acc) do
      tokenize t, line + 1, opts, [?\n|buffer], acc
    end

    defp tokenize([h|t], line, opts, buffer, acc) do
      tokenize t, line, opts, [h|buffer], acc
    end

    defp tokenize([], _line, _opts, buffer, acc) do
      {:ok, Enum.reverse(tokenize_text(buffer, acc))}
    end


    # Tokenize an expression until we find }}

    defp expr([?}, ?}|t], line, buffer) do
      {:ok, buffer, line, t}
    end

    defp expr([h|t], line, buffer) do
      expr t, line, [h|buffer]
    end  

    # Tokenize an expression until we find }}}

    defp escaped_expr([?},?},?}|t], line, buffer) do
      {:ok, buffer, line, t}
    end

    defp escaped_expr([h|t], line, buffer) do
      escaped_expr t, line, [h|buffer]
    end

    # Tokenize the buffered text by appending
    # it to the given accumulator.

    defp tokenize_text([], acc) do
      acc
    end

    defp tokenize_text(buffer, acc) do
      [{:text, Enum.reverse(buffer)} | acc]
    end


    # determine the type of token

    defp token_name(_token) do
      :mustache
    end
end