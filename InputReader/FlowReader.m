function data = FlowReader(fname)
fileID = fopen(fname,'r');
X_data = textscan(fileID,'%s %s %s %s %s');
fclose(fileID);

origin_data = X_data(1);
destination_data = X_data(2);
volume_data = X_data(3);
capacity_data = X_data(4);

[rowNumber,c] = size(origin_data{1});
fprintf('row number = %d \n', rowNumber-1);
data = struct('OriginId',0,'DestinationId',0,'Volume',0,'Capacity',0);

for i = 2 : rowNumber
  data(i-1).OriginId = origin_data{1}{i}; 
  data(i-1).DestinationId = destination_data{1}{i}; 
  data(i-1).Volume = volume_data{1}{i}; 
  data(i-1).Capacity = capacity_data{1}{i};
end
disp(data);
end

