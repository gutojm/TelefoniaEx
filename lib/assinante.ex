defmodule Assinante do
  @moduledoc """
  Modulo de assinante para cadastro de tipos de assinantes como `prepago` e `pospago`

  A função mais utilizada é `cadastrar/4`
  """

  defstruct nome: nil, numero: nil, cpf: nil, plano: nil, chamadas: []

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

      iex> {:ok, _assinante} = Assinante.cadastrar("Joao", "123123", "123123", :prepago)
  """

  def cadastrar(nome, numero, cpf, :prepago), do: cadastrar(nome, numero, cpf, %Prepago{})
  def cadastrar(nome, numero, cpf, :pospago), do: cadastrar(nome, numero, cpf, %Pospago{})

  def cadastrar(nome, numero, cpf, plano) do
    case buscar(numero) do
      nil ->
        assinante = %__MODULE__{nome: nome, numero: numero, cpf: cpf, plano: plano}

        (read(pega_plano(assinante)) ++ [assinante])
        |> write_file(pega_plano(assinante))

        {:ok, assinante}

      _assinante ->
        {:error, "Assinante com este numero já cadastrado"}
    end
  end

  def atualizar(numero, assinante) do
    case deletar_item(numero) do
      {:error, :not_found} ->
        {:error, "Assinante não encontrado!"}

      {:ok, assinante_antigo, lista} ->
        case pega_plano(assinante) == pega_plano(assinante_antigo) do
          true ->
            (lista ++ [assinante])
            |> write_file(pega_plano(assinante))

          false ->
            {:error, "Assinante nao pode alterar o plano"}
        end
    end
  end

  defp pega_plano(assinante) do
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

      _ ->
        []
    end
  end

  def deletar(numero) do
    case deletar_item(numero) do
      {:error, :not_found} ->
        {:error, "Assinante não encontrado!"}

      {:ok, assinante, lista} ->
        lista
        |> write_file(pega_plano(assinante))

        {:ok, "Assinante #{assinante.nome} deletado!"}
    end
  end

  def deletar_item(numero) do
    case buscar(numero) do
      nil ->
        {:error, :not_found}

      assinante ->
        lista =
          listar()
          |> List.delete(assinante)

        {:ok, assinante, lista}
    end
  end

  def write_file(lista, plano) do
    lista
    |> :erlang.term_to_binary()
    |> write(plano)
  end
end
