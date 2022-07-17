defmodule Contas do
  def imprimir(ano, mes, numero, plano) do
    assinante = Assinante.buscar(numero)

    chamadas_do_mes = busca_elementos_mes(assinante.chamadas, ano, mes)

    cond do
      plano == :prepago ->
        recargas_do_mes = busca_elementos_mes(assinante.plano.recargas, ano, mes)
        plano = %Prepago{assinante.plano | recargas: recargas_do_mes}
        %Assinante{assinante | chamadas: chamadas_do_mes, plano: plano}
      plano == :pospago ->
        %Assinante{assinante | chamadas: chamadas_do_mes}
    end
  end

  defp busca_elementos_mes(elementos, ano, mes) do
    Enum.filter(elementos, & &1.data.year == ano && &1.data.month == mes)
  end
end
