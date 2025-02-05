%%check model is exist
if(~strcmp(bdroot,'simulink') && ~isempty(bdroot))
    %%find double data type of the block 
    res = find_system(bdroot,'regexp','on','OutDataTypeStr','(Inheri|dou)\w+');
    disp('------double block start---------')
    for i = 1 : length(res)
        str = ['hilite_system(''' res{i} ''')'];
        disp(['<a href="matlab:' str '">' res{i} '</a>'])
    end
    disp('------double block end---------')
    disp('------unconnect line check---------')
    %%find unconnect lines
    line_handles_all = find_system(bdroot,'findall','on','Type','Line');
    for i = 1 : length(line_handles_all)
        if(strcmp(get(line_handles_all(i),'Connected'),'off'))
            str = ['hilite_system(''' get(get(line_handles_all(i),'SrcBlockHandle'),'Parent') ...
             '/' get(get(line_handles_all(i),'SrcBlockHandle'),'Name') ''')'];
            disp(['<a href="matlab:' str '">' res{i} '</a>'])
        end
    end
    disp('------unconnect line check---------')
else
    disp('No model')
end
