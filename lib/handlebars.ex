defmodule Handlebars do
    # alias Handlebars.Parser

    @spec eval_string(String.t, map()) :: {:ok, String.t}
    def eval_string( source, data ) do
        {:error, "not implemented"}
    end


    @spec compile(String.t) :: {:ok} | {:error,String.t}
    def compile( source ) do
        {:error, "not implemented"}
    end
end
