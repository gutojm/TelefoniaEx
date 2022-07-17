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

  describe "testes para impressao de contas" do
    test "deve informar os valroes da conta do mes" do
      data = DateTime.utc_now()
      data_antiga = ~U[2022-06-17 21:05:34.403979Z]

      Assinante.cadastrar("Guto", "123", "123", :prepago)
      Recarga.nova(data_antiga, 10, "123")
      Prepago.fazer_chamada("123", data_antiga, 3)
      Recarga.nova(data, 10, "123")
      Prepago.fazer_chamada("123", data, 3)

      assinante = Prepago.imprimir_conta(data.year, data.month, "123")

      assert assinante.numero == "123"
      assert Enum.count(assinante.chamadas) == 1
      assert Enum.count(assinante.plano.recargas) == 1
    end
  end
end
