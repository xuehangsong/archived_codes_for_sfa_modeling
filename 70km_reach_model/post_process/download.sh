## download multiple files from NERSC
scp -r pshuai@cori.nersc.gov:/global/cscratch1/sd/pshuai/John_case_optim_5/\{*.tec,*.dat\} ~/Dropbox/PNNL/Projects/300A/John_case_optim_5/Outputs/.

scp -r pshuai@cori.nersc.gov:/global/cscratch1/sd/pshuai/John_case_optim_5/\{README.txt,pflotran_bigplume.in\} ~/Dropbox/PNNL/Projects/300A/John_case_optim_5/Inputs/.


## download single file
##scp -r pshuai@cori.nersc.gov:/global/cscratch1/sd/pshuai/John_case_optim_3/*.dat ~/Dropbox/PNNL/Projects/300A/John_case_optim_3/Outputs/.

##scp -r pshuai@cori.nersc.gov:/global/cscratch1/sd/pshuai/John_case_optim_5/pflotran_bigplume-004.h5 ~/Paraview/John_case_optim_5/.

scp -r pshuai@cori.nersc.gov:/global/cscratch1/sd/pshuai/HFR_model_test_2007/pflotran*.h5 ~/Dropbox/PNNL/Projects/HFR_outputs/.

scp -r pshuai@cori.nersc.gov:/global/cscratch1/sd/pshuai/HFR_model_test_2007_new_material/pflotran*.h5 ~/Dropbox/PNNL/Projects/Reach_scale_model/Outputs/.

scp -r pshuai@cori.nersc.gov:/global/cscratch1/sd/pshuai/HFR_model_test_2007_new_material/pflotran_2007_new_material.in ~/Dropbox/PNNL/Projects/Reach_scale_model/Inputs/test_2007_solute/.

scp -r pshuai@cori.nersc.gov:/global/cscratch1/sd/pshuai/HFR_model_test_age/\{pflotran*.h5,pflotran_2007_age_flux-mas.dat\} ~/Paraview/HFR/test_2007_age/.

scp -r pshuai@cori.nersc.gov:/global/cscratch1/sd/pshuai/HFR_model_100x100x5/pflotran_100x100x5_6h_bc.h5 ~/Paraview/HFR/HFR_100x100x5m/.

scp -r pshuai@cori.nersc.gov:/global/cscratch1/sd/pshuai/HFR_model_100x100x2/{pflotran_100x100x2.in,slurm-8948783.out} ~/Dropbox/PNNL/Projects/Reach_scale_model/Outputs/HFR_model_100x100x2/.

scp -r pshuai@cori.nersc.gov:/global/cscratch1/sd/pshuai/HFR_model_riverID_200x200x2/pflotran_riverID_200x200x2*.h5 ~/Paraview/HFR/HFR_200x200x2/.

scp -r pshuai@cori.nersc.gov:/global/cscratch1/sd/pshuai/HFR_test_0501/pflotran.h5 ~/Paraview/HFR/HFR_200x200x2_head_bc/.

## download from dtn.pnl.gov
scp -r shua784@dtn2.pnl.gov:/pic/dtn2/shua784/HFR_model_100x100x5/pflotran_100x100x5.h5 ~/Paraview/HFR/HFR_100x100x5m/.

scp -r shua784@dtn2.pnl.gov:/pic/dtn2/shua784/HFR_model_200x200x2/pflotran*.h5 ~/Paraview/HFR/HFR_200x200x2/.

