# for calculating flux averaging
import sys
import math
from numpy import *

#indices of random fields
fields = range(1,11)
n_field = len(fields)
#the paths to all the files
paths = ['Mar2011/IFRC2_EQ_0_Prior']
#paths = ['Mar2009/120x120x30/UK']


#wells for calculating flux averaging

#names of the files
names = []
if n_field == 0:
    names.append('OBS_output.dat')
else:
    for ifield in fields:
        name='OBS_outputR%d.dat' % ifield
        names.append(name)
if(len(paths) == 0):
    filenames = names
else:
    filenames = []
    for ipath in range(len(paths)):
        for iname in range(len(names)):
            filename = []
            filename.append(paths[ipath])
            filename.append(names[iname])
            filename = '/'.join(filename)
            filenames.append(filename)
#print filenames
# open files and determine column ids
n_file = len(filenames)
n_path = n_file/n_field
for ipath in range(n_path):
    for ifield in range(n_field):
        ifile = ipath * n_field + ifield
        fileid = open(filenames[ifile],'r')
        lastread = fileid.readline()
        headings = []
        while (1):
            if ('Well' in lastread):
                header = lastread.rstrip()
                header = header.rstrip(',')
                header = header.lstrip()
                heaser = header.lstrip(',')
                heading = header.split(',')
                for i in range(len(heading)):
                   headings.append(heading[i])
            else:
                break
            lastread = fileid.readline()
            if (len(lastread)<30):
                lastread = fileid.readline()
        #print headings,len(headings)
        #print lastread
        #end
        if ifile == 0: # only retrieve location and variable information from the first file 
            #print headers
            #find out how many observation points, the outputs start with Water Mass
            locations = []
            variablesall = []
            loc_part1 = []
            loc_part2 = []
            for iheader in range(1,len(headings)): #the first header is Time
                header = headings[iheader]
                if len(header) == 0:   # for extra space in the end
                    continue 
                header = header.split(' (')[0]
                # print header
                loc = header.rsplit(' ',1)[1]
                obs = header.rsplit(' ',1)[0]
                # print loc
                # print obs
                loc1 = loc.rsplit('_',1)[0]
                loc2 = loc.rsplit('_',1)[1]
                locations.append(loc)
                variablesall.append(obs)
                loc_part1.append(loc1)
                loc_part2.append(loc2)
            # find the unique elements in locations and variables
            wells = list(set(loc_part1))
            variables = sorted(list(set(variablesall)))
        
            #print locations
            print variables
            #print headers
            #ask user what observation points and which variables to output
            while (1): #prompt for the user input
                while (1): #for observation point
                    print 'The wells with data in the file include:'
                    for iloc in range(len(wells)):
                        print '%d: %s' % (iloc+1,wells[iloc])
                    s = raw_input( 'Do you want to include all the wells?(y/n)').lstrip().lower()
                    if (s in ['y','yes','ye']):
                        w = range(1,len(wells)+1)
                        w = str(w)
                        w = w.lstrip('[')
                        w = w.rstrip(']')
                        w = w.split(',')
                    else:                
                        print 'Enter the well ids for flux averaging, delimiting with spaces:'
                        s = raw_input('-> ')
                        w = s.split()
                    for i in range(len(w)):
                        if not w[i].lstrip().isdigit():
                            print 'Entry %s not a recognized integer' % w[i]
                        if int(w[i]) < 1 or int(w[i]) > len(wells):
                            print 'Entry %s is out of bound' % w[i]
                    else:
                        break
                while (1): # for variables on each point
                    for ivar in range(len(variables)):
                        print '%d: %s' % (ivar+1,variables[ivar])
                    print 'Enter the variable ids for each location, delimiting with spaces:'
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
                print 'Desired wells include:'
                for i in range(len(w)):
                    print '%d: %s' % (i+1,wells[int(w[i])-1])
        
                print 'Desired variables include:'
                for i in range(len(ivars)):
                    print '%d: %s' % (i+1,variables[int(ivars[i])-1])
                s = raw_input('Are these correct [y/n]?: ').lstrip().lower()
                if (s in ['y','yes','ye']):
                    break
              
            # for flux averaging
        allcolumns = [] #all the columns needed for flux averaging
        totalcolumns = 1
        for iwell in range(len(w)):
            well = wells[int(w[iwell])-1]
            # find all the columns corresponding to a well
            columns = []
            obs_pt = []
            for iloc in range(len(locations)):
                if well in locations[iloc]:
                    columns.append(iloc+1) # the first column time was not included in locations
                    obs_pt.append(locations[iloc])
            # find the unique observation points in each well
            unipts = list(set(obs_pt))
            wellcols = [] # all the columns corresponding to a well
            for ipt in range(len(unipts)):
                point = unipts[ipt]
                pointcols = (2 + len(ivars)) * [0] # all the columns corresponding to a point in a well
                for icol in columns:
                    # find velocities
                    if locations[icol-1] == point and variablesall[icol-1].startswith('vlx'):
                        pointcols[0] = icol
                    if locations[icol-1] == point and variablesall[icol-1].startswith('vly'):
                        pointcols[1] = icol
                    for ivar in range(len(ivars)):
                        if locations[icol-1] == point and variablesall[icol-1].startswith(variables[int(ivars[ivar])-1]):
                            pointcols[ivar+2] = icol
                wellcols.append(pointcols)
                totalcolumns = totalcolumns + len(pointcols)
            allcolumns.append(wellcols)
        #print w,ivars                    
        print allcolumns
        
        filename = filenames[ifile].replace('output','FluxAve')
        if filename == filenames[ifile]:
            sys.exit("The output file has same name as the input file!")^M

        fout = open(filename,'w')
    
        # write out variable header
        fout.write(headings[0])
        fout.write(',')
        for iwell in range(len(w)):
            for ivar in range(len(ivars)):
                colname = wells[int(w[iwell])-1] + ' ' + variables[int(ivars[ivar])-1]
                fout.write(colname)
                fout.write(',')
        fout.write('\n')
        while(1):
            end_of_all_files_found = 1
            ss = lastread.split()
            if len(ss) >= totalcolumns: #ensure a valid line is read
                end_of_all_files_found = 0
                fout.write(ss[0])
                fout.write('\t')
                for iwell in range(len(w)): # loop through wells
                    fluxave = len(ivars) * [0.0]
                    sumvl = 0.0
                    for ipt in range(len(allcolumns[iwell])): #loop through depths
                        cols = allcolumns[iwell][ipt]
                        vl = (float(ss[cols[0]])**2 + float(ss[cols[1]])**2)**0.5 #calculate velocity at the point
                        sumvl = sumvl + vl
                        for ivar in range(len(ivars)):
                            fluxave[ivar] = fluxave[ivar] + vl * float(ss[cols[2+ivar]])
                    if sumvl > 0.0:
                        fluxave = multiply(fluxave,1.0/sumvl)
                    else:
                        fluxave = multiply(fluxave,0.0)
                    # write the flux averaged values to output file
                    for ivar in range(len(ivars)):
                        fout.write(str(fluxave[ivar]))
                        fout.write('\t')
            else:
                for ivar in range(len(ivars)):
                    fout.write(' \t')
            fout.write('\n')
            lastread = fileid.readline()
            if end_of_all_files_found == 1:
                break  
        fileid.close()
        fout.close()

print 'done'
  
