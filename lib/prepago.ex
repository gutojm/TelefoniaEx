defmodule Prepago do
  defstruct creditos: 0, recargas: []

  @preco_minuto 1.45

  def fazer_chamada(numero, data, duracao) do
    assinante = Assinante.buscar(numero, :prepago)
    custo = @preco_minuto * duracao

    cond do
      custo <= 10 -> {:ok, "A chamada custou #{custo}"}
      true -> {:error, "Voce não tem credito para fazer a ligacao, faça uma recarga"}
    end
  end
end
