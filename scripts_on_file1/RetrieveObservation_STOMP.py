#####################################################
### For retrieving results from STOMP plot files#####
####created by Xingyuan Chen in July 2012############
##################################################### 
import sys
import math
import os

#indices of random fields
#fields = range(2001,2201) + range(10801,11001)
#fields = range(1,301)
fields = [] 
#number of digits for the name of realizations
ndigit_real = 3 

out_offset = 0 #offset of realization id in the output 
out_name = 'STOMP_output' #name of output file   

#the maximum number of time steps 
ntime_upper = 10000
#the paths to all the files

paths = ['.']

out_paths = paths
#names of the files
#for multiple paths
for ipath in range(len(paths)):
    timesteps = []
    filenames = []
    # for a single field
    if len(fields) == 0:
        for i in range(ntime_upper):
            name='plot.%d' % i
            filename = []
            filename.append(paths[ipath])
            filename.append(name)
            filename = '/'.join(filename)
            if os.path.exists(filename) == True:
                filenames.append(filename)
                timesteps.append(i)
    else:
    #for multiple fields, each field has a separate folder
        #determine the files available in each realization
        #folder is named by the realization number with same number of digits
        sub_path = str(fields[0]).rjust(ndigit_real,'0')
        for i in range(ntime_upper):
            name = 'plot.%d' % i
            filename = []
            filename.append(paths[ipath])
            filename.append(sub_path)
            filename.append(name)
            filename = '/'.join(filename)
            if os.path.exists(filename) == True:
                timesteps.append(i)
        for ifield in fields:
            sub_path = str(ifield).rjust(ndigit_real,'0')
            for istep in timesteps:
                name = 'plot.%d' % istep
                filename = []
                filename.append(paths[ipath])
                filename.append(sub_path)
                filename.append(name)
                filename = '/'.join(filename)
                filenames.append(filename)
    print timesteps
    n_steps = len(timesteps)
    n_file = len(filenames)
    #print n_parts,n_file
    # print filenames
    #read in information regarding the data blocks from the first file
    #Number of Time Steps =      1018
    #Time =  6.176453E+10,s  1.029409E+09,min  1.715682E+07,h  7.148673E+05,day  1.021239E+05,wk  1.957200E+03,yr

    #Number of X or R-Direction Nodes =     64
    #Number of Y or Theta-Direction Nodes =     56
    #Number of Z-Direction Nodes =    107

    firstfile = open(filenames[0],'r')
    #scan through the file and determine the set of variables available
    while(1):
        end_of_search = 0
        lineread = []
        lenread = 0
        s = firstfile.readline()
        #strip the leading spaces on the left
        s = s.lstrip().rstrip()
        if(s.startswith('Number of X')):
            a1 = s.split('=')
            nx = a1[1]
        if(s.startswith('Number of Y')):  
            a1 = s.split('=')
            ny = a1[1]
        if(s.startswith('Number of Z')):
            end_of_search = 1
            a1 = s.split('=')
            nz = a1[1]            
            break
    nxyz = int(nx)*int(ny)*int(nz)
    vars = []
    while(1):
        end_of_files_found = 0
        lineread = []
        lenread = 0
        s = firstfile.readline()
        #strip the leading spaces on the left
        if(len(s) == 0):
            end_of_files_found = 1
            break
        s = s.lstrip()
        w1 = s.split()
        #print w1
        if(len(w1)>0):
            try:
                float(w1[0])
            except:
                vars.append(s[:-1].rstrip())
        if end_of_files_found == 1:
            break
        #print lenread,len(headers)
    print vars
    #read in number of nodes in each direction
    
    #ask user which variables to output
    while (1): #prompt for the user input
        while (1): # for variables on each point
            for ivar in range(len(vars)):
                print '%d: %s' % (ivar+1,vars[ivar])
            print 'Enter the variable ids for each observation point, delimiting with spaces:'
            s = raw_input('-> ')
            ivars = s.split()
            for i in range(len(ivars)):
                if not ivars[i].isdigit():
                    print 'Entry %s not a recognized integer' % ivars[i]
                if int(ivars[i]) < 1 or int(ivars[i]) > len(vars):
                    print 'Entry %s is out of bound' % ivars[i]
            else:
                break
        while (1): #for observation point
            print 'The number of nodes in X-Dir is: %s' % nx
            print 'The number of nodes in Y-Dir is: %s' % ny
            print 'The number of nodes in Z-Dir is: %s' % nz
            print 'The total number of nodes is: %s' % nxyz                                    
            s = raw_input( 'Do you want to include all the locations?(y/n)').lstrip().lower()
            if (s in ['y','yes','ye']):
                w = range(1,nxyz+1)
                w = str(w)
                w = w.lstrip('[')
                w = w.rstrip(']')
                w = w.split(',')
            else:
                print 'Enter the observation location ids for the desired data, delimiting with spaces:'
                s = raw_input('-> ')
                w = s.split()
            for i in range(len(w)):
                if not w[i].lstrip().isdigit():
                    print 'Entry %s not a recognized integer' % w[i]
                if int(w[i]) < 1 or int(w[i]) > nxyz:
                    print 'Entry %s is out of bound' % w[i]
            else:
                break
        #double check with user the inputs are correct
        print 'Desired variables include:'
        for i in range(len(ivars)):
            print '%d: %s' % (i+1,vars[int(ivars[i])-1])
        print 'Desired observation points include:'
        print w
        s = raw_input('Are these correct [y/n]?: ').lstrip().lower()
        if (s in ['y','yes','ye']):
            break
    firstfile.close()
    nvars_to_read = len(ivars)
    vars_to_read = []
    for i in range(nvars_to_read):
        vars_to_read.append(vars[int(ivars[i])-1])

    obs = w
    nobs = len(obs)
    #print vars
    #print vars_to_read
    # the headers for output variables
    headers = []
    for ivar in vars_to_read:
        for iobs in obs:
            headers.append(iobs + ':' + ivar)
    #Retrieve the data from each file and write to output files
    for ifield in range(n_file/n_steps):
        #write the data to output file
        foutname = paths[ipath]+ '/' + out_name
        if len(fields)>0:
            name1 = 'R%d.dat' % (fields[ifield] + out_offset)
        else:
            name1 = '.dat'

        foutname = foutname + name1

        fout = open(foutname,'w')
        # write out variable header
        fout.write('Time [h],')
        for i in range(nobs*nvars_to_read):
            fout.write(headers[i])
            fout.write(',')
        fout.write('\n')

        #open files for the stomp plot files
        for ifile in range(n_steps):
            file_tmp = open(filenames[ifield * n_steps + ifile],'r')
            # read in the time
            data_tmp = []
            idxs = []
            nvars_read = 0
            while(1):
                lineread = []
                s = file_tmp.readline()
                #strip the leading spaces on the left and right
                s = s.lstrip().rstrip()
                if(s.startswith('Time =')):
                    a1 = s.split('=')
                    #print a1
                    time_s = a1[1].lstrip().split(',')[0] # time in the unit of second
                    time_h = float(time_s)/3600.0
                    #print time_h
                if s in vars_to_read:  # read in numbers until block for next variable
                    #print s
                    idx = vars_to_read.index(s)  
                    idxs.append(idx)
                    a1 = s.split()
                    block_tmp = []
                    while(1):
                        end_of_block = 0
                        ss = file_tmp.readline()  
                        ss = ss.lstrip().rstrip()
                        #print ss
                        ss_split = ss.split()
                        #print ss_split
                        try:
                            float(ss_split[0])
                            block_tmp.append(ss)  
                        except:
                            end_of_block = 1
                            break
                    block_tmp = ' '.join(block_tmp)
                    block_split = block_tmp.split()
                    print(len(block_split))
                    tmp = []
                    for iobs in obs:
                        tmp.append(block_split[int(iobs)-1]) 
                    data_tmp.append(tmp)
                    nvars_read = nvars_read + 1
                if(nvars_read == nvars_to_read):
                    file_tmp.close()
                    break
            #write time
            fout.write(str(time_h))
            fout.write('\t')
            for i in range(nvars_to_read):
                idx_idx = idxs.index(i)
                for j in range(nobs):
                    fout.write(data_tmp[idx_idx][j])
                    fout.write('\t')
            fout.write('\n')
        fout.close()
    print paths[ipath]+' done'
 