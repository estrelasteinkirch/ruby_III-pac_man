require_relative 'ui'

def le_mapa(numero)
  arquivo = "mapa#{numero}.txt"
  texto = File.read(arquivo)
  mapa = texto.split("\n")
end

def encontra_jogador(mapa)
  caracter_do_heroi = "H"
  mapa.each_with_index do |linha_atual, linha| #o texto da linha e a posição
      coluna_do_heroi = linha_atual.index(caracter_do_heroi) #index
      if coluna_do_heroi #dá verdadeiro se o valor nao for nil
        return [linha, coluna_do_heroi] 
        # achei!
      end
  end
  # não achei!
end

def soma_vetor(vetor1, vetor2)
  [vetor1[0] + vetor2[0], vetor1[1] + vetor2[1]]
end

def posicoes_validas_a_partir_de(mapa, novo_mapa, posicao)
  posicoes = []
  movimentos = [[+1,0], [0, +1], [-1,0], [0, -1]]
  movimentos.each do |movimento|
    nova_posicao = soma_vetor(movimento, posicao)
    if posicao_valida?(mapa, nova_posicao) && posicao_valida?(novo_mapa, nova_posicao)
      posicoes << nova_posicao
    end
  end
  posicoes 
end

def move_fantasma(mapa, novo_mapa, linha, coluna)
  posicoes = posicoes_validas_a_partir_de(mapa, novo_mapa, [linha, coluna])
  
  if posicoes.empty?
    return #early return se nao tiver nenhuma posicao válida
  end
  aleatoria = rand(posicoes.size)
  posicao = posicoes[aleatoria]

  mapa[linha][coluna] = " " #mapa_antigo
  novo_mapa[posicao[0]][posicao[1]] = "F"
end

def move_fantasmas(mapa)
  caracter_do_fantasma = "F"
  novo_mapa = copia_mapa(mapa)
  mapa.each_with_index do |linha_atual, linha|
    linha_atual.chars.each_with_index do |caractere_atual, coluna| #o texto da coluna e a posição
      #o chars transforma a string em um array de caracteres
      eh_fantasma = caractere_atual == caracter_do_fantasma
      if eh_fantasma
        move_fantasma(mapa, novo_mapa, linha, coluna)
      end
    end
  end
  novo_mapa
end


def calcula_nova_posicao(heroi, direcao)
  heroi = heroi.dup
  # linhda = posição 0 da array, coluna = posição 1
    movimentos = { #dicionário // array associativo
      "W" => [-1, 0],
      "S" => [+1, 0],
      "A" => [0, -1],
      "D" => [0, +1]
      }
  movimento = movimentos[direcao]
  heroi[0] += movimento[0]
  heroi[1] += movimento[1]
  heroi
end

def posicao_valida?(mapa, posicao)
  linhas = mapa.size
  colunas = mapa[0].size

  estourou_linha = posicao[0] < 0 || posicao[0] >= linhas
  estourou_coluna = posicao[1] < 0 || posicao[1] >= colunas

  if estourou_linha || estourou_coluna
    return false
  end

  valor_atual = mapa[posicao[0]][posicao[1]]
  if valor_atual == "X" || valor_atual == "F"
    return false
  end

  true
end

def copia_mapa(mapa) #sem os fantasmas
  novo_mapa = mapa.join("\n").tr("F", " ").split"\n"
  # transformou o array numa grande string, depois traduziu os F para espaço em branco e depois tirou os \n para transformar num array de novo
end

def joga(nome)
  mapa = le_mapa(2)
  while true
    desenha mapa
    direcao = pede_movimento
    heroi = encontra_jogador(mapa)
      
    nova_posicao = calcula_nova_posicao(heroi, direcao)
    if !posicao_valida?(mapa, nova_posicao)
      next
    end
    mapa[heroi[0]][heroi[1]] = " "
    mapa[nova_posicao[0]][nova_posicao[1]] = "H"
    
    mapa = move_fantasmas(mapa)
  end
end

def inicia_pacman
    nome = da_boas_vindas
    joga(nome)
end







