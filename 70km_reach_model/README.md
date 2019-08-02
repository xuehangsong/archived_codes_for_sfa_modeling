# Reach_scale_model 

This folder contains the codes for generating **PFLOTRAN** inputs and outputs.

## Pre-process in R
### 1. HFR_prepare_facies_boundary.R
* _INPUTS_: 
    1. geoFramework (.asc files) or "ascii.r" if exists
* _OUTPUTS_: 
    1. "geoframework.r" (contains list of geologic unit projected onto model domain, i.e. "cells_hanford", "cells_basalt"...)
    2. "model_inputs.r" (contains model coordinates x, y, z)

### 2. HFR_materials.R
* _INPUTS_: 
    1. "geoframework.r"
    2. Mass1 coordinates
    3. MASS1 outputs "transient_1976_2016/*"
    4. river geometry "river_geometry_manual.csv"
* _OUTPUTS_:
    1. **"HFR_material_river.h5"**
    2. "river_cell_coord.csv" 

### 3. HFR_initial_head.R
* _INPUTS_:
    1. "geoframework.r"
    2. well data ("mvAwln.csv", "HYDRAULIC_HEAD_MV.csv", "Burns_wells_data.csv", "300A_well_data"
* _OUTPUTS_: 
    1. **"HFR_H_2007_Initial.h5"**
    2. "well_compiled_wl_data.r"

### 4. HFR_river_bc.R
* _INPUTS_: 
    1. Mass1 coordinates
    2. "geoframework.r"
    3. MASS1 outputs "transient_1976_2016/*"
    4. mass.data.xts.r
* _OUTPUTS_: 
    1. **DatumH_Mass1_*.txt**
    2. **Gradients_Mass1_*.txt**
	
### 5. pflotran_input.R
* _INPUTS_: 
    1. "model_inputs.r" (contain model coordinates, grids...)
* _OUTPUTS_:
    1. **pflotran.in**

\*Note: outputs files in **bold** are used as model inputs
