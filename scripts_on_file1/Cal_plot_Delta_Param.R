#This file is used to calculate the difference 

rm(list=ls())
#set the path to the files
main_path = '/files2/scratch/chenxy/'
file1 = 'Field_Generation/logK_3D_Kriged_Samples_600.txt' 
file2 = 'Tracer_Mar2011_UK3_KrigeFields_Inj5/logK_Post_Samples_10to100h_Err10_Iter1_set1.txt' 
data_file = 'Max_hange_logK_sample_10to100h_Err10_Iter1_from_prior.Rdata'
plot_file = 'Max_hange_logK_sample_10to25h_Err10_Iter1_from_prior.jpg'
fields = c(1:600)
nfields = length(fields)     # number of random fields
#load the ensemble of parameters
perm_par1 = read.table(file1)
perm_par2 = read.table(file2)
realization_by_row = F #whether realizations are presented in different rows
if(!realization_by_row)
{
        perm_par1 = t(perm_par1)
        perm_par2 = t(perm_par2)
}
#calculate the change
delta_perm = perm_par2 - perm_par1
#load the material ids for each permeability
material_ids = read.table('material_ids.txt')
##remove the cells that are located in the Ringold formation
delta_perm = delta_perm[,which(material_ids == 1)]
max_delta_perm = max(abs(delta_perm))
max_delta_perm_sample = numeric(nfields)
for(irel in fields)
	max_delta_perm_sample[irel] = max(abs(delta_perm[irel,]))
save(max_delta_perm_sample,file = data_file)

jpeg(plot_file, width = 5, height = 5,units="in",res=200,quality=100)
boxplot(max_delta_perm_sample)
dev.off()


