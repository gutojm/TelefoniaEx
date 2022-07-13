defmodule PrepagoTest do
  use ExUnit.Case
  doctest Assinante

  setup do
    File.rm("pre.txt")
    File.rm("pos.txt")

    on_exit(fn ->
      File.rm("pre.txt")
      File.rm("pos.txt")
    end)
  end

  describe "funcoes de ligacao" do
    test "fazer uma ligacao" do
      Assinante.cadastrar("Guto", "123", "123", :prepago)

      assert Prepago.fazer_chamada("123", DateTime.utc_now(), 3) == {:ok, "A chamada custou 4.35"}
    end
  end
end
