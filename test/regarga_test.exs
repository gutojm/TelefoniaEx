defmodule RecargaTest do
  use ExUnit.Case

  setup do
    File.rm("pre.txt")
    File.rm("pos.txt")

    on_exit(fn ->
      File.rm("pre.txt")
      File.rm("pos.txt")
    end)
  end

  test "deve realizar uma regarga" do
    {:ok, assinante} = Assinante.cadastrar("Guto", "123", "123", :prepago)

    assert {:ok, assinante} = Recarga.nova(DateTime.utc_now(), 30, assinante.numero)

    plano = assinante.plano
    recargas = plano.recargas

    assert plano.creditos == 30
    assert Enum.count(recargas) == 1
  end
end
