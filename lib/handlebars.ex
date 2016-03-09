defmodule Handlebars do
    # alias Handlebars.Parser

    @spec execute(String.t, map()) :: {:ok, String.t}
    def execute( source, data ) do
        {:error, "not implemented"}
    end


    @spec compile(String.t) :: {:ok} | {:error,String.t}
    def compile( source ) do
        {:error, "not implemented"}
    end
end
