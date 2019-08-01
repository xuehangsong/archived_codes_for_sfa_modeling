# for retrieving mass balance data
import sys
import math

#indices of random fields
fields = range(1,501)
#the paths to all the files
#paths = ['120x120x30/A_EQ_Oct2009_0/res_7day','120x120x30/A_EQ_Oct2009_0/res_14day','120x120x30/A_EQ_Oct2009_0/res_21day']
paths = ['temp']

#names of the files
names = []
if len(fields) == 0:
    names.append('mass_balance.dat')
else:
    for ifield in fields:
        name='mass_balanceR%d.dat' % ifield
        names.append(name)
filenames = []
if len(paths) == 0:
    filenames = names
else:
    for ipath in range(len(paths)):
        for iname in range(len(names)):
            filename = []
            filename.append(paths[ipath])
            filename.append(names[iname])
            filename = '/'.join(filename)
            filenames.append(filename)
print filenames
# open files and determine column ids
for ifilename in range(len(filenames)):
    fileid = open(filenames[ifilename],'r')
    header = fileid.readline()
    headings = header.split(',')
    if ifilename == 0: # only read header from the files in the first realization
        #print headers
        #find out how many observation points, the outputs start with Water Mass
        locations = []
        variables = []
        nobs = 0
        for iheader in range(len(headings)):
            header = headings[iheader].replace('"','')
            headings[iheader] = header
            #print header
            if header.endswith('Water Mass [kg]'):
                loc = header.split(' Water ')[0]
                loc = loc.split('-')[1]
                locations.append(loc)
                nobs = nobs + 1
            if nobs == 1:
               obs = header.split(loc + ' ')[1]
               variables.append(obs)
        #print locations
        #print variables
        #print headers
        #ask user what observation points and which variables to output
        while (1): #prompt for the user input
            while (1): #for observation point
                for iloc in range(len(locations)):
                    print '%d: %s' % (iloc+1,locations[iloc])
                print 'Enter the location ids for mass balance, delimiting with spaces:'
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
            print 'Desired locations include:'
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
                colname = locations[int(w[i])-1]+ ' ' + variables[int(ivars[j])-1] 
                for k in range(len(headings)):
                    if colname in headings[k]:
                        icol = k
                        columnsglobal.append(icol)
                        break
                else:
                    print colname+' is not found!'

    #retrieve the columns for each realization
    print columnsglobal

    filename = filenames[ifilename].replace('mass_balance','MassB_output')
    if filename == filenames[ifilename]:
        sys.exit("The output file has same name as the input file!")
    fout = open(filename,'w')
    # write out variable header
    for icol in columnsglobal:
        fout.write(headings[icol])
        fout.write(',')
    fout.write('\n')
    while(1):
        end_of_all_files_found = 1
        s = fileid.readline()
        w = s.split()
        if len(w) >= len(columnsglobal): #ensure a valid line is read
            end_of_all_files_found = 0
            for icol in columnsglobal: 
                fout.write(w[icol])
                fout.write('\t')
        else:
            for icol in columnsglobal:
                fout.write(' \t')
        fout.write('\n')
        if end_of_all_files_found == 1:
            break
      
    fileid.close()
    fout.close()

print 'done'
  
