These are the codes I developed for SBR_SFA projects before FY2019. The repo is not only about setting up PFLOTRAN in different ways, there are more components related to geostatistics, data assimilation, and quite a lot of postprocessing codes. I learned recently from the EM related projects that "You did nothing unless you documented what you did". That's true. lol.

These codes were used to support the modeling parts in at least five WRR papers, including 
Shuai et al., 2019 doi:10.1029/2018WR024193. 70% of model setup, 40% of postprocessing
Song et al., 2019 doi:10.1029/2018WR023262. 100% of model setup and postprocessing
Dai et al., 2019 doi:10.1029/2018WR023589. 100% of model setup
Song et al., 2018 doi:10.1029/2018WR022586. 100% of model setup and postprocessing
Dai et al., 2019 doi:10.1002/2016WR019756. 80% of model setup
Parts of the codes were also used for supporing data analysis in other papers, such as the wavelet analysis in Zhou et al., 2018 doi:10.1002/2017WR020508. 

These codes  support enormous presentations related to the groundwater modeling studies in the SFA project in the past 3~4 years.

There codes were used for decision making for designing experiment plan in Hanford 300 Area, including ERT and aquifer tube arrays. 

I tried to write the codes in general ways, so we can copy pieces of these codes and reuse it in developing similar models by altering serveral parameters. It works well in some ways.

Most of these codes were written using R. Since then, I switched more towards Python. The R codes become legacy to me. However, I believe it can still be useful for others. 

Parts of the codes have been duplicated in developing the HFR-flow notebook. "https://github.com/pnnl-sbrsfa/HFR-flow/." This HFR notebook reorganize the R code for PFLOTRAN setup to the form of Jupiter notebook and used to set up a reach scale pflotran model, the Jupiter notebook already includes initial condition/groundwater boundary condition/river boundary/material setup/kriging/mesh development/postprocessing and other parts related to model setup from this legacy codes repository. The HFR notebook uses the codes in "setup_1.6km_model_smoothed_boundary","setup_400m_aquifer_tube_model_domain","ert_base_model".

Parts of the codes are also used as a reference to develop "https://github.com/pnnl-sbrsfa/DA-HEF," while Kewei did a great job to rewrite and develop his codes using Python. The initial version is written using R."1D_flux_data_assimilation".

This repo is set up as an archive. Nearly 2000 R/Python/Fortran/Shell/Matlab included in this repo. I wrote most of these scripts except the codes in sensitivity/heng_matlab. There are still many codes that are developed for a specific purpose but not reused. Such as scripts for fft/wavelet/sensor validation/interpolation, etc., which can potentially be used in the future. These codes are free to share within the project and in the scientific community. 

Xuehang
