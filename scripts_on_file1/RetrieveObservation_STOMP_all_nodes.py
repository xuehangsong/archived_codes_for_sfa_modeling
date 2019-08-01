####Retrieving results from STOMP plot files for selected variables at all nodes#####
####created by Xingyuan Chen in Aug 2012############
#### for batch mode #################################
##################################################### 
#!/usr/bin/python
import sys
import math
import os
import getopt

check_input = 0 #whether to double check the node numbers and variables to read are correct
#indices of random fields
#fields = range(2001,2201) + range(10801,11001)
#fields = [30,40]
fields = [] 
#number of digits for the name of realizations
ndigit_real = 3 

out_offset = 0 #offset of realization id in the output 
out_name = 'STOMP_output_All_Nodes' #name of output file   

#the maximum number of time steps 
ntime_upper = 10000
#the paths to all the files

paths = ['.']
ivars = []
obs = []

time_unit = 'y'

#if read the parameters from command line

letters = 'f:d:t:p:o:v:n:u:'
keywords = ['fields=', 'ndigit=','time_upper=','paths=','out_offset=','variable=','time_unit=' ]

opts, extraparams = getopt.getopt(sys.argv[1:],letters,keywords)
#print sys.argv
#print opts,extraparams
for o,p in opts:
    if o in ['-f','--fields']:
        if(not p.startswith('file:')):
            fields = [int(y.rstrip().lstrip()) for y in p.split(',')]
        if(p.startswith('file:')):
            fields_file = p.split('file:')[1]
            #open the file, nodes numbers delimited by ,
            file1 = open(fields_file,'r')
            #scan through the file and determine the set of variables available
            fields = []
            while(1):
                s = file1.readline()
                #strip the leading spaces on the left
                s = s.lstrip().rstrip()
                if(len(s)<1):
                    break
                if(not s.startswith('#')):
                    fields.append(s)
            fields = ''.join(fields)
            fields = [int(y.rstrip().lstrip()) for y in fields.split(',')]
            file1.close()
    elif o in ['-d','--ndigit']:
        ndigit_real = int(p.lstrip().rstrip())
    elif o in ['-t','--time_upper']:
        ntime_upper = int(p.lstrip().rstrip())
    elif o in ['-p','--path']:
        paths = p.split()
    elif o in ['-o','--out_offset']:
        out_offset = p     
    elif o in ['-v','--variable']:
        if(not p.startswith('file:')):
            ivars = [y.rstrip().lstrip() for y in p.split(',')]     
        if(p.startswith('file:')):
            vars_file = p.split('file:')[1]
            #open the file, nodes numbers delimited by ,
            file1 = open(vars_file,'r')
            #scan through the file and determine the set of variables available
            ivars = []
            while(1):
                s = file1.readline()
                #strip the leading spaces on the left
                s = s.lstrip().rstrip()
                if(len(s)<1):
                    break
                if(not s.startswith('#')):
                    ivars.append(s)
            ivars = ''.join(ivars)
            ivars = [y.rstrip().lstrip() for y in ivars.split(',')]     
            file1.close()
            #print ivars
    elif o in ['-u','--time_unit']:
        time_unit = p 

    
#print fields,ndigit_real,ntime_upper,paths,out_offset
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
    #print filenames
    #print timesteps
    n_steps = len(timesteps)
    n_file = len(filenames)
    #print n_parts,n_file
    # print filenames
    #read in information regarding the data blocks from the first file

    firstfile = open(filenames[0],'r')
    #scan through the file and determine the set of variables available
    while(1):
        end_of_search = 0
        lineread = []
        lenread = 0
        s = firstfile.readline()
        #strip the leading spaces on the left
        s = s.lstrip().rstrip()
        #read in number of nodes in each direction
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
    #to include all the nodes    
    w = range(1,nxyz+1)
    w = str(w)
    w = w.lstrip('[')
    w = w.rstrip(']')
    obs = w.split(',')

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
    firstfile.close()
    #print ivars,obs
    
    #ask user which variables to output if not specified
    if(len(ivars)<1):
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
    if(len(obs)<1):
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
        obs = w
        #double check with user the inputs are correct
    if(check_input):
        print 'Desired variables include:'
        for i in range(len(ivars)):
            print '%d: %s' % (i+1,vars[int(ivars[i])-1])
        print 'Desired observation points include:'
        print obs
        s = raw_input('Are these correct [y/n]?: ').lstrip().lower()
        if (s in ['n','no']):
            print 'recheck the nodes and variables to read and rerun!'
            sys.exit(1)
    nvars_to_read = len(ivars)
    vars_to_read = []
    for i in range(nvars_to_read):
        vars_to_read.append(vars[int(ivars[i])-1])

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
         #open files for the stomp plot files
        for ifile in range(n_steps):
            #output file name
            foutname = paths[ipath]+ '/' + out_name
            if len(fields)>0:
                name1 = 'R%d.tec' % (fields[ifield] + out_offset)
            else:
                name1 = '.tec'

            foutname = foutname + str(timesteps[ifile]) + name1

            fout = open(foutname,'w')
            # write out variable header
            fout.write('TITLE = ""')
            fout.write('\n')
            fout.write('VARIABLES= ')
            for ss in vars_to_read:
                fout.write('"' + ss + '" ')
            fout.write('\n')

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
                    if(time_unit in ['h','hour']):
                        time_h = float(time_s)/3600.0
                    if(time_unit in ['d','day']):
                        time_h = float(time_s)/(3600.0*24.0)
                    if(time_unit in ['m','month']):
                        time_h = float(time_s)/(3600.0*720.0)
                    if(time_unit in ['y','year']):
                        time_h = float(time_s)/(3600.0*720.0*365.0)
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
            fout.write('ZONE T = ')
            fout.write('"' + str(time_h) + ',' + time_unit +'", ')
            fout.write('I =' + str(nx) + ', J =' + str(ny) + ', K =' + str(nz) + ', F = POINT')
            fout.write('\n')
            for j in range(nobs):
                for i in range(nvars_to_read):
                    idx_idx = idxs.index(i)
                    fout.write(data_tmp[idx_idx][j])
                    fout.write('\t')
                fout.write('\n')
            fout.close()
    print paths[ipath]+' done'

