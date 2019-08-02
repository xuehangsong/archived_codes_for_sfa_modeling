These are the codes I developed for SBR_SFA projects before FY2019. The repo is not only about setting up PFLOTRAN in different ways, there are more components related to geostatistics, data assimilation, and quite a lot of postprocessing codes. I learned recently from the EM related projects that "**You did nothing unless you documented what you did**". That's true. lol.  
Most of the early codes were written using R. I switched more toward Python in the middle. The R codes gradully become legacy to me. However, I believe it can still be useful for others. There're also a lot of Fortran, Matlab, Shell scipts. 


## What were these codes used for? 
These codes were used to support the modeling parts in at least five WRR papers, including    
**Shuai et al., 2019 doi:10.1029/2018WR024193.** 70% of model setup, 40% of postprocessing  
**Song et al., 2019 doi:10.1029/2018WR023262.** 100% of model setup and postprocessing  
**Dai et al., 2019 doi:10.1029/2018WR023589.** 100% of model setup  
**Song et al., 2018 doi:10.1029/2018WR022586.** 100% of model setup and postprocessing  
**Dai et al., 2019 doi:10.1002/2016WR019756.** 80% of model setup  
Parts of the codes were also used for supporing data analysis in other papers, such as the wavelet analysis in **Zhou et al., 2018 doi:10.1002/2017WR020508.**   

These codes  support **enormous** presentations related to the groundwater modeling studies in the SFA project in the past 3~4 years. **The list is too long...**

There codes were used for decision making in designing experiment plan in Hanford 300 Area, such as **ERT and aquifer tube arrays**. 

## Who used these code?
I tried to write the codes in general ways, so we can copy pieces of these codes and reuse it in developing similar models by altering serveral parameters. It works well in some ways.

**Parts of the codes have been duplicated in developing the HFR-flow notebook. "https://github.com/pnnl-sbrsfa/HFR-flow/."** This HFR notebook reorganize the R/Python codes for PFLOTRAN setup, postprocessing and plotting to the form of Jupiter notebook and use it to set up a reach scale pflotran model. Most portion of the Jupiter notebook was taken from this repo, including initial condition/groundwater boundary condition/river boundary/material setup/kriging/mesh development/postprocessing. The HFR notebook uses the codes in "70km_reach_model" also with "setup_1.6km_model_smoothed_boundary","setup_400m_aquifer_tube_model_domain","ert_base_model" as reference.

**Parts of the codes are also used as a reference to develop "https://github.com/pnnl-sbrsfa/DA-HEF,"** while Kewei did a great job to rewrite and develop his own codes using Python. The initial version is written using R. "1D_flux_data_assimilation".

## Future of these codes
**This repo is set up as an archive**. Nearly **1500 R/Python/Fortran/Shell/Matlab** scripts are included in this repo.There are some repeated parts among different codes, although I have tried hard to reduced the number of archived codes. I wrote most of these scripts except all the codes in **sensitivity/heng_matlab** and some codes in **70km_reach_model**. There are still many codes that are developed for a specific purpose but not reused. Such as scripts for fft/wavelet/sensor validation/interpolation, etc., which can potentially be used in the future. These codes are free to share within the project and in the scientific community. Please acknowledge me if you find it is useful. :)

Xuehang
2019/08/02
