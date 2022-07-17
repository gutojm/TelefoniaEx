defmodule Prepago do
  defstruct creditos: 0, recargas: []

  @preco_minuto 1.45

  def fazer_chamada(numero, data, duracao) do
    assinante = Assinante.buscar(numero, :prepago)
    custo = @preco_minuto * duracao

    cond do
      custo <= assinante.plano.creditos ->
        plano = assinante.plano
        plano = %__MODULE__{plano | creditos: plano.creditos - custo}

        %Assinante{assinante | plano: plano}
        |> Chamada.registrar(data, duracao)

        {:ok, "A chamada custou #{custo}, e voce tem #{plano.creditos} de creditos"}

      true ->
        {:error, "Voce não tem credito para fazer a ligacao, faça uma recarga"}
    end
  end

  def imprimir_conta(ano, mes, numero) do
    Contas.imprimir(ano, mes, numero, :prepago)
  end
end
