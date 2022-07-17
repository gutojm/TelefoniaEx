defmodule Recarga do
  defstruct data: nil, valor: nil

  def nova(data, valor, numero) do
    assinante = Assinante.buscar(numero, :prepago)
    plano = assinante.plano

    plano = %Prepago{
      plano
      | creditos: plano.creditos + valor,
        recargas: plano.recargas ++ [%Recarga{data: data, valor: valor}]
    }

    assinante = %Assinante{assinante | plano: plano}

    Assinante.atualizar(numero, assinante)

    {:ok, assinante}
  end
end
