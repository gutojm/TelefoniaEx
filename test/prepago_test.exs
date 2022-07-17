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
      Recarga.nova(DateTime.utc_now(), 10, "123")

      assert Prepago.fazer_chamada("123", DateTime.utc_now(), 3) ==
               {:ok, "A chamada custou 4.35, e voce tem 5.65 de creditos"}
    end

    test "fazer uma ligacao longa sem creditos" do
      Assinante.cadastrar("Guto", "123", "123", :prepago)

      assert Prepago.fazer_chamada("123", DateTime.utc_now(), 13) ==
               {:error, "Voce não tem credito para fazer a ligacao, faça uma recarga"}
    end
  end
end
