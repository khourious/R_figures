---
title: "Dados no R"
author: "Joyce"
output: html_document
---

# Introdução

aqui nós veremos os tipos de dados mais comuns de trabalhar no R.

## O que são dados?

No R, os dados geralmente são organizados em tabelas (data frames), que parecem planilhas de Excel. Cada coluna representa uma variável (idade, nome, altura...) e cada linha representa uma observação (uma pessoa, um animal, um experimento...).

Você pode criar dados manualmente:

|Tipo	  |Exemplo	                            | Descrição                                                                 |
|:-------:|-------------------------------------|---------------------------------------------------------------------------|
|Numérico |	x <- 3.14                           | Números com ou sem decimais (ex: 10, 2.5)                                 |
|Inteiro  |	x <- 5L	                            | Números inteiros (o L indica "integer")                                   |
|Caracter |	cidade <- "Salvador"                | Texto (também chamado de string)                                          |
|Lógico   |	ativo <- TRUE                       | Verdadeiro ou falso (TRUE ou FALSE)                                       |
|Fator    |	sexo <- factor(c("F", "M", "F"))    | Valores categóricos (muito usados em estatística)                         |
|Complexo |	z <- 2 + 3i	                        | Números complexos com parte imaginária                                    |
|Data     |	hoje <- as.Date("2025-06-21")       | Datas reconhecidas como tipo próprio                                      |
|:-------:|-------------------------------------|---------------------------------------------------------------------------|

