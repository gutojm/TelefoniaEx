defmodule Telefonia do

  def cadastrar_assinante(nome, numero, cpf) do
    %Assinante{nome: nome, numero: numero, cpf: cpf}
  end
end
