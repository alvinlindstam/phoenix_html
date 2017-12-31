defmodule Phoenix.HTMLTest do
  use ExUnit.Case, async: true

  use Phoenix.HTML
  doctest Phoenix.HTML

  test "html_escape/1 entities" do
    assert html_escape("foo") == {:safe, "foo"}
    assert html_escape("<foo>") == {:safe, ["&lt;", "foo", "&gt;" | ""]}
    assert html_escape("\" & \'") == {:safe, ["&quot;", " ", "&amp;", " ", "&#39;" | ""]}
  end

  test "escape_javascript/1" do
    fun = &(&1 |> escape_javascript |> safe_to_string)
    assert fun.("") == ""
    assert fun.("\\Double backslash") == "\\\\Double backslash"
    assert fun.("\"Double quote\"") == "\\u0022Double quote\\u0022"
    assert fun.("'Single quote'") == "\\u0027Single quote\\u0027"
    assert fun.("New line\r") == "New line\\r"
    assert fun.("New line\n") == "New line\\n"
    assert fun.("New line\r\n") == "New line\\r\\n"
    assert fun.("</close>") == "\\u003C/close\\u003E"
    assert fun.("Ampersand&") == "Ampersand\\u0026"
    assert fun.("Line separator\u2028") == "Line separator\\u2028"
    assert fun.("Paragraph separator\u2029") == "Paragraph separator\\u2029"
    assert fun.("Null character\u0000") == "Null character\\u0000"
    assert fun.({:safe, "'Single quote'"}) == "\\u0027Single quote\\u0027"
    assert fun.({:safe, ["'Single quote's", [?', ?Q]]}) == "\\u0027Single quote\\u0027s\\u0027Q"
  end

  test "only accepts valid iodata" do
    assert Phoenix.HTML.Safe.to_iodata("foo") == "foo"
    assert Phoenix.HTML.Safe.to_iodata('foo') == 'foo'
    assert_raise ArgumentError, ~r/templates only support iodata/, fn ->
      Phoenix.HTML.Safe.to_iodata('foo🐥')
    end
  end
end
