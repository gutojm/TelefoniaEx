defmodule Telefonia do
  def cadastrar_assinante(nome, numero, cpf, plano) do
    Assinante.cadastrar(nome, numero, cpf, plano)
  end

  def listar_assinantes, do: Assinante.listar()

  def listar_assinantes_prepago, do: Assinante.listar_prepago()

  def listar_assinantes_pospago, do: Assinante.listar_pospago()

  def fazer_chamada(numero, plano, data, duracao) do
    case plano do
      :prepago -> Prepago.fazer_chamada(numero, data, duracao)
      _ -> Pospago.fazer_chamada(numero, data, duracao)
    end
  end

  def recarga(numero, data, valor), do: Recarga.nova(data, valor, numero)

  def buscar_por_numero(numero, plano \\ :all), do: Assinante.buscar(numero, plano)

  def imprimir_contas(ano, mes) do
    Assinante.listar_prepago()
    |> Enum.each(fn assinante ->
      assinante = Prepago.imprimir_conta(ano, mes, assinante.numero)
      IO.puts("Conta prepaga: #{assinante.nome}")
      IO.puts("Numero: #{assinante.numero}")
      IO.puts("Chamadas: ")
      IO.inspect(assinante.chamadas)
      IO.puts("Recargas: ")
      IO.inspect(assinante.plano.recargas)
      IO.puts("Total de chamadas: #{Enum.count(assinante.chamadas)}")
      IO.puts("Total de recargas: #{Enum.count(assinante.plano.recargas.chamadas)}")
      IO.puts("========================================================================")
    end)

    Assinante.listar_pospago()
    |> Enum.each(fn assinante ->
      assinante = Pospago.imprimir_conta(ano, mes, assinante.numero)
      IO.puts("Conta prepaga: #{assinante.nome}")
      IO.puts("Numero: #{assinante.numero}")
      IO.puts("Chamadas: ")
      IO.inspect(assinante.chamadas)
      IO.puts("Total de chamadas: #{Enum.count(assinante.chamadas)}")
      IO.puts("Valor da fatura: #{assinante.plano.valor}")
      IO.puts("========================================================================")
    end)
  end
end
