function [ fret, rawData ] = LoadFretData( file )
% [ fret, rawData ] = LoadFretData( file ) 
% Loads FRET data into matlab. 
% 
% Input:
%   file        the file name containing fluorophore data, itx format
% Output:
%	rawData    a nx2 matrix containing raw fluoresence for donor and
%               acceptor fluorophores
%	fret       a nx1 matrix containing the FRET data
%
% FRET is defined as: Acceptor / (Donor + Acceptor)
%
% This function expects the input file in itx format.  This consists of
% three header rows followed by data arranged in two columns.  The first 
% column of the input data is the donor intensity; the second column is the
% acceptor intensity.

% load ascii data
% This seems to work well with the .ITX files supplied by Lauryn.
[donor, acceptor] = textread(file, '%n%n', 'headerlines', 3, 'whitespace', ' \t\nEND');
rawData = [donor, acceptor];

% compute FRET
% note: we add eps to the denominator to avoid a divide by zero
fret = rawData(:,2) ./ (rawData(:,1) + rawData(:,2) + eps);

