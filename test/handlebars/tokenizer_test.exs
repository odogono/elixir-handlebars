defmodule Handlebars.TokenizerTest do
    use ExUnit.Case
    require Handlebars.Tokenizer, as: T

    test "string" do
      assert T.tokenize("foo") == {:ok, [{:text, 'foo'}] }
    end

    test "char list" do
      assert T.tokenize('foo') == {:ok, [{:text, 'foo'}] }
    end

    test "basic" do
      assert T.tokenize("{{foo}}") == { :ok, [{:mustache, 1, 'foo'}] }
      assert T.tokenize("{{foo}} something {{bar}}") == 
          { :ok, [{:mustache, 1, 'foo'},  {:text, ' something '}, {:mustache, 1, 'bar'}] }
    end

    test "over more than one line" do
      assert T.tokenize("foo\n{{bar}}") == 
          { :ok, [{:text, 'foo\n'}, {:mustache, 2, 'bar'}] }
    end

    test "expression over more than one line" do
      string = '''
foo {{ bar

baz }}
{{ foo }}
'''
      assert T.tokenize(string) == { :ok, [
        {:text, 'foo '}, 
        {:mustache, 1, ' bar\n\nbaz '}, 
        {:text, '\n'},
        {:mustache, 2, ' foo '}, 
        {:text, '\n'}
        ] }
    end

    test "unescaping with &" do
      assert T.tokenize("{{&bar}}") == { :ok, [{:escaped_mustache, 1, 'bar'}] }
    end

    test "unescaping with triple mustache" do
      assert T.tokenize("{{{bar}}}") == { :ok, [{:escaped_mustache, 1, 'bar'}] }
    end

    test "escaping delimiters" do
      assert T.tokenize("{{foo}} \\{{bar}} {{baz}}") == 
          { :ok, [{:mustache, 1, 'foo'},  {:text, ' {{bar}} '}, {:mustache, 1, 'baz'}] }
    end
end