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

#=============== running real.exe without chem =====================
cd $targetwrfchemdir
bash $removeRun
trash namelist.input
trash met_em.*

ln -sf $metdir/met_em.* .

diff -b $namelistdir/${namelistreal} $namelistdir/${namelistwrf} >> ${logdir}/01_differenceNameList_real_wrf.log

cp $namelistdir/${namelistreal} ./namelist.input
mpirun ./real.exe && echo finish_real_noChem
