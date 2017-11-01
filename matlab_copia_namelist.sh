#!/bin/bash
# 
# Interpola com o matlab.
# Copia os arquivos de CICC ja interpolados para as pastas do CAM.
# Cria o namelist para cada data.
#
# Executar ./matlab_copia_namelist.sh  <arquivo.txt>
#
# Feito por Gyslla - DV(20170330)
#
#

FILE=$1

CAMINHO_ARQ_INTERPOLADOS='/home/cam/CAM_OPERACIONAL/ESTRUTURA_DE_DOWNLOAD/ARQUIVOS_CAM_ALTERADOS'
CAMINHO_CI_CAM='/home/cam/cam3/atm/cam/inic/gaus'
CAMINHO_SST_CAM='/home/cam/cam3/atm/cam/sst'
CAMINHO_CAM='/home/cam/cam3'


function cria_namelist(){

    _dtime=600
    _nelapse="-150"
    _nsrest=0

    _rodada="${rodada:2:6}"

    echo "&camexp" > namelist_op_${rodada:0:8}
    echo " absems_data		= '/home/cam/cam3/atm/cam/rad/abs_ems_factors_fastvx.c030508.nc'" >> namelist_op_${rodada:0:8}
    echo " aeroptics		= '/home/cam/cam3/atm/cam/rad/AerosolOptics_c040105.nc'" >> namelist_op_${rodada:0:8}
    echo " bnd_topo		= '/home/cam/cam3/atm/cam/topo/topo-from-cami_0000-09-01_128x256_L26_c040422.nc'" >> namelist_op_${rodada:0:8}
    echo " bndtvaer		= '/home/cam/cam3/atm/cam/rad/AerosolMass_V_128x256_clim_c031022.nc'" >> namelist_op_${rodada:0:8}
    echo " bndtvo		= '/home/cam/cam3/atm/cam/ozone/pcmdio3.r8.64x1_L60_clim_c970515.nc'" >> namelist_op_${rodada:0:8}
    echo " bndtvs		= '/home/cam/cam3/atm/cam/sst/sst_HadOIBl_bc_128x256_clim_c${rodada:0:8}.nc'" >> namelist_op_${rodada:0:8}
    echo " caseid		= 'r$_rodada'" >> namelist_op_${rodada:0:8}
    echo " dtime		= $_dtime" >> namelist_op_${rodada:0:8}
    echo " iyear_ad	= 1950" >> namelist_op_${rodada:0:8}
    echo " ncdata		= '/home/cam/cam3/atm/cam/inic/gaus/cami_128x256_L26_c${rodada:0:8}.nc'" >> namelist_op_${rodada:0:8}
    echo " nelapse		= $_nelapse" >> namelist_op_${rodada:0:8}
    echo " nsrest		= $_nsrest" >> namelist_op_${rodada:0:8}
    echo "/" >> namelist_op_${rodada:0:8}
    echo "&clmexp" >> namelist_op_${rodada:0:8}
    echo " finidat		= '/home/cam/cam3/lnd/clm2/inidata_2.1/cam/clmi_0000-09-01_128x256_c040422.nc'" >> namelist_op_${rodada:0:8}
    echo " fpftcon		= '/home/cam/cam3/lnd/clm2/pftdata/pft-physiology'" >> namelist_op_${rodada:0:8}
    echo " fsurdat		= '/home/cam/cam3/lnd/clm2/srfdata/cam/clms_128x256_c031031.nc'" >> namelist_op_${rodada:0:8}
    echo "/" >> namelist_op_${rodada:0:8}

}


clear

i=0

while read rodada; do

      echo ""
      echo ""
      echo ">>> Interpolando o dia ${rodada:0:8}"
      echo ""
      echo ""

      cd /home/cam/CAM_OPERACIONAL/ESTRUTURA_DE_DOWNLOAD/

      matlab -nodesktop -nosplash -nodisplay -r "cfs2cam3gy('${rodada:0:8}'); quit"


      # O matlab criara um arquivo chamado "done" para indicar que finalizou com sucesso.
      # Caso o arquivo nao seja encontrado, a informacao da data com erro sera armazenada em um txt.
      # Caso o matlab tenha concluido com sucesso é necessario que o arquivo seja excluido para um proximo teste ser valido.

      if [ ! -e "/home/cam/CAM_OPERACIONAL/ESTRUTURA_DE_DOWNLOAD/done" ]; then
          echo "Falha no matlab >>> Rodada ${rodada:0:8}."
          echo "Falha no matlab >>> Rodada ${rodada:0:8}." >> /home/cam/cam3/erro.txt
          break
      else
          rm -f /home/cam/CAM_OPERACIONAL/ESTRUTURA_DE_DOWNLOAD/done
      fi

      echo ""
      echo ">>> Copiando a CICC da rodada ${rodada:0:8}"
      echo ""

      cp $CAMINHO_ARQ_INTERPOLADOS'/sst_HadOIBl_bc_128x256_clim_c'${rodada:0:8}'.nc' $CAMINHO_SST_CAM'/'
      cp $CAMINHO_ARQ_INTERPOLADOS'/cami_128x256_L26_c'${rodada:0:8}'.nc' $CAMINHO_CI_CAM'/'

      cd /home/cam/cam3/

      echo ">>> Criando o namelist $(( i+1 )) >>> Rodada ${rodada:0:8}"; cria_namelist
     
      let i=i+1

done < $FILE

echo ""
