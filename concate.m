FileList = {'mnose2', 'meye2','mlips2'};
Value1 = [];
for iFile = 1:numel(FileList)
  Data  = load([FileList{iFile}, '.mat']);
  Field = struct2cell(Data);
  if length(Field) ~= 1
    error('Unexpected contents of [%s]', FileList{iFile});
  end
  Value1 = vertcat(Value1, Field{1});
end
save('Joinedtarget0.mat', 'Value1');