% Perform multiple power flow runs (Newton-Raphson) to get the V in all buses
% For "true" value of test sets
clear;
define_constants;

headers{1} = 'scenario'
for col_num = 2:34
    col_bus = col_num - 1;
    col_name = sprintf('v_%d', col_bus);
    headers{col_num} = col_name;
end

%%% ========== Test Set (Normal Loading) ========== %%%

clear v_test;

pd_qd_test_file_path = '..\data\pd_qd_test.csv';
pd_qd_test = readmatrix(pd_qd_test_file_path);
pg_v_test_file_path = '..\data\pg_v_test.csv';
pg_v_test = readmatrix(pg_v_test_file_path);

mpc = loadcase('case33rrc');

for row = 1:3552

    %%% ===== PQ bus ===== %%%
    for col = 1:2:65
        if col == 1
            v_test(row, 1) = pd_qd_test(row, 1);
        else
            mpc.bus((col + 1)/2, PD) = pd_qd_test(row, col - 1);
            mpc.bus((col + 1)/2, QD) = pd_qd_test(row, col);
        end
    end

    %%% ===== PV bus ===== %%%
    mpc.gen(2, PG) = pg_v_test(row, 3);
    mpc.gen(3, PG) = pg_v_test(row, 5);
    mpc.gen(4, PG) = pg_v_test(row, 7);
    mpc.gen(5, PG) = pg_v_test(row, 9);
    mpc.gen(2, VG) = pg_v_test(row, 4);
    mpc.gen(3, VG) = pg_v_test(row, 6);
    mpc.gen(4, VG) = pg_v_test(row, 8);
    mpc.gen(5, VG) = pg_v_test(row, 10);

    results = runpf(mpc);

    for col_num = 2:34
        col_bus = col_num - 1;
        v_test(row, col_num) = results.bus(col_bus, VM);
    end
end

v_test = [headers; num2cell(v_test)];

v_test_file_path = '..\data\v_test.csv';
writecell(v_test, v_test_file_path);

%%% ========== Test Set (Simultaneous Increase in Load) ========== %%%

clear v_test_load_increase;

pd_qd_test_load_increase_file_path = '..\data\pd_qd_test_load_increase.csv';
pd_qd_test_load_increase = readmatrix(pd_qd_test_load_increase_file_path);
pg_v_test_load_increase_file_path = '..\data\pg_v_test_load_increase.csv';
pg_v_test_load_increase = readmatrix(pg_v_test_load_increase_file_path);

mpc = loadcase('case33rrc');

for row = 1:3552

    %%% ===== PQ bus ===== %%%
    for col = 1:2:65
        if col == 1
            v_test_load_increase(row, 1) = pd_qd_test_load_increase(row, 1);
        else
            mpc.bus((col + 1)/2, PD) = pd_qd_test_load_increase(row, col - 1);
            mpc.bus((col + 1)/2, QD) = pd_qd_test_load_increase(row, col);
        end
    end

    %%% ===== PV bus ===== %%%
    mpc.gen(2, PG) = pg_v_test_load_increase(row, 3);
    mpc.gen(3, PG) = pg_v_test_load_increase(row, 5);
    mpc.gen(4, PG) = pg_v_test_load_increase(row, 7);
    mpc.gen(5, PG) = pg_v_test_load_increase(row, 9);
    mpc.gen(2, VG) = pg_v_test_load_increase(row, 4);
    mpc.gen(3, VG) = pg_v_test_load_increase(row, 6);
    mpc.gen(4, VG) = pg_v_test_load_increase(row, 8);
    mpc.gen(5, VG) = pg_v_test_load_increase(row, 10);

    results = runpf(mpc);

    for col_num = 2:34
        col_bus = col_num - 1;
        v_test_load_increase(row, col_num) = results.bus(col_bus, VM);
    end
end

v_test_load_increase = [headers; num2cell(v_test_load_increase)];

v_test_load_increase_file_path = '..\data\v_test_load_increase.csv';
writecell(v_test_load_increase, v_test_load_increase_file_path);

%%% ========== Test Set (Solar PV and Wind Installation) ========== %%%
for pct_peak = 15:15:60
    clear v_test_solar_wind;
    
    pd_qd_test_solar_wind_file = sprintf('pd_qd_test_solar_wind_%d_pct.csv', pct_peak);
    pd_qd_test_solar_wind_file_path = fullfile('..\data\', pd_qd_test_solar_wind_file);
    pd_qd_test_solar_wind = readmatrix(pd_qd_test_solar_wind_file_path);
    pg_v_test_solar_wind_file = sprintf('pg_v_test_solar_wind_%d_pct.csv', pct_peak);
    pg_v_test_solar_wind_file_path = fullfile('..\data\', pg_v_test_solar_wind_file);
    pg_v_test_solar_wind = readmatrix(pg_v_test_solar_wind_file_path);
    
    mpc = loadcase('case33rrc');
    
    for row = 1:3552
    
        %%% ===== PQ bus ===== %%%
        for col = 1:2:65
            if col == 1
                v_test_solar_wind(row, 1) = pd_qd_test_solar_wind(row, 1);
            else
                mpc.bus((col + 1)/2, PD) = pd_qd_test_solar_wind(row, col - 1);
                mpc.bus((col + 1)/2, QD) = pd_qd_test_solar_wind(row, col);
            end
        end
    
        %%% ===== PV bus ===== %%%
        mpc.gen(2, PG) = pg_v_test_solar_wind(row, 3);
        mpc.gen(3, PG) = pg_v_test_solar_wind(row, 5);
        mpc.gen(4, PG) = pg_v_test_solar_wind(row, 7);
        mpc.gen(5, PG) = pg_v_test_solar_wind(row, 9);
        mpc.gen(2, VG) = pg_v_test_solar_wind(row, 4);
        mpc.gen(3, VG) = pg_v_test_solar_wind(row, 6);
        mpc.gen(4, VG) = pg_v_test_solar_wind(row, 8);
        mpc.gen(5, VG) = pg_v_test_solar_wind(row, 10);
    
        results = runpf(mpc);
    
        for col_num = 2:34
            col_bus = col_num - 1;
            v_test_solar_wind(row, col_num) = results.bus(col_bus, VM);
        end
    end
    
    v_test_solar_wind = [headers; num2cell(v_test_solar_wind)];
    
    v_test_solar_wind_file = sprintf('v_test_solar_wind_%d_pct.csv', pct_peak);
    v_test_solar_wind_file_path = fullfile('..\data\', v_test_solar_wind_file);
    writecell(v_test_solar_wind, v_test_solar_wind_file_path);
end