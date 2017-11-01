#!/bin/bash
# Pega os arquivos de CICC para cinco meses de previsao dos anos pre-definidos.
#
# Executar ./pega_cicc_ano.sh
#
# Os arquivos serao baixados a partir do diretorio onde o script for executado.
# As pastas seguirao o padrao: AAAAMMDD --> CI e AAAAMMDD --> SST
# Comentarios deixados para testes.
# Feito por Gyslla - DV(20170325)
# Alteracoes:
#
#

NP=5; #Recebe o numero de previsoes a serem baixadas.
ERRO=0; #Recebe a quantidade de CICC com erro.
hoje=$(date +%Y%m%d)
CICC=1;
#yyyy=(2014 2013 2012 2011); #Vetor que define os anos a serem baixados.
#mm=(12 11 10 09 08 07 06 05 04 03 02 01); #Vetor que define os meses do ano a serem baixados.
#dd=(10 09 08 07 06 05); #Vetor que define os dias, conforme nossa metodologia, a serem baixados.

yyyy=(2012); #Vetor que define os anos a serem baixados.
mm=(07 06 05 04 03 02 01); #Vetor que define os meses do ano a serem baixados.
dd=(10 09 08 07 06 05); #Vetor que define os dias, conforme nossa metodologia, a serem baixados.


function erro_no_download(){
    echo ""
    let ERRO++
    vetor_datas_erro=( ${vetor_datas_erro[@]} $ano$mes$dia ); Cria um vetor com as CICC que apresentaram erro.
}

clear

for y in ${yyyy[@]}; do

    ano=$y

    for m in ${mm[@]}; do

        mes=$m

        for d in ${dd[@]}; do

            dia=$d
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

            vetor_datas=( ${vetor_datas[@]} $ano$mes$dia )

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

            wget https://nomads.ncdc.noaa.gov/modeldata/cfsv2_forecast_6-hourly_9mon_pgbf/$ano/$ano$mes/$ano$mes$dia/$anomesdia/pgbanl.01.$anomesdia.grb2 || {
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

	              wget https://nomads.ncdc.noaa.gov/modeldata/cfsv2_forecast_mm_9mon/$ano/$ano$mes/$ano$mes$dia/$anomesdia/ocnf.01.$anomesdia.$ano_i$mes_ii.avrg.grib.grb2 || {
                     echo "Falha no download de ocnf.01.$anomesdia.$ano_i$mes_ii.avrg.grib.grb2."; erro_no_download
                     echo "Falha no download de ocnf.01.$anomesdia.$ano_i$mes_ii.avrg.grib.grb2."  >> erro$ano$mes$dia.txt
 	              } #wget2

	              wget https://nomads.ncdc.noaa.gov/modeldata/cfsv2_forecast_mm_9mon/$ano/$ano$mes/$ano$mes$dia/$anomesdia/pgbf.01.$anomesdia.$ano_i$mes_ii.avrg.grib.grb2 || {
                     echo "Falha no download de pgbf.01.$anomesdia.$ano_i$mes_ii.avrg.grib.grb2."; erro_no_download
                     echo "Falha no download de pgbf.01.$anomesdia.$ano_i$mes_ii.avrg.grib.grb2."   >> erro$ano$mes$dia.txt
 	              } #wget3

	              if [ $mes_i -eq 12 ]; then
                   #Se o mes for dezembro.
	                 let ano_i++
	                 let mes_i=1
	                 mes_ii='01'
	              else
		               let mes_i++
                   if [ $mes_i -le 9 ]; then
			                mes_ii="0$mes_i"
		               else
			                mes_ii="$mes_i"
		               fi
	              fi
             done

             cd ..
             cd ..

             let CICC++

        done
    done
done

echo ""
echo ""
echo "Data(s):"

i=1
let CICC=CICC-1
for i in $(seq 1 $CICC); do
  echo ">>> "${vetor_datas[$i-1]}
  echo ${vetor_datas[$i-1]}   >> datas$hoje.txt
done

echo "Quantidade de CICC baixadas: $CICC"

if [ $ERRO -gt 0 ]; then
   echo ""
   echo "Data(s) com erro:"
   i=1
   for i in $(seq 1 $ERRO); do
       echo ">>> "${vetor_datas_erro[$i-1]}
       echo ${vetor_datas_erro[$i-1]}   >> dataserro$hoje.txt
   done
fi

echo ""
echo ""
echo ">>> Fim."
echo ""
echo ""
