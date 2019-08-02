This is the codes I developed for SBR_SFA projects before FY2019. The repo is mainly about setting up PFLOTRAN in different ways, while there are more components related to geostatistics, data assimilation, and quite a lot of postprocessing codes.

Most of these codes were written using R. Since then, I switched more towards Python. The R codes become legacy to me. However, I believe it can still be useful for others. 

Parts of the codes have been duplicated in developing the HFR-flow notebook. "https://github.com/pnnl-sbrsfa/HFR-flow/." This HFR notebook reorganize the R code for PFLOTRAN setup to the form of Jupiter notebook and used to set up a reach scale pflotran model, the Jupiter notebook already includes initial condition/groundwater boundary condition/river boundary/material setup/kriging/mesh development/postprocessing and other parts related to model setup from this legacy codes repository. The HFR notebook use the codes in "setup_1.6km_model_smoothed_boundary","setup_400m_aquifer_tube_model_domain","ert_base_model".

Parts of the codes are also used as a reference to develop "https://github.com/pnnl-sbrsfa/DA-HEF," while Kewei did a great job to rewrite and develop his codes using Python. The initial version is written using R. https://github.com/xuehangsong/legacy_codes_for_pflotran/tree/master/1D_flux_data_assimilation.

This repo is set up as an archive. Over 1800 R/Python/Fortran/Shell/Matlab included in this repo. I wrote most of these scripts except the codes in sensitivity/heng_matlab. There are still many codes that are developed for a specific purpose but not reused. Such as scripts for fft/wavelet/sensor validation/interpolation, etc., which can potentially be used in the future. These codes are free to share within the groups and in the scientific community. 

Xuehang
