#!/bin/bash
# Copia os arquivos de CICC ja interpolados para as pastas do CAM.
#
# Executar ./copia_cicc_interpol_cam_txt.sh  <arquivo.txt>
#
# Feito por Gyslla - DV(20170217)
#
#

FILE=$1
CAMINHO_ARQ_INTERPOLADOS='/home/cam/CAM_OPERACIONAL/ESTRUTURA_DE_DOWNLOAD/ARQUIVOS_CAM_ALTERADOS'
CAMINHO_CI_CAM='/home/cam/cam3/atm/cam/inic/gaus'
CAMINHO_SST_CAM='/home/cam/cam3/atm/cam/sst'

clear

i=0

echo ""

while read rodada; do
      echo ">>> $(( i+1 )) >>> Copiando a CICC da rodada $rodada"
      cp $CAMINHO_ARQ_INTERPOLADOS'/sst_HadOIBl_bc_128x256_clim_c'${rodada:0:8}'.nc' $CAMINHO_SST_CAM'/'
      cp $CAMINHO_ARQ_INTERPOLADOS'/cami_128x256_L26_c'${rodada:0:8}'.nc' $CAMINHO_CI_CAM'/'
      let i=i+1 
done < $FILE

echo ""

