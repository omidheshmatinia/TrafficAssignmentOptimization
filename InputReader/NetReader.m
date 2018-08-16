function data = NetReader(fname)
clc;
fileID = fopen(fname,'r');
tline = fgetl(fileID);

data = struct('OriginId',0,'DestinationId',0,'Capacity',0,'Length',0,'FreeFlowTime',0,'B',0,'Power',0,'SpeedLimit',0,'Toll',0,'Type',0);
while ischar(tline)
    if(isempty(strfind(tline,'<')))
        %fgetl(fileID);
        items = textscan(fileID,' %d %d %f32 %d %d %f %d %d %d %d ;');
        rowNumber = numel(items{1});
        for i=1:rowNumber
            data(i).OriginId = items{1}(i);
            data(i).DestinationId = items{2}(i);
            data(i).Capacity = items{3}(i);
            data(i).Length = items{4}(i);
            data(i).FreeFlowTime = items{5}(i);
            data(i).B = items{6}(i);
            data(i).Power = items{7}(i);
            data(i).SpeedLimit = items{8}(i);
            data(i).Toll = items{9}(i);
            data(i).Type = items{10}(i);
        end
    end
    tline = fgetl(fileID);
end
fclose(fileID);
end

