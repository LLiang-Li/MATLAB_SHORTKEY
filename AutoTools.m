classdef AutoTools
    %UNTITLED4 Summary of this class goes here
    %   Detailed explanation goes here
    methods(Static)
        %%
        %table element name:
        %above or below: 1?0
        %is reboot recover
        %input name
        %inc name
        %dec name
        %active counter
        %inactive counter
        %enable flag
        %out name
        function WarningProtectGenerate(table_set, model_name)
            arguments
                table_set table
                model_name (1,:) char = bdroot
            end
            if(~istable(table_set))
                error('input not a table')
            end
            if(9 ~= size(table_set,2))
                error('input not a 1x8 table')
            end
            if(~isnumeric(table_set{1,1}))
                error('first col not number')
            end
            if(~isnumeric(table_set{1,2}))
                error('second col not number')
            end
            len = size(table_set,1);
            for i = 1 : len
                if(table_set{i,1})
                    handle_above = add_block('ENNP_BMS_Algorithm/Above Detect', [model_name '/Above Detect'],'MakeNameUnique','on');
                else
                    handle_above = add_block('ENNP_BMS_Algorithm/Below Detect', [model_name '/Below Detect'],'MakeNameUnique','on');
                end
                % handle_inc_step= add_block('simulink/Sources/Constant', [model_name '/inc_step']);
                handle_inc_step= add_block('simulink/Sources/Constant', [model_name '/Constant'],'MakeNameUnique','on');
                set(handle_inc_step, 'Value', char(table_set{i,4}))

                % handle_dec_step= add_block('simulink/Sources/Constant', [model_name '/dec_step']);
                handle_dec_step= add_block('simulink/Sources/Constant', [model_name '/Constant'],'MakeNameUnique','on');
                set(handle_dec_step, 'Value', char(table_set{i,5}))

                % handle_above_value= add_block('simulink/Sources/Constant', [model_name '/above_value']);
                handle_above_value= add_block('simulink/Sources/Constant', [model_name '/Constant'],'MakeNameUnique','on');
                set(handle_above_value, 'Value', char(table_set{i,6}))

                % handle_below_value= add_block('simulink/Sources/Constant', [model_name '/below_value']);
                handle_below_value= add_block('simulink/Sources/Constant', [model_name '/Constant'],'MakeNameUnique','on');
                set(handle_below_value, 'Value', char(table_set{i,7}))

                input_name = char(table_set{i,3});
                hanles_block_list = find_system(model_name, 'SearchDepth', 1 , 'BlockType', 'Inport', 'Name', input_name);
                if(isempty(hanles_block_list))
                    handle_input = add_block('simulink/Sources/In1', [model_name '/' input_name]);
                else
                    handle_input = add_block(hanles_block_list{1}, [model_name '/' input_name],'CopyOption', 'duplicate','MakeNameUnique','on');
                end
                input_flag_name = char(table_set{i,8});
                handle_input_flag = add_block('simulink/Sources/In1', [model_name '/' input_flag_name], 'MakeNameUnique','on');

                output_name = char(table_set{i,9});
                handle_output = add_block('simulink/Sinks/Out1', [model_name '/' output_name], 'MakeNameUnique','on');

                add_line(model_name, [get(handle_input,'Name') '/1'], [get(handle_above,'Name') '/1'])
                add_line(model_name, [get(handle_inc_step,'Name') '/1'], [get(handle_above,'Name') '/2'])
                add_line(model_name, [get(handle_above_value,'Name') '/1'], [get(handle_above,'Name') '/4'])
                add_line(model_name, [get(handle_below_value,'Name') '/1'], [get(handle_above,'Name') '/5'])
                add_line(model_name, [get(handle_input_flag,'Name') '/1'], [get(handle_above,'Name') '/6'])
                add_line(model_name, [get(handle_above,'Name') '/1'], [get(handle_output,'Name') '/1'])

                if (table_set{i,2} > 0)
                    add_line(model_name, [get(handle_dec_step,'Name') '/1'], [get(handle_above,'Name') '/3'])
                else
                    handles_unit_delay= add_block('simulink/Discrete/Unit Delay', [model_name '/Unit Delay'],'MakeNameUnique','on');
                    set(handles_unit_delay, 'InitialCondition', 'false')
                    handles_switch = add_block('simulink/Signal Routing/Switch', [model_name '/Switch'],'MakeNameUnique','on');
                    hanles_gain = add_block('simulink/Math Operations/Gain', [model_name '/Gain'],'MakeNameUnique','on');
                    set(hanles_gain,'Gain', '4');
                    set(hanles_gain,'OutDataTypeStr','int16')
                    add_line(model_name, [get(handle_inc_step,'Name') '/1'], [get(hanles_gain,'Name') '/1'])
                    add_line(model_name, [get(handle_above,'Name') '/1'], [get(handles_unit_delay,'Name') '/1'])
                    add_line(model_name, [get(handle_dec_step,'Name') '/1'], [get(handles_switch,'Name') '/1'])
                    add_line(model_name, [get(handles_unit_delay,'Name') '/1'], [get(handles_switch,'Name') '/2'])
                    add_line(model_name, [get(hanles_gain,'Name') '/1'], [get(handles_switch,'Name') '/3'])
                    add_line(model_name, [get(handles_switch,'Name') '/1'], [get(handle_above,'Name') '/3'])
                end
                Simulink.BlockDiagram.arrangeSystem(model_name)
            end
        end
    end
    methods(Static)
        function BlockConnect(src, dect, map)
            if(size(map,2) ~= 2)
                error('the matrix is not *x2')
            end
            now_sys = get_param(src, 'Parent');
            for i = 1 : size(map, 1)
                try
                    add_line(now_sys, [get_param(src, 'Name') '/' num2str(map(i,1))], [get_param(dect, 'Name') '/' num2str(map(i,2))])
                catch ME
                    warning([ME.identifier ' : ' ME.message])
                end
            end
        end
    end
end