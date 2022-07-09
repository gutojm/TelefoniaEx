defmodule Assinante do
  defstruct nome: nil, numero: nil, cpf: nil, plano: nil

  @assinantes %{prepago: "pre.txt", pospago: "pos.txt"}

  def buscar(numero) do
    prepago = read(:prepago) ++ read(:pospago)
    Enum.find(prepago, &(&1.numero == numero))
  end

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
    with {:ok, assinantes} <- File.read(@assinantes[plano]) do
      :erlang.binary_to_term(assinantes)
    else
      _ -> []
    end
  end
end
