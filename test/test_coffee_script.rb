begin
  require 'minitest/autorun'
rescue LoadError
  require 'test/unit'
end

TestCase = if defined? Minitest::Test
    Minitest::Test
  elsif defined? MiniTest::Unit::TestCase
    MiniTest::Unit::TestCase
  else
    Test::Unit::TestCase
  end

require 'coffee_script'
require 'stringio'

class TestCoffeeScript < TestCase
  def test_compile
    assert_match "puts('Hello, World!')",
      CoffeeScript.compile("puts 'Hello, World!'\n")
  end

  def test_compile_with_io
    io = StringIO.new("puts 'Hello, World!'\n")
    assert_match "puts('Hello, World!')",
      CoffeeScript.compile(io)
  end

  def test_compile_with_bare_true
    assert_no_match "function()",
      CoffeeScript.compile("puts 'Hello, World!'\n", :bare => true)
  end

  def test_compile_with_bare_false
    assert_match "function()",
      CoffeeScript.compile("puts 'Hello, World!'\n", :bare => false)
  end

  def test_compile_with_no_wrap_true
    assert_no_match "function()",
      CoffeeScript.compile("puts 'Hello, World!'\n", :no_wrap => true)
  end

  def test_compile_with_no_wrap
    assert_match "function()",
      CoffeeScript.compile("puts 'Hello, World!'\n", :no_wrap => false)
  end

  def test_compilation_error
    begin
      CoffeeScript.compile("unless")
      flunk
    rescue CoffeeScript::Error => e
      assert e
    end
  end

  def test_compilation_error_message_contains_location
    begin
      CoffeeScript.compile("puts 'Hello, World!'\nvar foo = true'\n")
    rescue CoffeeScript::Error => e
      assert_match 'SyntaxError: :2:1:', e.message
    end
  end

  def assert_no_match(expected, actual)
    assert !expected.match(actual)
  end
end
