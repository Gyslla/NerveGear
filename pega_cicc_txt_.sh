#!/bin/bash
# Pega os arquivos de CICC para cinco meses direto de um txt.
#
# Executar ./pega_cicc_txt.sh <arquivo.txt>
#
# Os arquivos serao baixados a partir do diretorio onde o script for executado.
# As pastas seguirao o padrao: AAAAMMDD --> CI e AAAAMMDD --> SST
# Comentarios deixados para testes.
# Feito por Gyslla - DV(20170209)
# Alteracoes:
#
# 20170210 - Inclusao de teste das datas de entrada e conteudo do arquivo texto no inicio do primeiro while.
#          - Inclusao de teste no download do arquivo.
#          - Criacao de funcoes para diminuir a redundancia no script.
#

FILE=$1
NP=5; #Recebe o numero de previsoes a serem baixadas.

function erro_no_download(){
    echo ""
    echo ">>> Verificar a existencia do arquivo e se a data de download esta adequada."
    echo ">>> Se o problema for para baixar o primeiro arquivo de uma data de fim do mes:"
    echo ">>> 1) comente o exit da funcao erro_no_download();"
    echo ">>> 2) aumente o numero dr previsoes para pegar mais um mes (variavel NP), e"
    echo ">>> 3) coloque apenas essa data ($ano$mes$dia) no txt."
    echo ""
    echo "Apos o download retorne as modificacoes."
    echo ""
    echo ""
    exit 1
}

function erro_na_data(){
    echo ""
	echo ""
	echo ">>> Erro no arquivo texto >>> Data inválida >>> $line"
        echo ">>> Linha: "$line_i
	let line_i=line_i-1
	
	if [ $line_i -gt 0 ]; then
	   echo ""
	   break
	fi
	
	echo ">>> Quantidade de datas baixadas >>> $line_i"
	echo ""
	echo ""
    exit 1
}

clear

line_i=1
hoje=$(date +%Y%m%d)

while read line
do

data=$(date -d "$line" +%Y%m%d 2>/dev/null) || {
    echo ""; erro_na_data
}

if [ $data = $hoje ]; then
    echo ""; erro_na_data
fi

vetor_datas=( ${vetor_datas[@]} $data )

#echo "This is a line : $line"
#echo "${line:0:4}"
#echo "${line:4:2}"
#echo "${line:6:2}"

ano="${line:0:4}"
mes="${line:4:2}"
dia="${line:6:2}"
zeros='00'

echo ""
echo ""
echo ">>> Baixando os dados CICC de $dia/$mes/$ano."
echo ""
echo ""
#read -p "Pressione [Enter]..."
	
anomesdia=$ano$mes$dia$zeros
ano_i=$ano
mes_ii=$mes

case $mes in
	'01') mes_i=1;;
	'02') mes_i=2;;	
	'03') mes_i=3;;
	'04') mes_i=4;;
	'05') mes_i=5;;
	'06') mes_i=6;;
	'07') mes_i=7;;
	'08') mes_i=8;;
	'09') mes_i=9;;
	'10') mes_i=10;;
	'11') mes_i=11;;
	'12') mes_i=12;;
	*) 	read -p ">>> Erro nos meses... cancele."
esac	

mkdir $ano$mes$dia
cd $ano$mes$dia

mkdir CI
cd CI

echo ">>> Baixando o arquivo de CI pgbanl.01.$anomesdia.grb2"
echo ""
echo ""

wget https://nomads.ncdc.noaa.gov/thredds/fileServer/modeldata/cfsv2_forecast_6-hourly_9mon_pgbf/$ano/$ano$mes/$ano$mes$dia/$anomesdia/pgbanl.01.$anomesdia.grb2 || {
    echo ">>> Falha no download de pgbanl.01.$anomesdia.grb2."; erro_no_download
    echo ">>> Falha no download de pgbanl.01.$anomesdia.grb2."  >> erro$ano$mes$dia.txt
} #wget1
cd ..

mkdir SST
cd SST

echo ""
echo ""
echo ">>> Baixando os arquivos de CC (ocnf e pgbf) de $ano$mes$dia."
echo ""

for i in $(seq 1 $NP); do
	echo ""
    echo "Baixando o arquivo $i de $ano$mes$dia."
	echo ""

	#echo "Ano contador: $ano_i"
	#echo "Mes contador: "$mes_i
	#echo "Mes string: $mes_ii"
	#read -p "Press [Enter] key to continue..."

	wget https://nomads.ncdc.noaa.gov/thredds/fileServer/modeldata/cfsv2_forecast_mm_9mon/$ano/$ano$mes/$ano$mes$dia/$anomesdia/ocnf.01.$anomesdia.$ano_i$mes_ii.avrg.grib.grb2 || {
        echo "Falha no download de ocnf.01.$anomesdia.$ano_i$mes_ii.avrg.grib.grb2."; erro_no_download
        echo "Falha no download de ocnf.01.$anomesdia.$ano_i$mes_ii.avrg.grib.grb2."  >> erro$ano$mes$dia.txt
 	} #wget2
	
	wget https://nomads.ncdc.noaa.gov/thredds/fileServer/modeldata/cfsv2_forecast_mm_9mon/$ano/$ano$mes/$ano$mes$dia/$anomesdia/pgbf.01.$anomesdia.$ano_i$mes_ii.avrg.grib.grb2 || {
        echo "Falha no download de pgbf.01.$anomesdia.$ano_i$mes_ii.avrg.grib.grb2."; erro_no_download
        echo "Falha no download de pgbf.01.$anomesdia.$ano_i$mes_ii.avrg.grib.grb2."   >> erro$ano$mes$dia.txt
 	} #wget3
	
	if [ $mes_i -eq 12 ]; then
	   let ano_i++
	   let mes_i=1
	   mes_ii='01'
	   
	else
		let mes_i++
		#echo $mes_i
        if [ $mes_i -le 9 ]; then
			mes_ii="0$mes_i"
			#echo "if 1"
		else
			mes_ii="$mes_i"
			#echo "if 2"
		fi
	fi

    #echo "$ano_i"
	#echo "$anomesdia.$ano_i$mes_ii"	
done
cd ..
cd ..

let line_i++

done < $FILE

echo ""
echo ""
echo "Quantidade de datas de CICC baixadas: $line_i"
echo "Data(s):"

i=1
for i in $(seq 1 $line_i); do
  echo ">>> "${vetor_datas[$i-1]}
done

echo ""
echo ""
echo ">>> Fim."
echo ""
echo ""


