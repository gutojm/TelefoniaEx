defmodule Assinante do
  @moduledoc """
  Modulo de assinante para cadastro de tipos de assinantes como `prepago` e `pospago`

  A função mais utilizada é `cadastrar/4`
  """

  defstruct nome: nil, numero: nil, cpf: nil, plano: nil

  @assinantes %{prepago: "pre.txt", pospago: "pos.txt"}

  @doc """
  Funcao para buscar assinante

  ## Parametros da funcao

  - numero: numero unico
  - key: opcional e caso não seja informado buscará tanto em `prepago` como  `pospago`

  ## Exemplos

      iex> Assinante.cadastrar("Joao", "123123", "123123", :prepago)
      iex> Assinante.buscar("123123")
      %Assinante{cpf: "123123", nome: "Joao", numero: "123123", plano: %Prepago{}}
      iex> Assinante.buscar("123123", :prepago)
      %Assinante{cpf: "123123", nome: "Joao", numero: "123123", plano: %Prepago{}}
      iex> Assinante.buscar("123123", :pospago)
      nil
  """

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

  @doc """
  Funcao para cadastrar assinante seja ele `prepago` ou `pospago`

  ## Parametros da funcao

  - nome: nome do assinante
  - numero: numero unico e caso exista será retornado erro
  - cpf: cpf do assinante
  - plano: opcional e caso não seja informado será cadastrado um assinante `prepago`

  ## Exemplo

      iex> Assinante.cadastrar("Joao", "123123", "123123", :prepago)
      {:ok, "Assinante Joao cadastrado com sucesso"}
  """

  def cadastrar(nome, numero, cpf, :prepago), do: cadastrar(nome, numero, cpf, %Prepago{})
  def cadastrar(nome, numero, cpf, :pospago), do: cadastrar(nome, numero, cpf, %Pospago{})

  def cadastrar(nome, numero, cpf, plano) do
    case buscar(numero) do
      nil ->
        assinante = %__MODULE__{nome: nome, numero: numero, cpf: cpf, plano: plano}

        read(pega_plano(assinante)) ++ [assinante]
        |> :erlang.term_to_binary()
        |> write(pega_plano(assinante))

        {:ok, "Assinante #{nome} cadastrado com sucesso"}
      _assinante -> {:error, "Assinante com este numero já cadastrado"}
    end
  end

  defp pega_plano (assinante) do
    case assinante.plano do
      %Prepago{} -> :prepago
      _ -> :pospago
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

  def deletar(numero) do
    case buscar(numero) do
      nil -> {:error, "Assinante não encontrado!"}
      assinante ->
        result = listar()
        |> List.delete(assinante)
        |> :erlang.term_to_binary()
        |> write(assinante.plano)

        {result, "Assinante #{assinante.nome} deletado!"}
    end
  end
end
