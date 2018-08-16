function data = TripsReader(fname,numberOfZones)
clc;
fileID = fopen(fname,'r');
tline = fgetl(fileID);
data = zeros(numberOfZones, numberOfZones);
originNumber = -1;
while ischar(tline)
    if(isempty(strfind(tline,'<')))
        disp(tline);
        originNumberLineChecker = textscan(fileID,'Origin %d');
        if(isempty(originNumberLineChecker) == false)
            originNumber = originNumberLineChecker{1};
             items = textscan(fileID,'%d : %d;',numberOfZones); 
        if(isempty(items{2})==false)
        for row = 1:numberOfZones
           data(originNumber,row) = items{2}(row);
        end
        end
        end
       
       
    end
    tline = fgetl(fileID);
end
fclose(fileID);
end

