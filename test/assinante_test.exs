defmodule AssinanteTest do
  use ExUnit.Case

  setup do
    File.rm("pre.txt")
    File.rm("pos.txt")

    on_exit(fn ->
      File.rm("pre.txt")
      File.rm("pos.txt")
    end)
  end

  describe "cadastrar/4" do
    test "criar uma conta prepago" do
      assert {:ok, %Assinante{nome: "Guto"}} = Assinante.cadastrar("Guto", "123", "123", :prepago)
    end

    test "erro ao criar usuário já existente" do
      Assinante.cadastrar("Guto", "123", "123", :prepago)

      assert Assinante.cadastrar("Guto", "123", "123", :prepago) ==
               {:error, "Assinante com este numero já cadastrado"}
    end
  end

  describe "buscar/3" do
    test "buscar pospago" do
      Assinante.cadastrar("Guto", "123", "123", :pospago)
      assert %Assinante{nome: "Guto"} = Assinante.buscar("123", :pospago)
    end

    test "buscar prepago" do
      Assinante.cadastrar("Guto", "123", "123", :prepago)
      assert %Assinante{nome: "Guto"} = Assinante.buscar("123", :prepago)
    end
  end

  describe "deletar/1" do
    test "remocao com sucesso" do
      Assinante.cadastrar("Guto", "123", "123", :prepago)
      assert Assinante.deletar("123") == {:ok, "Assinante Guto deletado!"}
    end

    test "remocao de inexistente" do
      assert Assinante.deletar("123") == {:error, "Assinante não encontrado!"}
    end
  end
end
