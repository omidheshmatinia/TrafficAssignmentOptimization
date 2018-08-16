function data = NodeReader(fname)
clc;
fileID = fopen(fname,'r');
textscan(fileID,'%s %s %s ;',1);
items = textscan(fileID,'%d %d %d ;');
data = struct('X',0,'Y',0);
rowCount = numel(items{1});
for i=1:rowCount
    data(i).X = items{2}(i);
    data(i).Y = items{3}(i);
end
fclose(fileID);
end

