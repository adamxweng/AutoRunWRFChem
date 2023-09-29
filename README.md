# AutoRunWRFChem 3.7.1 with Nudging below PBL

scripts for running WRF-Chem 3.7.1
In this branch, nuding below PBL is switched on.
if_no_pbl_nudging_uv                = 0,
if_no_pbl_nudging_t                 = 0,
if_no_pbl_nudging_q                 = 0, 

auto create namelist for real.exe and wrf.exe

# to run:
source 01_envVar_set.sh
source ~/.bash_profile

bash 02_realnoChem.sh && bash 03_wesely.sh && bash 04_megan.sh && bash 05_realChem.sh && bash 06_mozbc.sh
