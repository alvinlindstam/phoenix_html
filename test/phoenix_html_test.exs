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
    assert escape_javascript("") == ""
    assert escape_javascript("\\Double backslash") == "\\\\Double backslash"
    assert escape_javascript("\"Double quote\"") == "\\u0022Double quote\\u0022"
    assert escape_javascript("'Single quote'") == "\\u0027Single quote\\u0027"
    assert escape_javascript("New line\r") == "New line\\r"
    assert escape_javascript("New line\n") == "New line\\n"
    assert escape_javascript("New line\r\n") == "New line\\r\\n"
    assert escape_javascript("</close>") == "\\u003C/close\\u003E"
    assert escape_javascript("Ampersand&") == "Ampersand\\u0026"
    assert escape_javascript("Line separator\u2028") == "Line separator\\u2028"
    assert escape_javascript("Paragraph separator\u2029") == "Paragraph separator\\u2029"
    assert escape_javascript("Null character\u0000") == "Null character\\u0000"
    assert escape_javascript({:safe, "'Single quote'"}) == {:safe, "\\u0027Single quote\\u0027"}
    assert escape_javascript({:safe, ["'Single quote'"]}) == {:safe, "\\u0027Single quote\\u0027"}
  end

  test "only accepts valid iodata" do
    assert Phoenix.HTML.Safe.to_iodata("foo") == "foo"
    assert Phoenix.HTML.Safe.to_iodata('foo') == 'foo'
    assert_raise ArgumentError, ~r/templates only support iodata/, fn ->
      Phoenix.HTML.Safe.to_iodata('foo🐥')
    end
  end
end
