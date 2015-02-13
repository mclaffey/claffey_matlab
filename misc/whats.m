function [] = whats(pth)
%WHATS(DIR) Lists Matlab files in directory DIR, with hypertext.
% If DIR is not specified, the current directory will be used.
% WHATS is meant to do what WHAT does, which is list the M-Files and
% MAT-Files in the specified directory, with the addition of listing the 
% FIG-Files.  The difference is that when WHATS displays the files, they 
% are hyperlinked so that clicking on a filename in the list will open it 
% for editing (M-Files), load the data (MAT-Files) or generate a stored 
% figure (FIG-Files).
% WHATS does not return a value.
%
% Examples:
%         To see what files are in the current directory, and gain easy
%         access to editing and/or loading saved data, simply type:
%  
%         whats
%
%         To see what files are in the directory on path , and gain easy
%         access to editing and/or loading saved data, simply type:
%
%         whats(PTH)
%
% See also what, dir
%
% Author: Matt Fig
% Contact: popkenai@yahoo.com
% 7/8/2008

if nargin ~= 1
    pth = pwd; % User wants the (or will get) the current directory.
    crnt = 'current '; % This is for display purposes later.
else
    crnt = '';  % For display purposes when user passed alt directory.
end

try
    W = what(pth);  % Use WHAT to get the files we want.
    D = dir(pth); % Use DIR to get the FIG-Files.
    fls = {D.name}';
    W(1).fig = fls(~cellfun('isempty',regexp(fls,'\.fig$'))); % FIG-Files.
catch
    error('Invalid path, make sure the path entered is correct.')
end

typ = {'M-Files','MAT-Files','FIG-Files'};  % Used in the for loop. 
cmd = {'edit','load','open'};  % So all file types done in same loop. 
fl = {'m','mat','fig'};  % Use dynamic struct access in first line of loop.

for kk = 1:3 % M-Files then MAT-Files then FIG-Files.
    if isempty(W(1).(fl{kk})),  continue,  end % None of this type of file.
    [lngth,nmlns,chlnk] = formatter(W,cmd{kk}); % See subfunction below.
    fprintf('\n%s\n\n',[typ{kk},' in the ',crnt,'directory ', W(1).path,...
            '  (click to ',cmd{kk},'):']) % Announce what is printing.  
    
    for ii = 1:nmlns
        fprintf('%s\n',chlnk(ii:nmlns:lngth,:)') % Print the lines.
    end 
    
end

fprintf('\n') % Provide a space between list and command prompt.


function [lngth,nmlns,chlnk] = formatter(W,str)
% Subfunction to whats.  Finds the number of lines needed to print the
% the M-File list, MAT-File list and the FIG-File list.  Also formats  
% the lists for the fprintf calls in WHATS.

switch str % M-Files, MAT-Files or FIG-Files.
    case 'edit'
        var = sort(W(1).m);  % Looking at M-Files.
        ext = 2;  % Length of the extention including the '.'
    case 'load'
        var = sort(W(1).mat); % Looking at MAT-Files.
        ext = 4;  % Length of the extention including the '.'
    otherwise
        var = sort(W(1).fig); % Looking at FIG-Files.
        ext = 4;
end

lngth = length(var);  % Start to calculate how many lines to display. 
mx = max(cellfun('length',var));   % Find the maximum string length.
cwsz = get(0,'commandwindowsize'); % Find out how many will fit.
vct = 1:75;  %  Try several different numbers to find how many lines.
vct = floor(cwsz(1)./(vct*mx + (vct-1)*3));  % ~3 spaces between strings.
nmprln = find(vct==1);  % Last index is the num per line, see next comment.
nmprln = nmprln(end); % For BC to ver 6.5: no 'last' arg to find func. :(
if isempty(nmprln),  nmprln=1;  end  % User has very small command window! 
nmlns = ceil(lngth/nmprln); % This is how many lines to display.

ch = char(var);  % Get a character array from the cell.
chlnk = cell(size(ch,1),1);  % Build a cell with hypertext.

for mm = 1:lngth
    db = deblank(ch(mm,:));  % For the html label.
    db = db(1:end-ext);  % Drop the extention on the label.
    chlnk{mm} = ['<a href="matlab:',str ,'(deblank(',' ''',W(1).path,...
                 filesep,ch(mm,:),'''','))','">',db,'</a>','    '];
end

chlnk = char(chlnk);  % Need the padding to get display spacing correct.