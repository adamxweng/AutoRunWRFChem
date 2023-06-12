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
cd $wesdir415 &&\
cd $wesdir415/wrf_sfLink &&\
bash $removeRun
ln -sf $targetwrfchemdir/wrfbdy_d01 . &&\
ln -sf $targetwrfchemdir/wrffdda_d01 . &&\
ln -sf $targetwrfchemdir/wrfinput_d01 . &&\

cd $wesdir415 &&\
# putting content in 
cat > wes_coldnes_wrflink.inp <<EOF
&control
wrf_dir = '/gpfs/home/hpc15zha/project/11_wrfchem_20211129/tools/wes-coldens/wrf_sfLink'
domains = 1,
/
EOF
./exo_coldens < wes_coldnes_wrflink.inp &&\
./wesely < wes_coldnes_wrflink.inp &&\
cd wrf_sfLink &&\
bash $removeRun