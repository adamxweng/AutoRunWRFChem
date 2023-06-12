#!/bin/bash
#----- creatin trash can, not using rm, 20211027 ------------------

mkdir -p /gpfs/home/hpc15zha/trashcan
alias rl='ls /gpfs/home/hpc15zha/trashcan'


trash()
    {
    mv $@ /gpfs/home/hpc15zha/trashcan
    }

cleartrash()
    {
    read -p "clear sure?[n]" confirm
    [ $confirm == 'y' ] || [ $confirm == 'Y' ]  && /bin/rm -rf /gpfs/home/hpc15zha/trashcan/*
    }

#================== run ============================
#============= still no running FINN =============
#---------------- real run again----------------------
cd $targetwrfchemdir 
mv $megandir415/wrfbiochemi_d01 $targetwrfchemdir/
mv $wesdir415/exo_coldens_d01 $targetwrfchemdir/
mv $wesdir415/wrf_season_wes_usgs_d01.nc $targetwrfchemdir/

trash $targetwrfchemdir/namelist.input
cp $namelistdir/${namelistwrf} ./namelist.input &&\
mpirun ./real.exe && echo finish_real_withChem
