#!/bin/bash

# version 1.1 20230517

source ~/.bash_profile
# declare WRF-chem directory
export targetwrfchemdir=$wrfsrun415dir

# met em data
export metdir=/met_embackup/directory/

# declare log directory
export logdir=./logdir
mkdir -p $logdir

# declare namelist
export namelistdir=./namelistlog
export namelistwrf=namelist_WRFchem371.input
mkdir -p $namelistdir

# namelist in:
# this is my laptop
# D:\UEA\research skill\wrf-chem\project_UEA\9_MOZART_mosaic_MEIC_lambert\2_namelist\wrfchem_actualRun\actual_start_run_2022May\MOZART\6_LongTermSim

# chem_opt = 0, namelist
export namelistreal=namelist_WRFchem371_realnoChem.input

# camchem dir
export camchemdir=/camchem/dir/
export camchemfile1=camchem-20170626to20170716_Large.nc
export camchemfile2=camchem-20170714to20170802_Large.nc

#creating namelist (with chem_opt):
export num_metgrid=32

export startyear=2017
export startmonth=06
export startday=28

export endyear=2017
export endmonth=08
export endday=01


cat > ${namelistdir}/${namelistwrf} <<EOF
&time_control
 start_year                          = ${startyear}, 2014, 2014,
 start_month                         = ${startmonth},   06,   06,
 start_day                           = ${startday},   14,   14,
 start_hour                          = 00,   00,   00,
 start_minute                        = 00,   00,   00,
 start_second                        = 00,   00,   00,
 end_year                            = ${endyear}, 2014, 2014,
 end_month                           = ${endmonth},   06,   06,
 end_day                             = ${endday},   17,   17,
 end_hour                            = 06,   00,   00,
 end_minute                          = 00,   00,   00,
 end_second                          = 00,   00,   00,
 interval_seconds                    = 21600
 input_from_file                     = .true.,.true.,.true.,
 history_interval                    = 60,   60,   60,
 frames_per_outfile                  = 24,    9999,    1000,
 restart                             = .false.,
 restart_interval_h                  = 48
 io_form_history                     = 2
 io_form_restart                     = 2
 io_form_input                       = 2
 io_form_boundary                    = 2
 debug_level                         = 0
 auxinput4_interval                  = 360, 360 ,360
 io_form_auxinput4                   = 2
 auxinput4_inname                    = 'wrflowinp_d<domain>',
 write_hist_at_0h_rst                = .false.
 !auxinput8_inname                    = 'wrfchemi_gocart_backg'
 !io_form_auxinput8                   = 0,
 auxinput5_inname                    = 'wrfchemi_<hr>z_d<domain>',
 auxinput5_interval_m                = 60,
 io_form_auxinput5                   = 2,
 frames_per_auxinput5                = 12, 1, 1,
 auxinput6_inname                    = 'wrfbiochemi_d<domain>',
 io_form_auxinput6                   = 2,
 !auxinput7_inname                    = 'wrffirechemi_d<domain>_<date>',
 !io_form_auxinput7                   = 2,
 !frames_per_auxinput7                = 1,
 !auxinput7_interval_m                = 60,
 !force_use_old_data = .true.           !have to use it given version 4.1.5
 history_outname = './wrfout_d<domain>_<date>_202_base371heteor'
 /

 &domains
 time_step                           = 120,!150,!300,
 time_step_fract_num                 = 0,
 time_step_fract_den                 = 1,
 max_dom                             = 1
 e_we                                = 140,  100,   73,                     !large China domain
 e_sn                                = 110,   82,   82,                     !large China domain
 e_vert                              = 29,   30,   30,
 p_top_requested                     = 5000,
 eta_levels                          = 1,0.9979,0.994,0.989,0.984,0.979,0.9711,
                                       0.962,0.95,0.934,0.9135,0.8899,0.86,0.825,
                                       0.783,0.74,0.69,0.638,0.584,0.528,0.47,
                                       0.41,0.348,0.285,0.221,0.153,0.091,0.043,0
 num_metgrid_levels                  = ${num_metgrid},
 num_metgrid_soil_levels             = 4,
 dx                                  = 45000, 10000, 3333.333,
 dy                                  = 45000, 10000, 3333.333,
 !from here below, we use Sliver ACP 2020
 grid_id                             = 1, 2,                                 ! grid ID
 parent_id                           = 0, 1,                                 ! parent ID
 i_parent_start                      = 1, 70,                                ! x coordinate of the lower-left corner
 j_parent_start                      = 1, 60,                                ! y coordinate of the lower-left corner
 parent_grid_ratio                   = 1, 9,                                 ! nesting ratio relative to the domain’s parent
 parent_time_step_ratio              = 1, 9,                                 ! parent-to-nest time step ratio
 feedback                            = 1,                                    ! feedback from nest to its parent domain
 /

 &physics
 mp_physics                          = 10, 10,                               ! microphysics scheme, 10 = Morrison 2-moment
 progn                               = 1, 1,                                 ! prognostic number density, switch to use mix-activate scheme, 0 = off
 ra_lw_physics                       = 4, 4,                                 ! longwave radiation scheme, 4 = RRTMG
 ra_sw_physics                       = 4, 4,                                 ! shortwave radiation scheme, 4 = RRTMG
 radt                                = 30, 30,                               ! minutes between radiation physics calls, recommended 1 minute per km of dx (e.g. 10 for 10 km grid); use the same value for all nests
 sf_sfclay_physics                   = 1, 5,                                 !* surface layer physics option, 1 = YSU
 sf_surface_physics                  = 1, 2,                                 !* land surface physics option, 1 = thermal diffusion scheme
 bl_pbl_physics                      = 1, 5,                                 !* boundary layer physics option, 1 = YSU
 bldt                                = 0, 0,                                 ! minutes between boundary-layer physics calls (0=call every timestep)
 cu_physics                          = 5, 0,                                 ! cumulus parameterization option, 5 = Grell 3D
 cudt                                = 0,                                    ! minutes between cumulus physics calls; should be set to 0 when using all cu_physics except Kain-Fritsch
 cugd_avedx                          = 1,                                    ! number of grid boxes over which subsidence is spread, set to 3 for 4km run, 1 for 36km
 isfflx                              = 1,                                    ! heat and moisture fluxes from the surface for real-data cases and when a PBL is used
 ifsnow                              = 1,                                    ! snow-cover effects
 icloud                              = 1,                                    ! cloud effect to the optical depth in radiation
 surface_input_source                = 1,                                    ! where landuse and soil category data come from, 1 = WPS
 num_soil_layers                     = 4,                                    ! set 4 as our own  !!number of soil levels or layers in WPS output
 sf_urban_physics                    = 0,                                    ! set 0, as our own, !! activate urban canopy model, 1 = single layer, some break the inner domain and no idea why
 mp_zero_out                         = 2,                                    ! this keeps moisture variables above a threshold value ≥0
 mp_zero_out_thresh                  = 1.e-8,                                ! critical value for moisture variable threshold, below which moisture arrays (except for Qv) are set to zero
 cu_rad_feedback                     = .true., .false.,                      ! sub-grid cloud effect to the optical depth in radiation
 cu_diag                             = 1, 0,                                 ! Additional time-averaged diagnostics from cu_physics
 slope_rad                           = 0, 1,                                 ! use slope-dependent radiation
 topo_shading                        = 0, 1,                                 ! applies neighboring-point shadow effects
 num_land_cat                        = 21,                                   ! number of land categories in input data
 /


 &fdda
 grid_fdda                           = 1,    1,     1,
 gfdda_inname                        = "wrffdda_d<domain>",
 gfdda_end_h                         = 10000, 0,                               ! time (hr) to stop nudging after the start of the forecast
 gfdda_interval_m                    = 360, 0,                               ! time interval (in mins) between analysis times
 if_no_pbl_nudging_uv                = 1, 0,                                 ! nudging of u and v in the PBL, 0 = yes, 1 = no
 if_no_pbl_nudging_t                 = 1, 0,                                 ! nudging of t in the PBL, 0 = yes, 1 = no
 if_no_pbl_nudging_q                 = 1, 0,                                 ! nudging of q in the PBL, 0 = yes, 1 = no
 if_zfac_uv                          = 0, 0,                                 ! nudge u and v in all layers, 0 = yes, 1 = limit to k_zfac_uv layers
 k_zfac_uv                           = 2,                                    ! model level below which nudging is switched off for u and v
 if_zfac_t                           = 0, 0,                                 ! nudge t in all layers, 0 = yes, 1 = limit to k_zfac_t layers
 k_zfac_t                            = 2,                                    ! model level below which nudging is switched off for t
 if_zfac_q                           = 0, 0,                                 ! nudge q in all layers, 0 = yes, 1 = limit to k_zfac_q layers
 k_zfac_q                            = 2,                                    ! model level below which nudging is switched off for q
 guv                                 = 0.0006, 0.0006,                       ! nudging coefficient for u and v (s-1)
 gt                                  = 0.0006, 0.0006,                       ! nudging coefficient for t (s-1)
 gq                                  = 0.0006, 0.0006,                       ! nudging coefficient for q (s-1)
 if_ramping                          = 0,                                    ! 0 = nudging ends as a step function, 1 = ramping nudging down at the end of the period
 dtramp_min                          = 360,                                  ! time (min) for ramping function
 io_form_gfdda                       = 2,                                    ! 2 = NetCDF
 /

 &dynamics                                                                 ! dynamics - diffusion, damping options, advection options
 rk_ord                              = 3,                                    ! time-integration scheme option, 3 = Runge-Kutta 3rd order
 w_damping                           = 1,                                    ! vertical velocity damping flag, 1 = with damping
 diff_opt                            = 1, 1,                                 ! turbulence and mixing option, 1 = evaluates 2nd order diffusion term on coordinate surfaces
 km_opt                              = 4, 4,                                 ! eddy coefficient option, 4 = horizontal Smagorinsky first order closure
 diff_6th_opt                        = 0, 0,                                 ! 6th-order numerical diffusion, 0 = none
 diff_6th_factor                     = 0.12,                                 ! 6th-order numerical diffusion nondimensional rate
 base_temp                           = 290.                                  ! base state temperature (K)
 damp_opt                            = 3,                                    ! upper-level damping flag, 3 = Rayleigh damping
 zdamp                               = 5000., 5000.,                         ! damping depth (m) from model top
 dampcoef                            = 0.2, 0.2,                             ! damping coefficient
 khdif                               = 0, 0,                                 ! horizontal diffusion constant (m2/s)
 kvdif                               = 0, 0,                                 ! vertical diffusion constant (m2/s)
 non_hydrostatic                     = .true.,                               ! running the model in nonhydrostatic mode
 moist_adv_opt                       = 2, 2,                                 ! advection options for moisture, 2 = monotonic
 chem_adv_opt                        = 2, 2,                                 ! advection options for chemistry, 2 = monotonic
 scalar_adv_opt                      = 2, 2,                                 ! advection options for scalars, 2 = monotonic
 tke_adv_opt                         = 2, 2,                                 ! advection options for TKE, 2 = monotonic
 do_avgflx_em                        = 1, 1,                                 ! outputs time-averaged masscoupled advective velocities, 1 = on
 /

 &bdy_control
 spec_bdy_width                      = 5,
 spec_zone                           = 1,
 relax_zone                          = 4,
 spec_exp                            = 0.33,
 specified                           = .true., .false.,.false.,
 nested                              = .false., .true., .true.,
 /


 &grib2
 /

 &chem
 kemit                               = 8,         ! number of vertical levels in the emissions input data file
 chem_opt                            = 202, 202, 202,             ! chemistry option, 201 = MOZART-MOSAIC (4 bins + simplified SOA + no aqeuous chemistry), 202 = MOZART-MOSAIC (4 bins + VBS SOA + aqeuous chemistry).
 bioemdt                             = 30, 3.0, 3.0,              !* set as previous self-test run, timestep, biogenic, minutes
 photdt                              = 30., 10., 10.,             ! timestep, photolysis, minutes
 chemdt                              = 6, 3.0, 3.0,               !* set as previous self-test run, timestep, chemistry, minutes
 io_style_emissions                  = 1,                         ! anthropogenic emissions, files, two 12-h emissions data files used
 emiss_inpt_opt                      = 102, 102, 102,             ! RADM2 emission speciation adapted after reading data file to follow the RADM2/SORGAM framework (including isoprene)
 emiss_opt                           = 10, 10, 10,                ! anthropogenic emissions, setting, 10 = MOZART (MOZART + aerosols) emissions
 chem_in_opt                         = 0, 1, 1,                   ! use our own !!!initialize chemistry, 1 = uses previous simulation data
 phot_opt                            = 2, 4, 4,                   !* using Fast-J photolysis photolysis option, 1 = Full TUV, 3 = Madronich F-TUV, 4 = New full TUV scheme
 gas_drydep_opt                      = 1, 1, 1,                   ! dry deposition of gas species, 1 = on
 aer_drydep_opt                      = 1, 1, 1,                   ! dry deposition of aerosols, 1 = on
 bio_emiss_opt                       = 3, 3, 3,                   ! includes MEGAN biogenic emissions online based upon the weather, land use data
 gas_bc_opt                          = 1, 1, 1,                   ! gas boundary conditions, 1 = default
 gas_ic_opt                          = 1, 1, 1,                   ! gas initial conditions, 1 = default
 aer_bc_opt                          = 1, 1, 1,                   ! aerosol boundary conditions, 1 = default
 aer_ic_opt                          = 1, 1, 1,                   ! aerosol initial conditions, 1 = default
 gaschem_onoff                       = 1, 1, 1,                   ! gas phase chemistry, 1 = on
 aerchem_onoff                       = 1, 1, 1,                   ! aerosol chemistry, 1 = on
 wetscav_onoff                       = 1, 1, 1,                   ! wet scavenging in stratocumulus clouds, 1 = on
 cldchem_onoff                       = 0, 1, 1,                   ! aqueous chemistry in stratocumulus clouds, 1 = on
 vertmix_onoff                       = 1, 1, 1,                   ! vertical turbulent mixing, 1 = on
 chem_conv_tr                        = 1, 0, 0,                   ! subgrid convective transport, 1 = on
 conv_tr_wetscav                     = 1, 0, 0,                   ! wet scavenging in cumulus clouds, subgrid, 1 = on
 conv_tr_aqchem                      = 1, 0, 0,                   ! aqueous chemistry in cumulus clouds, subgrid, 1 = on
 seas_opt                            = 2,                         ! sea salt emissions, 2 = MOSAIC or MADE/SORGAM sea salt emissions
 dust_opt                            = 13,                        ! dust emissions, 13 = GOCART for MOSAIC - Zeng et al., (2020) GMD, Zhao et al., (2013) ACP, Zhao et al., (2010) ACP
 dmsemis_opt                         = 0,                         ! include GOCART dms emissions from sea surface
 biomass_burn_opt                    = 0, 2, 2,                   ! biomass burning emissions, 2 = MOCART
 plumerisefire_frq                   = 0, 30, 30,                ! time interval for calling the biomass burning plume rise subroutine
 scale_fire_emiss                    = .false., .true., .true.,    ! must be equal to .true. when running with FINN emissions
 aer_ra_feedback                     = 1, 1, 1,                   ! feedback from the aerosols to the radiation schemes, 1 = on
 ne_area                             = 500,                       ! total number of chemical species, in the chemical name list, best to set to a value larger than all chemical species
 !opt_pars_out                        = 1,                        ! no For our simulation ! include optical properties in output
 have_bcs_chem                       = .true., .false., .false.,  ! gets lateral boundary data from wrfbdy (.true.) or idealized profile (.false.)
 have_bcs_upper                      = .false., .false., .false., ! upper boundary bounary condition for chemical species
 !aer_op_opt                          = 2, 2, 2,                  !shut off, doesn't work in real.exe ! aerosol optical properties, 1 = volume, 2 = approximate Maxwell-Garnet, 3 = complex volume-mixing, 4 = complex Maxwell-Garnet, 5 = complex core-shell
 !bbinjectscheme                      = 2, 2, 2,                  !shut off, doesn't work in real.exe ! 0 = plumerise (biomass_burn_opt), 1 = all ground level, 2 = flaming evenly in BL (recommended), 3 = flaming top BL, 4 = flaming injected at specific height
 n2o5_hetchem                        = 0,                         ! N2O5 heterogeneous chemistry, 0 = off, 1 = without Cl- pathway, 2 = full inorganic
 /

 &namelist_quilt                                                           ! options for asynchronized I/O for MPI applications
 nio_tasks_per_group                 = 0,                                    ! # of processors used for IO quilting per IO group
 nio_groups                          = 0                                     ! number of quilting groups
 /
EOF



cat > ${namelistdir}/${namelistreal} <<EOF
&time_control
 start_year                          = ${startyear}, 2014, 2014,
 start_month                         = ${startmonth},   06,   06,
 start_day                           = ${startday},   14,   14,
 start_hour                          = 00,   00,   00,
 start_minute                        = 00,   00,   00,
 start_second                        = 00,   00,   00,
 end_year                            = ${endyear}, 2014, 2014,
 end_month                           = ${endmonth},   06,   06,
 end_day                             = ${endday},   17,   17,
 end_hour                            = 06,   00,   00,
 end_minute                          = 00,   00,   00,
 end_second                          = 00,   00,   00,
 interval_seconds                    = 21600
 input_from_file                     = .true.,.true.,.true.,
 history_interval                    = 60,   60,   60,
 frames_per_outfile                  = 24,    9999,    1000,
 restart                             = .false.,
 restart_interval_h                  = 48
 io_form_history                     = 2
 io_form_restart                     = 2
 io_form_input                       = 2
 io_form_boundary                    = 2
 debug_level                         = 0
 auxinput4_interval                  = 360, 360 ,360
 io_form_auxinput4                   = 2
 auxinput4_inname                    = 'wrflowinp_d<domain>',
 write_hist_at_0h_rst                = .false.
 !auxinput8_inname                    = 'wrfchemi_gocart_backg'
 !io_form_auxinput8                   = 0,
 auxinput5_inname                    = 'wrfchemi_<hr>z_d<domain>',
 auxinput5_interval_m                = 60,
 io_form_auxinput5                   = 2,
 frames_per_auxinput5                = 12, 1, 1,
 auxinput6_inname                    = 'wrfbiochemi_d<domain>',
 io_form_auxinput6                   = 2,
 !auxinput7_inname                    = 'wrffirechemi_d<domain>_<date>',
 !io_form_auxinput7                   = 2,
 !frames_per_auxinput7                = 1,
 !auxinput7_interval_m                = 60,
 !force_use_old_data = .true.           !have to use it given version 4.1.5
 history_outname = './wrfout_d<domain>_<date>_202_base371heteor'
 /

 &domains
 time_step                           = 120,!150,!300,
 time_step_fract_num                 = 0,
 time_step_fract_den                 = 1,
 max_dom                             = 1
 e_we                                = 140,  100,   73,                     !large China domain
 e_sn                                = 110,   82,   82,                     !large China domain
 e_vert                              = 29,   30,   30,
 p_top_requested                     = 5000,
 eta_levels                          = 1,0.9979,0.994,0.989,0.984,0.979,0.9711,
                                       0.962,0.95,0.934,0.9135,0.8899,0.86,0.825,
                                       0.783,0.74,0.69,0.638,0.584,0.528,0.47,
                                       0.41,0.348,0.285,0.221,0.153,0.091,0.043,0
 num_metgrid_levels                  = ${num_metgrid},
 num_metgrid_soil_levels             = 4,
 dx                                  = 45000, 10000, 3333.333,
 dy                                  = 45000, 10000, 3333.333,
 !from here below, we use Sliver ACP 2020
 grid_id                             = 1, 2,                                 ! grid ID
 parent_id                           = 0, 1,                                 ! parent ID
 i_parent_start                      = 1, 70,                                ! x coordinate of the lower-left corner
 j_parent_start                      = 1, 60,                                ! y coordinate of the lower-left corner
 parent_grid_ratio                   = 1, 9,                                 ! nesting ratio relative to the domain’s parent
 parent_time_step_ratio              = 1, 9,                                 ! parent-to-nest time step ratio
 feedback                            = 1,                                    ! feedback from nest to its parent domain
 /

 &physics
 mp_physics                          = 10, 10,                               ! microphysics scheme, 10 = Morrison 2-moment
 progn                               = 1, 1,                                 ! prognostic number density, switch to use mix-activate scheme, 0 = off
 ra_lw_physics                       = 4, 4,                                 ! longwave radiation scheme, 4 = RRTMG
 ra_sw_physics                       = 4, 4,                                 ! shortwave radiation scheme, 4 = RRTMG
 radt                                = 30, 30,                               ! minutes between radiation physics calls, recommended 1 minute per km of dx (e.g. 10 for 10 km grid); use the same value for all nests
 sf_sfclay_physics                   = 1, 5,                                 !* surface layer physics option, 1 = YSU
 sf_surface_physics                  = 1, 2,                                 !* land surface physics option, 1 = thermal diffusion scheme
 bl_pbl_physics                      = 1, 5,                                 !* boundary layer physics option, 1 = YSU
 bldt                                = 0, 0,                                 ! minutes between boundary-layer physics calls (0=call every timestep)
 cu_physics                          = 5, 0,                                 ! cumulus parameterization option, 5 = Grell 3D
 cudt                                = 0,                                    ! minutes between cumulus physics calls; should be set to 0 when using all cu_physics except Kain-Fritsch
 cugd_avedx                          = 1,                                    ! number of grid boxes over which subsidence is spread, set to 3 for 4km run, 1 for 36km
 isfflx                              = 1,                                    ! heat and moisture fluxes from the surface for real-data cases and when a PBL is used
 ifsnow                              = 1,                                    ! snow-cover effects
 icloud                              = 1,                                    ! cloud effect to the optical depth in radiation
 surface_input_source                = 1,                                    ! where landuse and soil category data come from, 1 = WPS
 num_soil_layers                     = 4,                                    ! set 4 as our own  !!number of soil levels or layers in WPS output
 sf_urban_physics                    = 0,                                    ! set 0, as our own, !! activate urban canopy model, 1 = single layer, some break the inner domain and no idea why
 mp_zero_out                         = 2,                                    ! this keeps moisture variables above a threshold value ≥0
 mp_zero_out_thresh                  = 1.e-8,                                ! critical value for moisture variable threshold, below which moisture arrays (except for Qv) are set to zero
 cu_rad_feedback                     = .true., .false.,                      ! sub-grid cloud effect to the optical depth in radiation
 cu_diag                             = 1, 0,                                 ! Additional time-averaged diagnostics from cu_physics
 slope_rad                           = 0, 1,                                 ! use slope-dependent radiation
 topo_shading                        = 0, 1,                                 ! applies neighboring-point shadow effects
 num_land_cat                        = 21,                                   ! number of land categories in input data
 /


 &fdda
 grid_fdda                           = 1,    1,     1,
 gfdda_inname                        = "wrffdda_d<domain>",
 gfdda_end_h                         = 10000, 0,                               ! time (hr) to stop nudging after the start of the forecast
 gfdda_interval_m                    = 360, 0,                               ! time interval (in mins) between analysis times
 if_no_pbl_nudging_uv                = 1, 0,                                 ! nudging of u and v in the PBL, 0 = yes, 1 = no
 if_no_pbl_nudging_t                 = 1, 0,                                 ! nudging of t in the PBL, 0 = yes, 1 = no
 if_no_pbl_nudging_q                 = 1, 0,                                 ! nudging of q in the PBL, 0 = yes, 1 = no
 if_zfac_uv                          = 0, 0,                                 ! nudge u and v in all layers, 0 = yes, 1 = limit to k_zfac_uv layers
 k_zfac_uv                           = 2,                                    ! model level below which nudging is switched off for u and v
 if_zfac_t                           = 0, 0,                                 ! nudge t in all layers, 0 = yes, 1 = limit to k_zfac_t layers
 k_zfac_t                            = 2,                                    ! model level below which nudging is switched off for t
 if_zfac_q                           = 0, 0,                                 ! nudge q in all layers, 0 = yes, 1 = limit to k_zfac_q layers
 k_zfac_q                            = 2,                                    ! model level below which nudging is switched off for q
 guv                                 = 0.0006, 0.0006,                       ! nudging coefficient for u and v (s-1)
 gt                                  = 0.0006, 0.0006,                       ! nudging coefficient for t (s-1)
 gq                                  = 0.0006, 0.0006,                       ! nudging coefficient for q (s-1)
 if_ramping                          = 0,                                    ! 0 = nudging ends as a step function, 1 = ramping nudging down at the end of the period
 dtramp_min                          = 360,                                  ! time (min) for ramping function
 io_form_gfdda                       = 2,                                    ! 2 = NetCDF
 /

 &dynamics                                                                 ! dynamics - diffusion, damping options, advection options
 rk_ord                              = 3,                                    ! time-integration scheme option, 3 = Runge-Kutta 3rd order
 w_damping                           = 1,                                    ! vertical velocity damping flag, 1 = with damping
 diff_opt                            = 1, 1,                                 ! turbulence and mixing option, 1 = evaluates 2nd order diffusion term on coordinate surfaces
 km_opt                              = 4, 4,                                 ! eddy coefficient option, 4 = horizontal Smagorinsky first order closure
 diff_6th_opt                        = 0, 0,                                 ! 6th-order numerical diffusion, 0 = none
 diff_6th_factor                     = 0.12,                                 ! 6th-order numerical diffusion nondimensional rate
 base_temp                           = 290.                                  ! base state temperature (K)
 damp_opt                            = 3,                                    ! upper-level damping flag, 3 = Rayleigh damping
 zdamp                               = 5000., 5000.,                         ! damping depth (m) from model top
 dampcoef                            = 0.2, 0.2,                             ! damping coefficient
 khdif                               = 0, 0,                                 ! horizontal diffusion constant (m2/s)
 kvdif                               = 0, 0,                                 ! vertical diffusion constant (m2/s)
 non_hydrostatic                     = .true.,                               ! running the model in nonhydrostatic mode
 moist_adv_opt                       = 2, 2,                                 ! advection options for moisture, 2 = monotonic
 chem_adv_opt                        = 2, 2,                                 ! advection options for chemistry, 2 = monotonic
 scalar_adv_opt                      = 2, 2,                                 ! advection options for scalars, 2 = monotonic
 tke_adv_opt                         = 2, 2,                                 ! advection options for TKE, 2 = monotonic
 do_avgflx_em                        = 1, 1,                                 ! outputs time-averaged masscoupled advective velocities, 1 = on
 /

 &bdy_control
 spec_bdy_width                      = 5,
 spec_zone                           = 1,
 relax_zone                          = 4,
 spec_exp                            = 0.33,
 specified                           = .true., .false.,.false.,
 nested                              = .false., .true., .true.,
 /


 &grib2
 /

 &chem
 kemit                               = 8,         ! number of vertical levels in the emissions input data file
 chem_opt                            = 0!202, 202, 202,             ! chemistry option, 201 = MOZART-MOSAIC (4 bins + simplified SOA + no aqeuous chemistry), 202 = MOZART-MOSAIC (4 bins + VBS SOA + aqeuous chemistry).
 bioemdt                             = 30, 3.0, 3.0,              !* set as previous self-test run, timestep, biogenic, minutes
 photdt                              = 30., 10., 10.,             ! timestep, photolysis, minutes
 chemdt                              = 6, 3.0, 3.0,               !* set as previous self-test run, timestep, chemistry, minutes
 io_style_emissions                  = 1,                         ! anthropogenic emissions, files, two 12-h emissions data files used
 emiss_inpt_opt                      = 102, 102, 102,             ! RADM2 emission speciation adapted after reading data file to follow the RADM2/SORGAM framework (including isoprene)
 emiss_opt                           = 10, 10, 10,                ! anthropogenic emissions, setting, 10 = MOZART (MOZART + aerosols) emissions
 chem_in_opt                         = 0, 1, 1,                   ! use our own !!!initialize chemistry, 1 = uses previous simulation data
 phot_opt                            = 2, 4, 4,                   !* using Fast-J photolysis photolysis option, 1 = Full TUV, 3 = Madronich F-TUV, 4 = New full TUV scheme
 gas_drydep_opt                      = 1, 1, 1,                   ! dry deposition of gas species, 1 = on
 aer_drydep_opt                      = 1, 1, 1,                   ! dry deposition of aerosols, 1 = on
 bio_emiss_opt                       = 3, 3, 3,                   ! includes MEGAN biogenic emissions online based upon the weather, land use data
 gas_bc_opt                          = 1, 1, 1,                   ! gas boundary conditions, 1 = default
 gas_ic_opt                          = 1, 1, 1,                   ! gas initial conditions, 1 = default
 aer_bc_opt                          = 1, 1, 1,                   ! aerosol boundary conditions, 1 = default
 aer_ic_opt                          = 1, 1, 1,                   ! aerosol initial conditions, 1 = default
 gaschem_onoff                       = 1, 1, 1,                   ! gas phase chemistry, 1 = on
 aerchem_onoff                       = 1, 1, 1,                   ! aerosol chemistry, 1 = on
 wetscav_onoff                       = 1, 1, 1,                   ! wet scavenging in stratocumulus clouds, 1 = on
 cldchem_onoff                       = 0, 1, 1,                   ! aqueous chemistry in stratocumulus clouds, 1 = on
 vertmix_onoff                       = 1, 1, 1,                   ! vertical turbulent mixing, 1 = on
 chem_conv_tr                        = 1, 0, 0,                   ! subgrid convective transport, 1 = on
 conv_tr_wetscav                     = 1, 0, 0,                   ! wet scavenging in cumulus clouds, subgrid, 1 = on
 conv_tr_aqchem                      = 1, 0, 0,                   ! aqueous chemistry in cumulus clouds, subgrid, 1 = on
 seas_opt                            = 2,                         ! sea salt emissions, 2 = MOSAIC or MADE/SORGAM sea salt emissions
 dust_opt                            = 13,                        ! dust emissions, 13 = GOCART for MOSAIC - Zeng et al., (2020) GMD, Zhao et al., (2013) ACP, Zhao et al., (2010) ACP
 dmsemis_opt                         = 0,                         ! include GOCART dms emissions from sea surface
 biomass_burn_opt                    = 0, 2, 2,                   ! biomass burning emissions, 2 = MOCART
 plumerisefire_frq                   = 0, 30, 30,                ! time interval for calling the biomass burning plume rise subroutine
 scale_fire_emiss                    = .false., .true., .true.,    ! must be equal to .true. when running with FINN emissions
 aer_ra_feedback                     = 1, 1, 1,                   ! feedback from the aerosols to the radiation schemes, 1 = on
 ne_area                             = 500,                       ! total number of chemical species, in the chemical name list, best to set to a value larger than all chemical species
 !opt_pars_out                        = 1,                        ! no For our simulation ! include optical properties in output
 have_bcs_chem                       = .true., .false., .false.,  ! gets lateral boundary data from wrfbdy (.true.) or idealized profile (.false.)
 have_bcs_upper                      = .false., .false., .false., ! upper boundary bounary condition for chemical species
 !aer_op_opt                          = 2, 2, 2,                  !shut off, doesn't work in real.exe ! aerosol optical properties, 1 = volume, 2 = approximate Maxwell-Garnet, 3 = complex volume-mixing, 4 = complex Maxwell-Garnet, 5 = complex core-shell
 !bbinjectscheme                      = 2, 2, 2,                  !shut off, doesn't work in real.exe ! 0 = plumerise (biomass_burn_opt), 1 = all ground level, 2 = flaming evenly in BL (recommended), 3 = flaming top BL, 4 = flaming injected at specific height
 n2o5_hetchem                        = 0,                         ! N2O5 heterogeneous chemistry, 0 = off, 1 = without Cl- pathway, 2 = full inorganic
 /

 &namelist_quilt                                                           ! options for asynchronized I/O for MPI applications
 nio_tasks_per_group                 = 0,                                    ! # of processors used for IO quilting per IO group
 nio_groups                          = 0                                     ! number of quilting groups
 /
EOF

 
