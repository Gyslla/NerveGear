#!/bin/bash
# Cria arquivos namelist para rodadas com nsrest ativado para uma data especifica.
#
# Executar ./cria_namelist_reset.sh <AAAAMMDD>
#
# Serao criados 4 arquivos, sendo o primeiro para a rodada teste, com apenas 10 dias e
# e dtime = 150, a fim de reduzir os erros no inicio do processo.
# 
# Feito por Gyslla - DV(20170217)
#
#

rodada=$1

function cria_namelist(){

    case $i in
     0) 
        _dtime=150
        _nelapse="-10"
        _nsrest=0;;
     1)
        _dtime=600
        _nelapse="-20"
        _nsrest=1;;
     2)
        _dtime=600
        _nelapse="-60"
        _nsrest=1;;
     3)
        _dtime=600
        _nelapse="-60"
        _nsrest=1;;
     *) read -p ">>> Erro... cancele."
    esac

    rodadaAA="${rodada:2:6}"

    echo "&camexp" > namelist_op_$rodada'_'$i
    echo " absems_data		= '/home/LABMETA/CAM3/ALFA/atm/cam/rad/abs_ems_factors_fastvx.c030508.nc'" >> namelist_op_$rodada'_'$i
    echo " aeroptics		= '/home/LABMETA/CAM3/ALFA/atm/cam/rad/AerosolOptics_c040105.nc'" >> namelist_op_$rodada'_'$i
    echo " bnd_topo		= '/home/LABMETA/CAM3/ALFA/atm/cam/topo/topo-from-cami_0000-09-01_128x256_L26_c040422.nc'" >> namelist_op_$rodada'_'$i
    echo " bndtvaer		= '/home/LABMETA/CAM3/ALFA/atm/cam/rad/AerosolMass_V_128x256_clim_c031022.nc'" >> namelist_op_$rodada'_'$i
    echo " bndtvo		= '/home/LABMETA/CAM3/ALFA/atm/cam/ozone/pcmdio3.r8.64x1_L60_clim_c970515.nc'" >> namelist_op_$rodada'_'$i
    echo " bndtvs		= '/home/LABMETA/CAM3/ALFA/atm/cam/sst/sst_HadOIBl_bc_128x256_clim_c$rodada.nc'" >> namelist_op_$rodada'_'$i
    echo " caseid		= 'r$rodadaAA'" >> namelist_op_$rodada'_'$i
    echo " dtime		= $_dtime" >> namelist_op_$rodada'_'$i
    echo " iyear_ad	= 1950" >> namelist_op_$rodada'_'$i
    echo " ncdata		= '/home/LABMETA/CAM3/ALFA/atm/cam/inic/gaus/cami_128x256_L26_c$rodada.nc'" >> namelist_op_$rodada'_'$i
    echo " nelapse		= $_nelapse" >> namelist_op_$rodada'_'$i
    echo " nsrest		= $_nsrest" >> namelist_op_$rodada'_'$i
    echo "/" >> namelist_op_$rodada'_'$i
    echo "&clmexp" >> namelist_op_$rodada'_'$i
    echo " finidat		= '/home/LABMETA/CAM3/ALFA/lnd/clm2/inidata_2.1/cam/clmi_0000-09-01_128x256_c040422.nc'" >> namelist_op_$rodada'_'$i
    echo " fpftcon		= '/home/LABMETA/CAM3/ALFA/lnd/clm2/pftdata/pft-physiology'" >> namelist_op_$rodada'_'$i
    echo " fsurdat		= '/home/LABMETA/CAM3/ALFA/lnd/clm2/srfdata/cam/clms_128x256_c031031.nc'" >> namelist_op_$rodada'_'$i
    echo "/" >> namelist_op_$rodada'_'$i

}

clear

i=0

echo ""

while [ $i -le 3 ]; do
      echo ">>> Criando o namelist $(( i+1 )) da rodada $rodada"; cria_namelist
      let i=i+1 
done

echo ""

