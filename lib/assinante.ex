defmodule Assinante do
  defstruct nome: nil, numero: nil, cpf: nil, plano: nil

  @assinantes %{prepago: "pre.txt", pospago: "pos.txt"}

  def buscar(numero, key \\ :all)
  def buscar(numero, _key = :all), do: do_buscar(listar(), numero)
  def buscar(numero, _key = :prepago), do: do_buscar(listar_prepago(), numero)
  def buscar(numero, _key = :pospago), do: do_buscar(listar_pospago(), numero)

  defp do_buscar(lista, numero) do
    Enum.find(lista, &(&1.numero == numero))
  end


  def listar_prepago(), do: read(:prepago)
  def listar_pospago(), do: read(:pospago)
  def listar(), do: listar_prepago() ++ listar_pospago()

  def cadastrar(nome, numero, cpf, plano \\ :prepago) do
    case buscar(numero) do
      nil ->
        read(plano) ++ [%__MODULE__{nome: nome, numero: numero, cpf: cpf, plano: plano}]
        |> :erlang.term_to_binary()
        |> write(plano)

        {:ok, "Assinante #{nome} cadastrado com sucesso"}
      _assinante -> {:error, "Assinante com este numero já cadastrado"}
    end



  end

  defp write(lista_assinantes, plano) do
    File.write!(@assinantes[plano], lista_assinantes)
  end

  def read(plano) do
    case File.read(@assinantes[plano]) do
      {:ok, assinantes} ->
        :erlang.binary_to_term(assinantes)
      _ -> []
    end
  end
end
