defmodule PospagoTest do
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

  test "deve fazer uma ligacao" do
    Assinante.cadastrar("Guto", "123", "123", :pospago)

    assert Pospago.fazer_chamada("123", DateTime.utc_now(), 5) ==
             {:ok, "Chamada feita com sucesso! duracao: 5 minutos"}
  end

  test "deve informar os valroes da conta do mes" do
    data = DateTime.utc_now()
    data_antiga = ~U[2022-06-17 21:05:34.403979Z]

    Assinante.cadastrar("Guto", "123", "123", :pospago)
    Pospago.fazer_chamada("123", data, 3)
    Pospago.fazer_chamada("123", data_antiga, 3)
    Pospago.fazer_chamada("123", data, 3)
    Pospago.fazer_chamada("123", data, 3)

    assinante = Pospago.imprimir_conta(data.year, data.month, "123")

    assert assinante.numero == "123"
    assert Enum.count(assinante.chamadas) == 3
    assert assinante.plano.valor ==  12.599999999999998
  end

end
