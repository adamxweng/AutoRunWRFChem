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
#---------------- run mozbc ----------------------
cd $mozbcdir415 &&\
ls -la h00* >> ${logdir}/previous_mozbcData.txt &&\
trash h0001.nc
trash h0002.nc
ln -sf $camchemdir/${camchemfile1} ./h0001.nc &&\
ln -sf $camchemdir/${camchemfile2} ./h0002.nc &&\
mv $targetwrfchemdir/wrfinput_d01 . &&\
mv $targetwrfchemdir/wrfbdy_d01 . &&\
cp $targetwrfchemdir/met_em* . &&\
./mozbc < MOZART_INP/20220421_Li_tryimproving_PMSO4_mozbc_chem202.inp  >& ${logdir}/mozbcrun.log && \
trash met_em*
cd $targetwrfchemdir
mv $mozbcdir415/wrfbdy_d01 .
mv $mozbcdir415/wrfinput_d01 .
