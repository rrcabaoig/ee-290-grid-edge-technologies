% Extract 5-min data (Mar 13 to Apr 18)
% 01ARMSOL_G01	solar
% 01BURGOS_G01	wind
% 01CAPRIS_G01	wind
% 01CLASOL_G01	solar
% 01CONSOL_G01	solar
% 01DALSOL_G01	solar
% 01NWIND_G01	wind

clear;

% Mar 13 to Mar 31
data = [];
for day = 13:31
    for time = 0:23
        clear source_file;
        clear source;
        clear source_arr;

        source_file = sprintf('RTDNE_202303%02d%02d00.csv', day, time);
        opts = detectImportOptions(source_file);
        opts = setvaropts(opts, {'RUN_TIME', 'TIME_INTERVAL', 'START_TIME', 'END_TIME'}, 'InputFormat', 'MM/dd/uuuu hh:mm:ss aa');

        source = readtable(source_file, opts);

        run_time = string(source.RUN_TIME);
        mkt_type = string(source.MKT_TYPE);
        region_name = string(source.REGION_NAME);
        zone_name = string(source.ZONE_NAME);
        resource_name = string(source.RESOURCE_NAME);
        time_interval = string(source.TIME_INTERVAL);
        start_time = string(source.START_TIME);
        end_time = string(source.END_TIME);
        mp_name = string(source.MP_NAME);
        self_sched_mw = string(source.SELF_SCHED_MW);

        source_arr = [run_time mkt_type region_name zone_name resource_name time_interval start_time end_time mp_name self_sched_mw];

        for row = 1:height(source)
            if source_arr(row, 5) == '01ARMSOL_G01' || source_arr(row, 5) == '01BURGOS_G01' || source_arr(row, 5) == '01CAPRIS_G01' || source_arr(row, 5) == '01CLASOL_G01' || source_arr(row, 5) == '01CONSOL_G01' || source_arr(row, 5) == '01DALSOL_G01' || source_arr(row, 5) == '01NWIND_G01'
                data = [data; source_arr(row, :)];
            end
        end

        disp(source_file);
    end
end
writematrix(data, '03_solar_wind_wesm.csv');


% Apr 1 to Apr 19
data = [];
for day = 1:19
    for time = 0:23
        clear source_file;
        clear source;
        clear source_arr;

        source_file = sprintf('RTDNE_202304%02d%02d00.csv', day, time);
        opts = detectImportOptions(source_file);
        opts = setvaropts(opts, {'RUN_TIME', 'TIME_INTERVAL', 'START_TIME', 'END_TIME'}, 'InputFormat', 'MM/dd/uuuu hh:mm:ss aa');

        source = readtable(source_file, opts);

        run_time = string(source.RUN_TIME);
        mkt_type = string(source.MKT_TYPE);
        region_name = string(source.REGION_NAME);
        zone_name = string(source.ZONE_NAME);
        resource_name = string(source.RESOURCE_NAME);
        time_interval = string(source.TIME_INTERVAL);
        start_time = string(source.START_TIME);
        end_time = string(source.END_TIME);
        mp_name = string(source.MP_NAME);
        self_sched_mw = string(source.SELF_SCHED_MW);

        source_arr = [run_time mkt_type region_name zone_name resource_name time_interval start_time end_time mp_name self_sched_mw];

        for row = 1:height(source)
            if source_arr(row, 5) == '01ARMSOL_G01' || source_arr(row, 5) == '01BURGOS_G01' || source_arr(row, 5) == '01CAPRIS_G01' || source_arr(row, 5) == '01CLASOL_G01' || source_arr(row, 5) == '01CONSOL_G01' || source_arr(row, 5) == '01DALSOL_G01' || source_arr(row, 5) == '01NWIND_G01'
                data = [data; source_arr(row, :)];
            end
        end

        disp(source_file);
    end
end
writematrix(data, '04_solar_wind_wesm.csv');