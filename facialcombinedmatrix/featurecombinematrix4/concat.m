FileList = {'joinedmatv13', 'target'};
Value11 = [];
for iFile = 1:numel(FileList)
  Data  = load([FileList{iFile}, '.mat']);
  Field = struct2cell(Data);
  if length(Field) ~= 1
    error('Unexpected contents of [%s]', FileList{iFile});
  end
  Value11 = cat(2, Value11, Field{1});
end
save('joinedtarget3', 'Value11');                    