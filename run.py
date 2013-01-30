#!/usr/bin/env python
# -*- coding: iso-8859-15 -*-
# Convert string to lower case up to the first occurrence of a separator
def lower_to_sep(string, separator='='):
	line=string.partition(separator)
	string=str(line[0]).lower()+str(line[1])+str(line[2])
	return string

from configobj import ConfigObj
import sys
import os
from subprocess import call

if (len(sys.argv) != 2):
	print "You need to give the configuration file"
	exit()

print "Using configuration file = "+sys.argv[1]

# Transform all keys to lowercase to avoid problems with
# upper/lower case
f = open(sys.argv[1],'r')
input_lines = f.readlines()
f.close()
input_lower = ['']
for l in input_lines:
	input_lower.append(lower_to_sep(l)) # Convert keys to lowercase

config = ConfigObj(input_lower)

prior_dict = {"U": '0', "G": '1', "D": '2'}

file = open('internalConf.input','w')

# Write general information
file.write(config['general']['number of parameters']+'\n')
file.write("'"+config['general']['file with the observed line']+"'\n")
file.write("'"+config['general']['output file root']+"'\n")
file.write("'"+config['general']['file with the database']+"'\n")

# Multinest behavior
file.write(config['multinest']['evidence tolerance']+'\n')
file.write(config['multinest']['maximum number of modes']+'\n')
file.write(config['multinest']['enlargement factor reduction']+'\n')
file.write(config['multinest']['number of live points']+'\n')

# Parameters
for l in config['parameters']['lower boundary']:
	file.write(l+" ")
file.write('\n')

for l in config['parameters']['upper boundary']:
	file.write(l+" ")
file.write('\n')

for l in config['parameters']['prior']:
	file.write("'"+l+"' ")
file.write('\n')

for l in config['parameters']['mean']:
	file.write(l+" ")
file.write('\n')

for l in config['parameters']['sigma']:
	file.write(l+" ")
	
file.close()

# Run the code
try:
	call(['./mcmc', 'internalConf.input'])
	os.remove('internalConf.input')
except:
	os.remove('internalConf.input')
	call(['pkill', '-9', 'mcmc'])
