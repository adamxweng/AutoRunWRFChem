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
#--------- running MEGAN -----------------
# megan downolad:
#https://www.acom.ucar.edu/wrf-chem/download.shtml
# download data setting:
#lat2: 65
#lon1: 65
#lon2: 150
#lat1: 5
cd $megandir415 &&\
cd $megandir415/wrf_sfLink &&\
bash $removeRun
ln -sf $targetwrfchemdir/wrfbdy_d01 . &&\
ln -sf $targetwrfchemdir/wrffdda_d01 . &&\
ln -sf $targetwrfchemdir/wrfinput_d01 . &&\
cd $megandir415 &&\
cat > ./megan_inp/megan_run_wrflink.inp << EOF
&control
domains = 1,
start_lai_mnth = 1,
end_lai_mnth = 12,
wrf_dir = '/gpfs/home/hpc15zha/project/11_wrfchem_20211129/tools/megan_bio_emiss/wrf_sfLink',
megan_dir = '/gpfs/home/hpc15zha/scratch/wrfchem/meganData/data'
/
EOF
./megan_bio_emiss < ./megan_inp/megan_run_wrflink.inp >& ${logdir}/meganrun.log
#============= still no running FINN =============
