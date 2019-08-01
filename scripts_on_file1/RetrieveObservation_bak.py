# For retrieving results at observation points 
import sys
import math
import os

#indices of random fields
fields = range(1,501)
#number of partitions per field
n_part = 128
#the wells to look at
wells = ['2-7']
#the paths to all the files
paths = ['120x120x30/A_MR_Oct2009_1']

#names of the files
filenames = []
if len(paths) == 0:
    # check for the nodes that print observation files
    # not all nodes in range(n_part) print observation files
    # and determine the pool of names
    parts = []
    if len(fields) == 0:
        for i in range(n_part):
            name = 'observation-%d.tec' % i
            if os.path.exists(name) == True:
                filenames.append(name)
                parts.append(i)
    else:
        #determine the files available in each realization
        parts = []
        for i in range(n_part):
            name = 'observationR1-%d.tec' % i
            if os.path.exists(name) == True :
                parts.append(i)
        for ifield in fields:
            name1 = 'observationR%d-' % ifield
            for ipart in parts:
                name2 = '%d.tec' % ipart
                filenames.append(name1 + name2)
else:
#for multiple paths
    for ipath in range(len(paths)):
        parts = []
        # for a single field
        if len(fields) == 0:
            for i in range(n_part):
                name='observation-%d.tec' % i
                filename = []
                filename.append(paths[ipath])
                filename.append(name)
                filename = '/'.join(filename)
                if os.path.exists(filename) == True:
                    filenames.append(filename)
                    parts.append(i)
        else:
        #for multiple fields
            parts = []
            #determine the files available in each realization
            for i in range(n_part):
                name='observationR1-%d.tec' % i
                filename = []
                filename.append(paths[ipath])
                filename.append(name)
                filename = '/'.join(filename)
                if os.path.exists(filename) == True:
                    parts.append(i)
            for ifield in fields:
                name1='observationR%d-' % ifield
                for ipart in parts:
                    name2='%d.tec' % ipart
                    name = name1 + name2
                    filename = []
                    filename.append(paths[ipath])
                    filename.append(name)
                    filename = '/'.join(filename)
                    filenames.append(filename)
n_part = len(parts)
# print filenames
# open files and determine column ids
for ifilename in range(0,len(filenames),n_part):
    files = []
    headersall = ''
    filecols = [] #number of columns in each partition of a field
    for ipart in range(n_part):
        files.append(open(filenames[ifilename+ipart],'r'))
        header = files[ifilename+ipart].readline()
        headings = header.split(',')
        headersall = headersall + header + ','
        filecols.append(len(headings))
    print headersall
    if ifilename == 0: # only read header from the files in the first realization
        headers = headersall.split(',')
        #print headers
        #find out how many observation points, the outputs start with P [Pa]
        locations = []
        variables = []
        nobs = 0
        for iheader in range(len(headers)):
            header = headers[iheader].replace('"','')
            headers[iheader] = header
            #print header
            if header.startswith('P [Pa]'):
                loc = header.strip(('P [Pa] '))
                loc = loc.split(' ')[0]
                locations.append(loc)
                nobs = nobs + 1
            if nobs == 1:
               obs = header.split(' ' + loc + ' ')[0]
               variables.append(obs)
        #print locations
        #print variables
        #print headers
        #ask user what observation points and which variables to output
        while (1): #prompt for the user input
            while (1): #for observation point
                for iloc in range(len(locations)):
                    print '%d: %s' % (iloc+1,locations[iloc])
                s = raw_input( 'Do you want to include all the locations?(y/n)').lstrip().lower()
                if (s in ['y','yes','ye']):
                    w = range(1,len(locations)+1)
                    w = str(w)
                    w = w.lstrip('[')
                    w = w.rstrip(']')
                    w = w.split(',')
                else:
                    print 'Enter the observation location ids for the desired data, delimiting with spaces:'
                    s = raw_input('-> ')
                    w = s.split()
                for i in range(len(w)):
                    if not w[i].isdigit():
                        print 'Entry %s not a recognized integer' % w[i]
                    if int(w[i]) < 1 or int(w[i]) > len(locations):
                        print 'Entry %s is out of bound' % w[i]
                else:
                    break
            while (1): # for variables on each point
                for ivar in range(len(variables)):
                    print '%d: %s' % (ivar+1,variables[ivar])
                print 'Enter the variable ids for each observation point, delimiting with spaces:'
                s = raw_input('-> ')
                ivars = s.split()
                for i in range(len(ivars)):
                    if not ivars[i].isdigit():
                        print 'Entry %s not a recognized integer' % ivars[i]
                    if int(ivars[i]) < 1 or int(ivars[i]) > len(variables):
                        print 'Entry %s is out of bound' % ivars[i]
                else:
                    break
        
            #double check with user the inputs are correct
            print 'Desired observation points include:'
            for i in range(len(w)):
                print '%d: %s' % (i+1,locations[int(w[i])-1])
        
            print 'Desired variables include:'
            for i in range(len(ivars)):
                print '%d: %s' % (i+1,variables[int(ivars[i])-1])
            s = raw_input('Are these correct [y/n]?: ').lstrip().lower()
            if (s in ['y','yes','ye']):
                break
              
        #determine in which file this column are and the column ids in each file
        columnsglobal = [0]
        #print w, len(w)
        #print ivars, len(ivars)
        #fine the global column ids
        for i in range(len(w)):
            for j in range(len(ivars)):
                colname = variables[int(ivars[j])-1] + ' ' + locations[int(w[i])-1]
                for k in range(len(headers)):
                    if headers[k].startswith(colname):
                        icol = k
                        columnsglobal.append(icol)
                        break
                else:
                    print colname+' is not found!'
        #determine the local column ids in each file
        columns = []
        filelocs = []
        for icol in columnsglobal:
            s0 = 0
            for ik in range(n_part):
                if icol >= s0 and icol < s0 + filecols[ik]:
                    filelocs.append(ik)
                    columns.append(icol - s0)
                    break
                else:
                    s0 = s0 + filecols[ik]

    #retrieve the columns for each realization
    print columnsglobal
    print columns
    print filelocs
    print files
    print filecols 
    filename = filenames[ifilename].replace('observation','OBS_output')
    fout = open(filename,'w')
    # write out variable header
    for icol in columnsglobal:
        fout.write(headers[icol])
        fout.write(',')
    fout.write('\n')
    while(1):
        end_of_all_files_found = 1
        lineread = []
        lenread = 0
        for ifile in range(len(files)):
            s = files[ifile].readline()
            w = s.split()
            lineread.append(w)
            lenread = lenread + len(w)
            #print lineread
        if lenread >= len(columns): #ensure a valid line is read
            end_of_all_files_found = 0
            for icol in range(len(columns)): 
                fout.write(lineread[filelocs[icol]][columns[icol]])
                fout.write('\t')
        else:
            for icol in range(len(columns)):
                fout.write(' \t')
        fout.write('\n')
        if end_of_all_files_found == 1:
            break
      
    for ifile in range(len(files)):
        files[ifile].close()
    fout.close()

print 'done'
  
