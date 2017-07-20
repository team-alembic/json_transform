defmodule JsonTransformTest do
  use ExUnit.Case
  doctest JsonTransform

  import JsonTransform

  defmodule Person do
    defstruct [:name]
  end

  @trans_fn &String.upcase/1

  def run(value), do: value |> transform(@trans_fn)

  test "keys" do
    assert run(%{"foo" => 123}) == %{"FOO" => 123}
  end

  test "deep" do
    assert run(%{"foo" => %{"bar" => 123}}) == %{"FOO" => %{"BAR" => 123}}
  end

  test "ignores string values" do
    assert run(%{"name" => "Snakey McCamelface"}) == %{"NAME" => "Snakey McCamelface"}
  end

  test "handles atom keys" do
    assert run(%{:foo => 123}) == %{"FOO" => 123}
  end

  test "ignores __struct__" do
    assert run(%JsonTransformTest.Person{name: "Camel McSnakeface"}) == %{"NAME" => "Camel McSnakeface"}
  end

  test "lists" do
    assert run([]) == []
    assert run([1, "two", false]) == [1, "two", false]
    assert run([%{"name" => "Facey McCamelSnake"}]) == [%{"NAME" => "Facey McCamelSnake"}]
  end
end
